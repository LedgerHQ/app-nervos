#include "io.h"
#include "status_words.h"
#include "parser.h"
#include "apdu.h"
#include "globals.h"
#include "to_string.h"
#include "version.h"
#include "key_macros.h"
#include "ux.h" // G_ux

#include <stdbool.h>
#include <stdint.h>
#include <string.h>

size_t provide_pubkey(uint8_t *const io_buffer, cx_ecfp_public_key_t const *const pubkey) {
    check_null(io_buffer);
    check_null(pubkey);
    size_t tx = 0;
    io_buffer[tx++] = pubkey->W_len;
    memmove(io_buffer + tx, pubkey->W, pubkey->W_len);
    tx += pubkey->W_len;
    return finalize_successful_send(tx);
}

size_t provide_ext_pubkey(uint8_t *const io_buffer, extended_public_key_t const *const ext_pubkey) {
    check_null(io_buffer);
    check_null(ext_pubkey);
    size_t tx = 0;
    size_t keySize = ext_pubkey->public_key.W_len;
    io_buffer[tx++] = keySize;
    memmove(io_buffer + tx, ext_pubkey->public_key.W, keySize);
    tx += keySize;
    io_buffer[tx++] = CHAIN_CODE_DATA_SIZE;
    memmove(io_buffer + tx, ext_pubkey->chain_code, CHAIN_CODE_DATA_SIZE);
    tx += CHAIN_CODE_DATA_SIZE;
    return finalize_successful_send(tx);
}

void handle_apdu_error(uint8_t __attribute__((unused)) instruction) {
    THROW(EXC_INVALID_INS);
}

void handle_apdu_version(uint8_t __attribute__((unused)) instruction) {
    memcpy(G_io_apdu_buffer, &version, sizeof(version_t));
    size_t tx = sizeof(version_t);
    delay_successful(tx);
}

void handle_apdu_git(uint8_t __attribute__((unused)) instruction) {
    static const char commit[] = COMMIT;
    memcpy(G_io_apdu_buffer, commit, sizeof(commit));
    size_t tx = sizeof(commit);
    delay_successful(tx);
}

void handle_apdu_get_wallet_id(uint8_t __attribute__((unused)) instruction) {
    // blake2b hash of "nervos-ledger-id"
    static const uint8_t _U_ token[] = {0xc1, 0x30, 0xae, 0x5b, 0xf2, 0xfb, 0x61, 0xe3, 0x9e, 0x41, 0x9d, 0xc5, 0x8a,
                                        0x45, 0x4f, 0x4a, 0xb4, 0xb6, 0xe4, 0xb6, 0xdb, 0x0b, 0x4b, 0x34, 0x60, 0xc3,
                                        0xed, 0x12, 0x8e, 0xd5, 0x5f, 0xd2, 0x3d, 0x0a, 0x37, 0xc3, 0x75, 0x0b, 0xb2,
                                        0xb4, 0xd8, 0x0a, 0x74, 0x11, 0xe3, 0x68, 0x3b, 0x91, 0x80, 0x62, 0xab, 0x98,
                                        0xfd, 0x4d, 0x2c, 0x6d, 0x05, 0x95, 0xbb, 0x03, 0x30, 0x81, 0x78, 0xb6};
    // uint32_t id_path[] = {0x8000002C, 0x80000135};
    bip32_path_t id_path = {2, {0x8000002C, 0x80000135}};

    int rv = 0;
    cx_blake2b_t hashState;
    CX_ASSERT(cx_blake2b_init_no_throw(&hashState, 512));

    WITH_KEY_PAIR(id_path, key_pair, size_t, ({
                      PRINTF("\nPublic Key: %.*h\n", key_pair->public_key.W_len, key_pair->public_key.W);
                      // unsigned int _U_ info;
                      // This isn't working properly deterministically, so stubbing it to unblock development.
                      // cx_ecdsa_sign(&key, CX_LAST | CX_RND_RFC6979, CX_BLAKE2B, token, sizeof(token), signedToken,
                      // 100, &info);
                      // Stubbed until we have the sign step working.
                      // rv = cx_hash((cx_hash_t*) &hashState, CX_LAST, signedToken, sizeof(signedToken),
                      // G_io_apdu_buffer, sizeof(G_io_apdu_buffer));
                      CX_ASSERT(cx_hash_no_throw((cx_hash_t *)&hashState, CX_LAST, (uint8_t *)key_pair->public_key.W,
                                   key_pair->public_key.W_len, G_io_apdu_buffer, sizeof(G_io_apdu_buffer)));
                      rv = cx_hash_get_size((cx_hash_t *)&hashState);
                  }));
    delay_successful(rv);
}

#ifdef STACK_MEASURE
__attribute__((noinline)) void stack_sentry_fill() {
  uint32_t* p;
  volatile int top;

  (void)p;
  top=5;
  memset((void*)(&app_stack_canary+1), 42, ((uint8_t*)(&top-10))-((uint8_t*)&app_stack_canary));
}

void measure_stack_max() {
  uint32_t* p;
  volatile int top;
  for(p=(uint32_t*)&app_stack_canary+1; p<(uint32_t*)((&top)-10); p++)
    if(*p != 0x2a2a2a2a) {
	    PRINTF("Free space between globals and maximum stack: %d\n", 4*(p-&app_stack_canary));
	    return;
    }
}
#endif

#define CLA 0x80

void main_loop(apdu_handler const *const handlers, size_t const handlers_size) {
    // Length of APDU command received in G_io_apdu_buffer
    int input_len = 0;
    // Structured APDU command
    command_t cmd;

    io_init();
    for (;;) {
        // Receive command bytes in G_io_apdu_buffer
        if ((input_len = io_recv_command()) < 0) {
            PRINTF("=> io_recv_command failure\n");
            return;
        }

        // Parse APDU command from G_io_apdu_buffer
        if (!apdu_parser(&cmd, G_io_apdu_buffer, input_len)) {
            PRINTF("=> /!\\ BAD LENGTH: %.*H\n", input_len, G_io_apdu_buffer);
            io_send_sw(SWO_WRONG_DATA_LENGTH);
            continue;
        }

        PRINTF("=> CLA=%02X | INS=%02X | P1=%02X | P2=%02X | Lc=%02X | CData=%.*H\n",
               cmd.cla,
               cmd.ins,
               cmd.p1,
               cmd.p2,
               cmd.lc,
               cmd.lc,
               cmd.data);

        if (cmd.cla != CLA) {
            io_send_sw(SWO_INVALID_CLA);
            continue;
        }

        if (cmd.ins >= handlers_size) {
            io_send_sw(SWO_INVALID_INS);
            continue;
        }

        // Dispatch structured APDU command to handler
        apdu_handler const cb = handlers[cmd.ins];

        PRINTF("SIZOF1: %d SIZEOF2: %d\n", sizeof(G_ux), sizeof(G_ux_params));
        PRINTF("Calling handler\n");
        cb(cmd.ins);
        PRINTF("Normal return\n");
    }
}

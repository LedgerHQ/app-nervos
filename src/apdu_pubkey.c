#include "apdu_pubkey.h"

#include "apdu.h"
#include "cx.h"
#include "globals.h"
#include "keys.h"
#include "protocol.h"
#include "to_string.h"
#include "ui.h"
#include "segwit_addr.h"

#include <string.h>

#define G global.apdu.u.pubkey
#define GPriv global.apdu.priv

static bool pubkey_ok(void) {
    delayed_send(provide_pubkey(G_io_apdu_buffer, &G.ext_public_key.public_key));
    return true;
}

static bool ext_pubkey_ok(void) {
    delayed_send(provide_ext_pubkey(G_io_apdu_buffer, &G.ext_public_key));
    return true;
}

#define BIP32_HARDENED_PATH_BIT 0x80000000

static inline void bound_check_buffer(size_t counter, size_t size) {
    if (counter >= size) {
        THROW(EXC_MEMORY_ERROR);
    }
}

static void bip32_path_to_string(char *const out, size_t const out_size, apdu_pubkey_state_t const *const pubkey) {
    size_t out_current_offset = 0;
    for (int i = 0; i < MAX_BIP32_PATH && i < pubkey->key.length; i++) {
        bool is_hardened = pubkey->key.components[i] & BIP32_HARDENED_PATH_BIT;
        uint32_t component = pubkey->key.components[i] & ~BIP32_HARDENED_PATH_BIT;
        number_to_string_indirect32(out + out_current_offset, out_size - out_current_offset, &component);
        out_current_offset = strlen(out);
        if (is_hardened) {
            bound_check_buffer(out_current_offset, out_size);
            out[out_current_offset++] = '\'';
        }
        if (i < pubkey->key.length - 1) {
            bound_check_buffer(out_current_offset, out_size);
            out[out_current_offset++] = '/';
        }
        bound_check_buffer(out_current_offset, out_size);
        out[out_current_offset] = '\0';
    }
}

void render_pkh(char *const out, size_t const out_size,
                render_address_payload_t const *const payload, size_t payload_len) {
    uint8_t base32_buf[256];
    size_t base32_len = 0;

    if (!convert_bits(base32_buf, sizeof(base32_buf), &base32_len,
                      5,
                      (const uint8_t *)payload, payload_len,
                      8,
                      1)) {
        THROW(EXC_MEMORY_ERROR);
    }
    static const char hrbs[][4] = {"ckb", "ckt"};
    // https://github.com/nervosnetwork/rfcs/blob/master/rfcs/0021-ckb-address-format/0021-ckb-address-format.md#full-payload-format
    // CKB addresses are all encoded with bech32m. The bech32 encoding method is deprecated from CKB2021.
    bool is_bech32m = true;
    if (!bech32_encode(out, out_size, hrbs[N_data.address_type&ADDRESS_TYPE_MASK], base32_buf, base32_len, is_bech32m)) {
        THROW(EXC_MEMORY_ERROR);
    }
}

static void prompt_path(ui_callback_t ok_cb, ui_callback_t cxl_cb) {
    static size_t const ADDRESS_INDEX = 0;

    static const char *const pubkey_labels[] = {
        PROMPT("Address"),
        NULL,
    };
    register_ui_callback(ADDRESS_INDEX, lock_arg_to_sighash_address, &G.render_address_lock_arg);
    ui_prompt(pubkey_labels, ok_cb, cxl_cb);
}

static void prompt_ext_path(ui_callback_t ok_cb, ui_callback_t cxl_cb) {
    static size_t const TYPE_INDEX = 0;
    static size_t const DRV_PATH_INDEX = 1;
    static size_t const ADDRESS_INDEX = 2;

    static const char *const pubkey_labels[] = {
        PROMPT("Provide"),
        PROMPT("Derivation Path"),
        PROMPT("Address"),
        NULL,
    };
    REGISTER_STATIC_UI_VALUE(TYPE_INDEX, "Extended Public Key");
    register_ui_callback(DRV_PATH_INDEX, bip32_path_to_string, &G);
    register_ui_callback(ADDRESS_INDEX, lock_arg_to_sighash_address, &G.render_address_lock_arg);
    ui_prompt(pubkey_labels, ok_cb, cxl_cb);
}

void handle_apdu_get_public_key(uint8_t _U_ instruction) {
    const uint8_t *const dataBuffer = G_io_apdu_buffer + OFFSET_CDATA;

    uint8_t verify = READ_UNALIGNED_BIG_ENDIAN(uint8_t, &G_io_apdu_buffer[OFFSET_P1]);
    if ((verify != 0) && (verify != 1))
        THROW(EXC_WRONG_PARAM);

    size_t const cdata_size = READ_UNALIGNED_BIG_ENDIAN(uint8_t, &G_io_apdu_buffer[OFFSET_LC]);

    read_bip32_path(&G.key, dataBuffer, cdata_size);

    generate_extended_public_key(&G.ext_public_key, &G.key);

    // write lock arg
    generate_lock_arg_for_pubkey(&G.ext_public_key.public_key, &G.render_address_lock_arg);

    if (instruction == INS_PROMPT_EXT_PUBLIC_KEY) {
        if (verify) {
            prompt_ext_path(ext_pubkey_ok, delay_reject);
        } else {
            ext_pubkey_ok();
        }
    } else {
        if (verify) {
            prompt_path(pubkey_ok, delay_reject);
        } else {
            pubkey_ok();
        }
    }
}

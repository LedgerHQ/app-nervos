#include "globals.h"

#include "exception.h"
#include "to_string.h"

#include "ux.h"

#include <string.h>


// WARNING: ***************************************************
// Non-const globals MUST NOT HAVE AN INITIALIZER.
//
// Providing an initializer will cause the application to crash
// if you write to it.
// ************************************************************


globals_t global;

const uint8_t blake2b_personalization[] = "ckb-default-hash";

// These are strange variables that the SDK relies on us to define but uses directly itself.
ux_state_t G_ux;
bolos_ux_params_t G_ux_params;

unsigned char G_io_seproxyhal_spi_buffer[IO_SEPROXYHAL_BUFFER_SIZE_B];

void clear_apdu_globals(void) {
    memset(&global.apdu, 0, sizeof(global.apdu));
}

void init_globals(void) {
    memset(&global, 0, sizeof(global));

    memset(&G_ux, 0, sizeof(G_ux));
    memset(&G_ux_params, 0, sizeof(G_ux_params));

    memset(G_io_seproxyhal_spi_buffer, 0, sizeof(G_io_seproxyhal_spi_buffer));
}

// DO NOT TRY TO INIT THIS. This can only be written via an system call.
// The "N_" is *significant*. It tells the linker to put this in NVRAM.
nvram_data const N_data_real;

void switch_network() {
    nvram_data data;
    memcpy(&data, (const void*)&N_data, sizeof(nvram_data));
    const bool isMain = data.address_type == ADDRESS_MAINNET;
    data.address_type = isMain ? ADDRESS_TESTNET : ADDRESS_MAINNET;
    if(isMain)
      strcpy(data.network_prompt, "testnet");
    else
      strcpy(data.network_prompt, "mainnet");

    nvm_write((void*)&N_data, (void*)&data, sizeof(N_data));
}
void switch_sign_hash() {
    nvram_data data;
    memcpy(&data, (const void*)&N_data, sizeof(nvram_data));
    const bool isOn = data.sign_hash_type == SIGN_HASH_ON;
    data.sign_hash_type = isOn ? SIGN_HASH_OFF : SIGN_HASH_ON;
    if(isOn)
      strcpy(data.sign_hash_prompt, "Off");
    else
      strcpy(data.sign_hash_prompt, "On");
    nvm_write((void*)&N_data, (void*)&data, sizeof(N_data));
}
void switch_contract_data() {
    nvram_data data;
    memcpy(&data, (const void*)&N_data, sizeof(nvram_data));
    const bool isOn = data.contract_data_type == ALLOW_CONTRACT_DATA;
    data.contract_data_type = isOn ? DISALLOW_CONTRACT_DATA : ALLOW_CONTRACT_DATA;
    if(isOn)
      strcpy(data.contract_data_prompt, "Off");
    else
      strcpy(data.contract_data_prompt, "On");
    nvm_write((void*)&N_data, (void*)&data, sizeof(N_data));
}

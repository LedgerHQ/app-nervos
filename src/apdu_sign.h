#pragma once

#include "apdu.h"

void handle_apdu_sign(uint8_t instruction);
size_t handle_apdu_sign_with_hash(uint8_t instruction);
void handle_apdu_sign_message(uint8_t instruction);
void handle_apdu_sign_message_hash(uint8_t instruction);

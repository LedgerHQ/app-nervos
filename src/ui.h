#pragma once

#include "os_io_seproxyhal.h"

#include "types.h"

void ui_initial_screen(void);
void ui_init(void);
void ui_refresh(void);

void exit_app(void); // Might want to send it arguments to use as callback

// Displays labels (terminated with a NULL pointer) associated with data
// labels must be completely static string constants while data may be dynamic
// Assumes we've registered appropriate callbacks to generate the data.
// All pointers may be unrelocated.
void ui_prompt_debug(size_t screen_count);
void ui_prompt(const char *const *labels, ui_callback_t ok_c, ui_callback_t cxl_c);
void ui_prompt_with_cb(void (*switch_foo)(size_t), size_t prompt_count, ui_callback_t ok_c, ui_callback_t cxl_c);
void switch_screen(uint32_t which);


// This function registers how a value is to be produced
void register_ui_callback(uint32_t which, string_generation_callback cb, const void *data);
#define REGISTER_STATIC_UI_VALUE(index, str) register_ui_callback(index, copy_string, STATIC_UI_VALUE(str))

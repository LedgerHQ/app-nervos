#ifdef HAVE_NBGL

#include "ui.h"

void ui_initial_screen(void) {
}

void ui_refresh(void) {
}

void ui_prompt(const char *const *labels, ui_callback_t ok_c, ui_callback_t cxl_c) {
    (void)labels;
    (void)ok_c;
    (void)cxl_c;
}

void ui_prompt_with_cb(void (*switch_foo)(size_t),
                       size_t prompt_count,
                       ui_callback_t ok_c,
                       ui_callback_t cxl_c) {
    (void)switch_foo;
    (void)prompt_count;
    (void)ok_c;
    (void)cxl_c;
}


#endif // HAVE_NBGL

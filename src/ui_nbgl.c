#ifdef HAVE_NBGL

#include "nbgl_use_case.h"
#include "ui.h"
#include "glyphs.h"

void ui_initial_screen(void) {
    nbgl_useCaseHome(APPNAME,
                     &C_stax_nervos_64px,
                     NULL,
                     true,
                     NULL,
                     exit_app);
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

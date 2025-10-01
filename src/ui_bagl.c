#ifdef HAVE_BAGL

#include "bolos_target.h"

#include "ui.h"

#include "exception.h"
#include "globals.h"
#include "glyphs.h" // ui-menu
#include "keys.h"
#include "memory.h"
#include "os_cx.h" // ui-menu
#include "to_string.h"
#include "ux.h"
#include "main_std_app.h" // app_exit

#include <stdbool.h>
#include <string.h>


#define G global.ui

void ui_refresh(void) {
    ux_stack_display(0);
}

void ui_cfg_screen(size_t);
void ui_initial_screen(void);

void switch_network_cb(void) {
    switch_network();
    ui_cfg_screen(0);
}

void switch_sign_hash_cb(void) {
    switch_sign_hash();
    ui_cfg_screen(1);
}

void switch_contract_data_cb(void) {
    switch_contract_data();
    ui_cfg_screen(2);
}

UX_STEP_CB(
    ux_cfg_flow_1_step,
    bn,
    switch_network_cb(),
    {
      "Addresses for",
      N_data_real.network_prompt
    });
UX_STEP_CB(
    ux_cfg_flow_2_step,
    bn,
    switch_sign_hash_cb(),
    {
      "Allow sign hash",
      N_data_real.sign_hash_prompt
    });
UX_STEP_CB(
    ux_cfg_flow_3_step,
    bn,
    switch_contract_data_cb(),
    {
      "Allow contract data",
      N_data_real.contract_data_prompt
    });
UX_STEP_CB(
    ux_cfg_flow_4_step,
    bn,
    ui_initial_screen(),
    {
      "Main menu",
      ""
    });
UX_FLOW(ux_cfg_flow,
        &ux_cfg_flow_1_step,
        &ux_cfg_flow_2_step,
        &ux_cfg_flow_3_step,
        &ux_cfg_flow_4_step
       );

UX_STEP_NOCB(
    ux_idle_flow_1_step,
    bn,
    {
      "Nervos",
      APPVERSION
    });
UX_STEP_CB(
    ux_idle_flow_cfg_step,
    bn,
    ui_cfg_screen(0),
    {
      "Configuration",
      ""
    });
UX_STEP_CB(
    ux_idle_flow_quit_step,
    pb,
    app_exit(),
    {
      &C_icon_dashboard_x,
      "Quit",
    });

UX_FLOW(ux_idle_flow,
    &ux_idle_flow_1_step,
    &ux_idle_flow_cfg_step,
    &ux_idle_flow_quit_step
);

// prompt
#define PROMPT_SCREEN_NAME(idx) ux_prompt_flow_ ## idx ## _step
#define EVAL(...) __VA_ARGS__
#define BLANK()
#define PROMPT_SCREEN_TPL(idx) \
    EVAL(UX_STEP_NOCB_INIT BLANK() ( \
        PROMPT_SCREEN_NAME(idx), \
        bnnn_paging, \
        G.switch_screen(idx-G.prompt.offset),\
        { \
            .title = G.prompt.active_prompt, \
            .text = G.prompt.active_value, \
        }))

PROMPT_SCREEN_TPL(0);
PROMPT_SCREEN_TPL(1);
PROMPT_SCREEN_TPL(2);
PROMPT_SCREEN_TPL(3);
PROMPT_SCREEN_TPL(4);
PROMPT_SCREEN_TPL(5);
PROMPT_SCREEN_TPL(6);
PROMPT_SCREEN_TPL(7);

static void prompt_response(bool const accepted) {
    ui_initial_screen();
    if (accepted) {
        G.ok_callback();
    } else {
        G.cxl_callback();
    }
}

UX_STEP_CB(
    ux_prompt_flow_accept_step,
    pb,
    prompt_response(true),
    {
        &C_icon_validate_14,
        "Accept"
    });

UX_STEP_CB(
    ux_prompt_flow_reject_step,
    pb,
    prompt_response(false),
    {
        &C_icon_crossmark,
        "Reject"
    });

UX_FLOW(ux_prompts_flow,
    &PROMPT_SCREEN_NAME(0),
    &PROMPT_SCREEN_NAME(1),
    &PROMPT_SCREEN_NAME(2),
    &PROMPT_SCREEN_NAME(3),
    &PROMPT_SCREEN_NAME(4),
    &PROMPT_SCREEN_NAME(5),
    &PROMPT_SCREEN_NAME(6),
    &PROMPT_SCREEN_NAME(7),
    &ux_prompt_flow_reject_step,
    &ux_prompt_flow_accept_step
);
_Static_assert(NUM_ELEMENTS(ux_prompts_flow) - 3 /*reject + accept + end*/ == MAX_SCREEN_COUNT, "ux_prompts_flow doesn't have the same number of screens as MAX_SCREEN_COUNT");

void ui_cfg_screen(size_t i) {

    // reserve a display stack slot if none yet
    if(G_ux.stack_count == 0) {
        ux_stack_push();
    }
    ux_flow_init(0, ux_cfg_flow, ux_cfg_flow[i]);

}

void ui_initial_screen(void) {

    // reserve a display stack slot if none yet
    if(G_ux.stack_count == 0) {
        ux_stack_push();
    }
    ux_flow_init(0, ux_idle_flow, NULL);

}

void ui_prompt_with_cb(void (*switch_screen_cb)(uint32_t), size_t screen_count, ui_callback_t ok_c, ui_callback_t cxl_c) {
    check_null(switch_screen_cb);
    if(screen_count>MAX_SCREEN_COUNT) THROW(EXC_MEMORY_ERROR);

    G.switch_screen=switch_screen_cb;
    G.prompt.offset=MAX_SCREEN_COUNT-screen_count;

    ui_prompt_debug(screen_count);

    G.ok_callback = ok_c;
    G.cxl_callback = cxl_c;
    ux_flow_init(0, &ux_prompts_flow[G.prompt.offset], NULL);
}

#endif // HAVE_BAGL

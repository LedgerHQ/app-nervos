#ifdef HAVE_NBGL

#include "nbgl_use_case.h"
#include "ui.h"
#include "glyphs.h"
#include "globals.h"


enum {
    TESTNET_ADDR_TOKEN = FIRST_USER_TOKEN,
    SIGN_HASH_TOKEN,
    CONTRACT_DATA_TOKEN
};

static const char* const infoTypes[] = {
    "Version"
};

static const char* const infoContents[] = {
    VERSION
};


static nbgl_layoutSwitch_t switches[3];

static bool settings_nav(uint8_t page, nbgl_pageContent_t *content) {
    switch (page) {
        case 0:
            switches[0] = (nbgl_layoutSwitch_t) {
                .initState = (N_data.address_type == ADDRESS_TESTNET) ? ON_STATE : OFF_STATE,
                .text = "Testnet addresses",
                .subText = "Instead of mainnet",
                .token = TESTNET_ADDR_TOKEN,
                .tuneId = TUNE_TAP_CASUAL
            };
            switches[1] = (nbgl_layoutSwitch_t) {
                .initState = (N_data.sign_hash_type == SIGN_HASH_ON) ? ON_STATE : OFF_STATE,
                .text = "Allow sign hash",
                .subText = NULL,
                .token = SIGN_HASH_TOKEN,
                .tuneId = TUNE_TAP_CASUAL
            };
            switches[2] = (nbgl_layoutSwitch_t) {
                .initState = (N_data.contract_data_type == ALLOW_CONTRACT_DATA) ? ON_STATE : OFF_STATE,
                .text = "Allow contract data",
                .subText = NULL,
                .token = CONTRACT_DATA_TOKEN,
                .tuneId = TUNE_TAP_CASUAL
            };
            content->type = SWITCHES_LIST;
            content->switchesList.nbSwitches = 3;
            content->switchesList.switches = (nbgl_layoutSwitch_t*)switches;
            break;
        case 1:
            content->type = INFOS_LIST;
            content->infosList.nbInfos = 1;
            content->infosList.infoTypes = (const char**)infoTypes;
            content->infosList.infoContents = (const char**)infoContents;
            break;
    }
    return true;
}

static void settings_ctrl(int token, uint8_t index) {
    (void)index;
    uint8_t value;

    switch (token) {
        case TESTNET_ADDR_TOKEN:
            value = (N_data.address_type == ADDRESS_TESTNET) ? ADDRESS_MAINNET : ADDRESS_TESTNET;
            nvm_write((void*)&N_data.address_type, (void*)&value, sizeof(value));
            break;
        case SIGN_HASH_TOKEN:
            value = (N_data.sign_hash_type == SIGN_HASH_ON) ? SIGN_HASH_OFF : SIGN_HASH_ON;
            nvm_write((void*)&N_data.sign_hash_type, (void*)&value, sizeof(value));
            break;
        case CONTRACT_DATA_TOKEN:
            value = (N_data.contract_data_type == ALLOW_CONTRACT_DATA) ? DISALLOW_CONTRACT_DATA : ALLOW_CONTRACT_DATA;
            nvm_write((void*)&N_data.contract_data_type, (void*)&value, sizeof(value));
            break;
    }
}

static void ui_settings(void) {
    nbgl_useCaseSettings(APPNAME" settings",
                         0,
                         2,
                         true,
                         ui_initial_screen,
                         settings_nav,
                         settings_ctrl);
}

void ui_initial_screen(void) {
    nbgl_useCaseHome(APPNAME,
                     &C_stax_nervos_64px,
                     NULL,
                     true,
                     ui_settings,
                     exit_app);
}

static nbgl_layoutTagValue_t pair;

static void reviewChoice(bool confirm) {
    if (confirm) {
        nbgl_useCaseStatus("TRANSACTION\nSIGNED", true, ui_initial_screen);
        global.ui.ok_callback();
    } else {
        global.ui.cxl_callback();
        ui_initial_screen();
    }
}

static bool get_data(uint8_t page, nbgl_pageContent_t *content) {
    uint8_t screen_count = MAX_SCREEN_COUNT - global.ui.prompt.offset;

    if (page < screen_count) {
        content->type = TAG_VALUE_LIST;
        content->tagValueList.nbPairs = 1;
        content->tagValueList.pairs = &pair;
        content->tagValueList.smallCaseForValue = false;
        global.ui.switch_screen(page);
    } else if (page == screen_count) {
        content->type = INFO_LONG_PRESS;
        content->infoLongPress.icon = &C_stax_nervos_64px;
        content->infoLongPress.text = "Confirm "APPNAME" action";
        content->infoLongPress.longPressText = "Hold to approve";
    } else { // > screen_count
        return false;
    }
    return true;
}

void ui_prompt(const char *const *labels, ui_callback_t ok_c, ui_callback_t cxl_c) {
    size_t prompt_count;

    check_null(labels);
    global.ui.prompt.prompts = labels;
    prompt_count = 0;
    while ((prompt_count < MAX_SCREEN_COUNT) && (labels[prompt_count] != NULL)) {
        prompt_count++;
    }
    ui_prompt_with_cb(switch_screen, prompt_count, ok_c, cxl_c);
}

void ui_prompt_with_cb(void (*switch_screen_cb)(size_t),
                       size_t prompt_count,
                       ui_callback_t ok_c,
                       ui_callback_t cxl_c) {
    check_null(switch_screen_cb);
    global.ui.switch_screen = switch_screen_cb;
    global.ui.ok_callback = ok_c;
    global.ui.cxl_callback = cxl_c;
    pair.item = global.ui.prompt.active_prompt;
    pair.value = global.ui.prompt.active_value;
    global.ui.prompt.offset = MAX_SCREEN_COUNT - prompt_count;
    nbgl_useCaseRegularReview(0,
                              prompt_count + 1,
                              "Reject",
                              NULL,
                              get_data,
                              reviewChoice);
}


#endif // HAVE_NBGL

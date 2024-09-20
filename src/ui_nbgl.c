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
#define TOKEN_TO_ID(token) (token - TESTNET_ADDR_TOKEN)

static const char* const infoTypes[] = {
    "Version"
};

static const char* const infoContents[] = {
    VERSION
};

#define SETTINGS_NB_SWITCHES 3
static nbgl_layoutSwitch_t switches[SETTINGS_NB_SWITCHES] = {0};

static void settings_ctrl(int token, uint8_t index, int page) {
    UNUSED(index);
    UNUSED(page);
    uint8_t value;
    uint8_t switch_id;

    switch_id = TOKEN_TO_ID(token);
    switch (token) {
        case TESTNET_ADDR_TOKEN:
            value = (N_data.address_type == ADDRESS_TESTNET) ? ADDRESS_MAINNET : ADDRESS_TESTNET;
            switches[switch_id].initState = (nbgl_state_t) value;
            nvm_write((void*)&N_data.address_type, (void*)&value, sizeof(value));
            break;
        case SIGN_HASH_TOKEN:
            value = (N_data.sign_hash_type == SIGN_HASH_ON) ? SIGN_HASH_OFF : SIGN_HASH_ON;
            switches[switch_id].initState = (nbgl_state_t) value;
            nvm_write((void*)&N_data.sign_hash_type, (void*)&value, sizeof(value));
            break;
        case CONTRACT_DATA_TOKEN:
            value = (N_data.contract_data_type == ALLOW_CONTRACT_DATA) ? DISALLOW_CONTRACT_DATA : ALLOW_CONTRACT_DATA;
            switches[switch_id].initState = (nbgl_state_t) value;
            nvm_write((void*)&N_data.contract_data_type, (void*)&value, sizeof(value));
            break;
    }
}


void ui_initial_screen(void) {
    static nbgl_contentInfoList_t infosList = {0};
    static nbgl_genericContents_t settingContents = {0};
    static nbgl_content_t content = {0};

    infosList.nbInfos = 1;
    infosList.infoTypes = (const char**) infoTypes;
    infosList.infoContents = (const char**) infoContents;

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

    content.type = SWITCHES_LIST;
    content.content.switchesList.nbSwitches = SETTINGS_NB_SWITCHES;
    content.content.switchesList.switches = switches;
    content.contentActionCallback = settings_ctrl;

    settingContents.callbackCallNeeded = false;
    settingContents.contentsList = &content;
    settingContents.nbContents = 1;

    nbgl_useCaseHomeAndSettings(APPNAME,
                                &C_app_nervos_64px,
                                NULL,
                                INIT_HOME_PAGE,
                                &settingContents,
                                &infosList,
                                NULL,
                                exit_app);
}

static nbgl_layoutTagValue_t pair;
static nbgl_layoutTagValueList_t pair_list;
char tag[MAX_SCREEN_COUNT][PROMPT_WIDTH + 1];
char value[MAX_SCREEN_COUNT][VALUE_WIDTH + 1];

static void reviewChoice(bool confirm) {
    if (confirm) {
        global.ui.ok_callback();
        nbgl_useCaseReviewStatus(STATUS_TYPE_TRANSACTION_SIGNED, ui_initial_screen);
    } else {
        global.ui.cxl_callback();
        nbgl_useCaseReviewStatus(STATUS_TYPE_TRANSACTION_REJECTED, ui_initial_screen);
    }
}

static nbgl_layoutTagValue_t *get_pair(uint8_t index) {
    // Out-of-bounds check on index done in switch_screen function
    global.ui.switch_screen(index);
    strncpy(tag[index], global.ui.prompt.active_prompt, sizeof(tag[index]));
    strncpy(value[index], global.ui.prompt.active_value, sizeof(value[index]));
    pair.item = tag[index];
    pair.value = value[index];
    return &pair;
}

void ui_prompt_with_cb(void (*switch_screen_cb)(size_t),
                       size_t prompt_count,
                       ui_callback_t ok_c,
                       ui_callback_t cxl_c) {
    check_null(switch_screen_cb);

    pair_list.nbMaxLinesForValue = 0;
    pair_list.nbPairs = prompt_count;
    pair_list.pairs = NULL;
    pair_list.callback = get_pair;
    pair_list.startIndex = 0;

    global.ui.switch_screen = switch_screen_cb;
    global.ui.ok_callback = ok_c;
    global.ui.cxl_callback = cxl_c;
    global.ui.prompt.offset = MAX_SCREEN_COUNT - prompt_count;

    nbgl_useCaseReview(TYPE_TRANSACTION,
                        &pair_list,
                        &C_app_nervos_64px,
                        "Confirm "APPNAME" action",
                        NULL,
                        "Confirm "APPNAME" action",
                        reviewChoice);
}


#endif // HAVE_NBGL

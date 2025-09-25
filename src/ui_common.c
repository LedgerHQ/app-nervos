#include "ui.h"
#include "ux.h"

#include "globals.h"
#include "os.h"

#ifdef HAVE_BAGL
void io_seproxyhal_display(const bagl_element_t *element) {
    return io_seproxyhal_display_default((bagl_element_t *)element);
}
#endif // HAVE_BAGL

void ui_init(void) {
    UX_INIT();
}

unsigned char io_event(__attribute__((unused)) unsigned char channel) {
    // nothing done with the event, throw an error on the transport layer if
    // needed

    // can't have more than one tag in the reply, not supported yet.
    switch (G_io_seproxyhal_spi_buffer[0]) {
    case SEPROXYHAL_TAG_FINGER_EVENT:
        UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
        break;

#ifdef HAVE_BAGL
    case SEPROXYHAL_TAG_BUTTON_PUSH_EVENT:
        UX_BUTTON_PUSH_EVENT(G_io_seproxyhal_spi_buffer);
        break;
#endif // HAVE_BAGL

    case SEPROXYHAL_TAG_STATUS_EVENT:
        if (G_io_apdu_media == IO_APDU_MEDIA_USB_HID && !(U4BE(G_io_seproxyhal_spi_buffer, 3) & SEPROXYHAL_TAG_STATUS_EVENT_FLAG_USB_POWERED)) {
            THROW(EXCEPTION_IO_RESET);
        }
        __attribute__((fallthrough));
    default:
        UX_DEFAULT_EVENT();
        break;

    case SEPROXYHAL_TAG_DISPLAY_PROCESSED_EVENT:
#ifdef HAVE_BAGL
        UX_DISPLAYED_EVENT({});
#endif // HAVE_BAGL
        break;

    case SEPROXYHAL_TAG_TICKER_EVENT:
        UX_TICKER_EVENT(G_io_seproxyhal_spi_buffer, {});

        break;
    }

    // close the event if not done previously (by a display or whatever)
    if (!io_seproxyhal_spi_is_status_sent()) {
        io_seproxyhal_general_status();
    }

    // command has been processed, DO NOT reset the current APDU transport
    return 1;
}

void switch_screen(uint32_t which) {
    if (which >= MAX_SCREEN_COUNT)
        THROW(EXC_MEMORY_ERROR);
    const char *label = (const char *)PIC(global.ui.prompt.prompts[which]);
    strncpy(global.ui.prompt.active_prompt, label, sizeof(global.ui.prompt.active_prompt));
    if (global.ui.prompt.callbacks[which] == NULL)
        THROW(EXC_MEMORY_ERROR);
    global.ui.prompt.callbacks[which](global.ui.prompt.active_value, sizeof(global.ui.prompt.active_value),
                                      global.ui.prompt.callback_data[which]);
}

void ui_prompt_debug(size_t screen_count) {
    for(uint32_t i=0; i<screen_count; i++) {
        global.ui.switch_screen(i);
        PRINTF("Prompt %d:\n%s\n%s\n", i, global.ui.prompt.active_prompt, global.ui.prompt.active_value);
    }
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

void register_ui_callback(uint32_t which, string_generation_callback cb, const void *data) {
    if (which >= MAX_SCREEN_COUNT)
        THROW(EXC_MEMORY_ERROR);
    global.ui.prompt.callbacks[which] = cb;
    global.ui.prompt.callback_data[which] = data;
}

void exit_app(void) {
    BEGIN_TRY_L(exit) {
        TRY_L(exit) {
#ifdef REVAMPED_IO
            // handle properly the USB stop/start
            os_io_stop();
#endif /* #ifdef REVAMPED_IO */
            os_sched_exit(-1);
        }
        FINALLY_L(exit) {}
    }
    END_TRY_L(exit);

    THROW(0); // Suppress warning
}

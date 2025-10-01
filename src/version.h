#pragma once

typedef struct version {
    uint8_t major;
    uint8_t minor;
    uint8_t patch;
} version_t;

const version_t version = {MAJOR_VERSION, MINOR_VERSION, PATCH_VERSION};

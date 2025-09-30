ifeq ($(BOLOS_SDK),)
$(error Environment variable BOLOS_SDK is not set)
endif

include $(BOLOS_SDK)/Makefile.target

########################################
#        Mandatory configuration       #
########################################
# Application name
APPNAME = "Nervos"

# Application version
APPVERSION_M = 0
APPVERSION_N = 6
APPVERSION_P = 1
APPVERSION = "$(APPVERSION_M).$(APPVERSION_N).$(APPVERSION_P)"

# Application source files
APP_SOURCE_PATH += src

# Application icons following guidelines:
# https://developers.ledger.com/docs/embedded-app/design-requirements/#device-icon
ICON_NANOX = icons/nanox-nervos.gif
ICON_NANOSP = $(ICON_NANOX)
ICON_STAX = icons/stax_app_nervos.gif
ICON_FLEX = icons/flex_app_nervos.gif

# Application allowed derivation curves.
# Possibles curves are: secp256k1, secp256r1, ed25519 and bls12381g1
# If your app needs it, you can specify multiple curves by using:
# `CURVE_APP_LOAD_PARAMS = <curve1> <curve2>`
CURVE_APP_LOAD_PARAMS = secp256k1

# Application allowed derivation paths.
# You should request a specific path for your app.
# This serve as an isolation mechanism.
# Most application will have to request a path according to the BIP-0044
# and SLIP-0044 standards.
# If your app needs it, you can specify multiple path by using:
# `PATH_APP_LOAD_PARAMS = "44'/1'" "45'/1'"`
PATH_APP_LOAD_PARAMS = "44'/309'"

# Setting to allow building variant applications
# - <VARIANT_PARAM> is the name of the parameter which should be set
#   to specify the variant that should be build.
# - <VARIANT_VALUES> a list of variant that can be build using this app code.
#   * It must at least contains one value.
#   * Values can be the app ticker or anything else but should be unique.
VARIANT_PARAM = COIN
VARIANT_VALUES = CKB

# Enabling DEBUG flag will enable PRINTF and disable optimizations
#DEBUG = 1

########################################
#     Application custom permissions   #
########################################
# See SDK `include/appflags.h` for the purpose of each permission
#HAVE_APPLICATION_FLAG_DERIVE_MASTER = 1
#HAVE_APPLICATION_FLAG_GLOBAL_PIN = 1
#HAVE_APPLICATION_FLAG_BOLOS_SETTINGS = 1
#HAVE_APPLICATION_FLAG_LIBRARY = 1

########################################
# Application communication interfaces #
########################################
ENABLE_BLUETOOTH = 1
#ENABLE_NFC = 1
ENABLE_NBGL_FOR_NANO_DEVICES = 0

########################################
#         NBGL custom features         #
########################################
ENABLE_NBGL_QRCODE = 1
#ENABLE_NBGL_KEYBOARD = 1
#ENABLE_NBGL_KEYPAD = 1

########################################
#          Features disablers          #
########################################
# These advanced settings allow to disable some feature that are by
# default enabled in the SDK `Makefile.standard_app`.
#DISABLE_STANDARD_APP_FILES = 1
#DISABLE_DEFAULT_IO_SEPROXY_BUFFER_SIZE = 1 # To allow custom size declaration
#DISABLE_STANDARD_APP_DEFINES = 1 # Will set all the following disablers
#DISABLE_STANDARD_SNPRINTF = 1
#DISABLE_STANDARD_USB = 1
#DISABLE_STANDARD_WEBUSB = 1
#DISABLE_DEBUG_LEDGER_ASSERT = 1
#DISABLE_DEBUG_THROW = 1

GIT_DESCRIBE = "git describe --tags --abbrev=8 --always --long --dirty 2>/dev/null"
COMMIT = $(shell "$(GIT_DESCRIBE)" | sed 's/-dirty/*/')
ifeq ($(COMMIT),)
  $(warning COMMIT not specified and could not be determined with git from "$(GIT_DESCRIBE)")
endif
DEFINES += COMMIT=\"$(COMMIT)\"

include $(BOLOS_SDK)/Makefile.standard_app

TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MoonDylib
MoonDylib_FILES = Tweak.x
MoonDylib_CFLAGS = -fobjc-arc
MoonDylib_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

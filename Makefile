TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Alhussaini
Alhussaini_FILES = Tweak.x
Alhussaini_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

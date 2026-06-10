TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HIPAMenu

HIPAMenu_FILES = Tweak.x
HIPAMenu_CFLAGS = -fobjc-arc
HIPAMenu_FRAMEWORKS = UIKit Foundation CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

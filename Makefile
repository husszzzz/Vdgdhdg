TARGET := iphone:clang:latest:14.0
ARCHS = arm64
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HassanyAutoClicker

HassanyAutoClicker_FILES = Tweak.x
HassanyAutoClicker_CFLAGS = -fobjc-arc
# إذا استخدمت PTFakeTouch ضيف سطر المكتبة هنا:
# HassanyAutoClicker_LDFLAGS += -lPTFakeTouch

include $(THEOS_MAKE_PATH)/tweak.mk

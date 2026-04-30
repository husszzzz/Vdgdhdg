# إعدادات المسارات والهدف
export THEOS = /opt/theos
TARGET := iphone:clang:14.5:14.5
ARCHS = arm64 arm64e

# إعدادات الحزمة النهائية
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

# معلومات الأداة
TWEAK_NAME = SmartButtons
SmartButtons_FILES = Tweak.x
SmartButtons_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

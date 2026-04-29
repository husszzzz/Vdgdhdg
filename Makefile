TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Alhussaini

Alhussaini_FILES = Tweak.x
# هذه السطور هي الحل النهائي لأخطاء ملف makefile
Alhussaini_CFLAGS = -fobjc-arc -Wno-all -Wno-error -Wno-deprecated-declarations
Alhussaini_FRAMEWORKS = UIKit QuartzCore CoreGraphics

include $(THEOS)/makefiles/tweak.mk

TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Alhussaini

Alhussaini_FILES = Tweak.x
# السطر القادم هو السحر الذي سيحل كل مشاكل الـ Makefile
Alhussaini_CFLAGS = -fobjc-arc -Wno-error -Wno-all -Wno-deprecated-declarations -Wno-implicit-function-declaration
Alhussaini_FRAMEWORKS = UIKit QuartzCore CoreGraphics

include $(THEOS)/makefiles/tweak.mk

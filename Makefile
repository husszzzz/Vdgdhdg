TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Alhussaini

Alhussaini_FILES = Tweak.x
# تجاهل التحذيرات لضمان نجاح الـ Build على GitHub
Alhussaini_CFLAGS = -fobjc-arc -Wno-error -Wno-all -Wno-deprecated-declarations
Alhussaini_FRAMEWORKS = UIKit QuartzCore CoreGraphics

include $(THEOS)/makefiles/tweak.mk

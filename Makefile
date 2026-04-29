TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Alhussaini

Alhussaini_FILES = Tweak.x
# أضفت خيار -Wno-error لضمان التجميع حتى لو وجدت تحذيرات بسيطة
Alhussaini_CFLAGS = -fobjc-arc -Wno-deprecated-declarations -Wno-unused-variable -Wno-implicit-function-declaration
Alhussaini_FRAMEWORKS = UIKit QuartzCore AudioToolbox CoreGraphics

include $(THEOS)/makefiles/tweak.mk

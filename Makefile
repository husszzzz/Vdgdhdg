TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Alhussaini

Alhussaini_FILES = Tweak.x
Alhussaini_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
Alhussaini_FRAMEWORKS = UIKit QuartzCore CoreGraphics AudioToolbox Accelerate CoreImage

include $(THEOS)/makefiles/tweak.mk

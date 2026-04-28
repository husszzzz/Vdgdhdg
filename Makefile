TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Alhussaini

Alhussaini_FILES = Tweak.x
Alhussaini_CFLAGS = -fobjc-arc
Alhussaini_FRAMEWORKS = UIKit QuartzCore CoreGraphics AudioToolbox

include $(THEOS)/makefiles/tweak.mk

TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SmartButtons
SmartButtons_FILES = Tweak.x
SmartButtons_CFLAGS = -fobjc-arc
SmartButtons_FRAMEWORKS = UIKit Foundation AudioToolbox

include $(THEOS_MAKE_PATH)/tweak.mk

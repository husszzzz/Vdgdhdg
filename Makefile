export ARCHS = arm64 arm64e
export TARGET = iphone:clang:latest:14.0

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SmartButtons
SmartButtons_FILES = Tweak.x
SmartButtons_CFLAGS = -fobjc-arc
SmartButtons_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += smartbuttonsprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
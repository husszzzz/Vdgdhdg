TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AntiWelcomePopup

AntiWelcomePopup_FILES = Tweak.x
AntiWelcomePopup_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
AntiWelcomePopup_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk

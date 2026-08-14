TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e
DEBUG = 0
FINALPACKAGE = 1

# لتخطي أي تحذيرات برمجية قاسية من المترجم
GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AntiWelcomePopup

AntiWelcomePopup_FILES = Tweak.x
AntiWelcomePopup_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
AntiWelcomePopup_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk

export THEOS_DEVICE_IP = 127.0.0.1
TARGET := iphone:clang:latest:14.0
ARCHS := arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HaderPlusPatch
HaderPlusPatch_FILES = Tweak.x
HaderPlusPatch_FRAMEWORKS = UIKit CoreLocation Foundation

include $(THEOS)/makefiles/tweak.mk

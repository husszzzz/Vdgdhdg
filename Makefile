ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0

TWEAK_NAME = HaderPlusPatch
HaderPlusPatch_FILES = Tweak.x
HaderPlusPatch_FRAMEWORKS = UIKit CoreLocation Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
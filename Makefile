ARCHS = arm64
TARGET = iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Nofix19

iKiraPlus_FILES = Tweak.x
iKiraPlus_CFLAGS = -fobjc-arc
iKiraPlus_FRAMEWORKS = UIKit Foundation QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk

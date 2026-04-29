TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = hassanyJob
hassanyJob_FILES = Tweak.x
hassanyJob_CFLAGS = -fobjc-arc
hassanyJob_FRAMEWORKS = UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

TARGET := iphone:clang:latest:15.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Vgdhdhd

Vgdhdhd_FILES = Tweak.x
Vgdhdhd_FRAMEWORKS = UIKit CoreGraphics QuartzCore

include $(THEOS)/makefiles/tweak.mk

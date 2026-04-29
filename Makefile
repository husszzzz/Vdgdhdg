TARGET := iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES = MoonManager

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = MoonManager
# تأكد من مطابقة أسماء الملفات هنا مع الملفات التي أنشأتها
MoonManager_FILES = main.m MoonRootViewController.m
MoonManager_FRAMEWORKS = UIKit CoreGraphics
MoonManager_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/application.mk

# إعدادات الهدف: استهداف نظام iOS بإصدار 14.0 أو أحدث لضمان القوة
TARGET := iphone:clang:latest:14.0

# المعالجات: دعم الأجهزة القديمة والحديثة (iPhone X وصولاً إلى iPhone 15/16)
ARCHS = arm64 arm64e

# إعدادات البناء النهائي: إيقاف وضع التصحيح وتفعيل وضع الحزمة النهائية لتقليل الكراش
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

# اسم المشروع (يجب أن يكون نفس الاسم الموجود في ملف الـ control)
TWEAK_NAME = Alhussaini

# ملفات السورس: الملف الذي يحتوي على الكود البرمجي (Tweak.x)
Alhussaini_FILES = Tweak.x

# الأعلام البرمجية: تفعيل نظام ARC لإدارة الذاكرة تلقائياً (يمنع الـ Memory Leak)
Alhussaini_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

# المكتبات الأساسية: ضرورية جداً لتشغيل واجهة المستخدم، الصوت، والرسومات
Alhussaini_FRAMEWORKS = UIKit QuartzCore AudioToolbox CoreGraphics CoreText

include $(THEOS)/makefiles/tweak.mk

# أمر بعد التثبيت (اختياري): يقوم بإعادة تشغيل الواجهة (Respring) لتفعيل التعديل فوراً
after-install::
	install.exec "killall -9 SpringBoard"

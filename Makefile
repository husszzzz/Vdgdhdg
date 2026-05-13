# إعدادات المعالجات المدعومة
export ARCHS = arm64 arm64e

# اسم التويك (تأكد إنه نفس اللي بصورة المشروع)
TWEAK_NAME = HearBoostPatch
HearBoostPatch_FILES = Tweak.x

# إضافة الأطر البرمجية اللازمة
HearBoostPatch_FRAMEWORKS = UIKit

# السطر السحري لتجاهل أخطاء الـ Deprecated والتحذيرات
HearBoostPatch_CFLAGS = -fobjc-arc -Wno-deprecated-declarations -Wno-error

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

ARCHS = arm64
TARGET = iphone:clang:latest:13.0

include $(THEOS)/makefiles/common.mk

# ==========================================
# 1. الدايليب الأول (لوحة التحكم الأساسية مالتك)
# ==========================================
TWEAK_NAME = Vdgdhdg
Vdgdhdg_FILES = Tweak.x
Vdgdhdg_CFLAGS = -fobjc-arc

# ==========================================
# 2. الدايليب الثاني (كلب الحراسة المخفي)
# ==========================================
TWEAK_NAME += Guard
Guard_FILES = Guard.x
Guard_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

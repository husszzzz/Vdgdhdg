#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>

// اسم دايليب الحقوق مالتك اللي كاعد تحميه
#define MAIN_TWEAK_NAME @"Nofix19"

__attribute__((constructor)) static void HassanyWatchdog_Init() {
    // ننتظر 5 ثواني على الـ Main Queue حتى نضمن اللعبة فتحت
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        BOOL isLoaded = NO;
        uint32_t count = _dyld_image_count();
        
        // فحص الذاكرة العشوائية للعبة
        for (uint32_t i = 0; i < count; i++) {
            const char *imagePath = _dyld_get_image_name(i);
            if (imagePath) {
                NSString *pathStr = [NSString stringWithUTF8String:imagePath];
                // إذا لكى الدايليب الأساسي مالتك
                if ([pathStr containsString:MAIN_TWEAK_NAME]) {
                    isLoaded = YES;
                    break;
                }
            }
        }
        
        // إذا المكرك حذف الدايليب الأساسي... اضرب اللعبة فوراً!
        if (!isLoaded) {
            abort(); // هذا الأمر يسوي كراش إجباري قاتل لا يمكن تخطيه
        }
    });
}

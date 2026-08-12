#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>

// اسم الدايليب الأساسي مالتك اللي تريد تحميه (بدون صيغة .dylib)
// غيره حسب اسم الدايليب مال لوحة التحكم اللي سويناه
#define MAIN_TWEAK_NAME @"Vdgdhdg" 

__attribute__((constructor)) static void HassanyWatchdog_Init() {
    // ننتظر 5 ثواني حتى تشتغل اللعبة وتستقر
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        BOOL isMainTweakLoaded = NO;
        uint32_t count = _dyld_image_count();
        
        // فحص كل المكتبات والدايليبات المحقونة باللعبة
        for (uint32_t i = 0; i < count; i++) {
            const char *imageName = _dyld_get_image_name(i);
            if (imageName) {
                NSString *nameString = [NSString stringWithUTF8String:imageName];
                if ([nameString containsString:MAIN_TWEAK_NAME]) {
                    isMainTweakLoaded = YES;
                    break;
                }
            }
        }
        
        // إذا المكرك حذف الدايليب الأساسي... اضرب اللعبة!
        if (!isMainTweakLoaded) {
            // طريقة كراش خبيثة (Segmentation Fault) تبين كأنها خطأ باللعبة نفسها
            int *crashPointer = NULL;
            *crashPointer = 0xDEADBEEF; 
        }
    });
}

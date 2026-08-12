#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// ==========================================
// 1. فخ الـ Info.plist: الكلاس الوهمي للنظام
// ==========================================
@interface MCApplication : UIApplication
@end
@implementation MCApplication
@end

// ==========================================
// 2. فخ المفتاح السري: يمنع التزوير
// ==========================================
__attribute__((constructor)) static void HassanyWatchdog_Init() {
    
    // ننتظر 5 ثواني
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // الكلب هسه يدور بداخل ذاكرة اللعبة على (المفتاح السري) اللي زرعناه بالدايليب الأساسي
        Class secretKey = NSClassFromString(@"HassanySecretKey2026");
        
        if (!secretKey) {
            // إذا المكرك حذف الدايليب الأساسي، أو خلى دايليب مزيف.. 
            // الكلب ما راح يلكى المفتاح السري (HassanySecretKey2026) وراح يضرب اللعبة فوراً!
            abort();
        }
    });
}

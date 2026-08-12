#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// ==========================================
// 1. فخ الـ Info.plist: الكلاس الوهمي اللي يطلبه النظام
// ==========================================
@interface MCApplication : UIApplication
@end

@implementation MCApplication
@end

// ==========================================
// 2. فخ الذاكرة: كلب الحراسة اللي يمنع التزوير والحذف
// ==========================================
__attribute__((constructor)) static void HassanyWatchdog_Init() {
    // ننتظر 5 ثواني حتى تفتح اللعبة وتشتغل اللوحة
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // البحث عن الكلاس الأساسي مال واجهتك بالذاكرة
        Class mySecretClass = NSClassFromString(@"HassanyWelcomeView");
        
        if (!mySecretClass) {
            // إذا الكلاس ما موجود بالذاكرة، معناها الدايليب انحذف أو تبدل بواحد مزيف!
            // اضرب اللعبة بكراش فوري
            abort();
        }
    });
}

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

__attribute__((constructor)) static void HassanyWatchdog_Init() {
    // ننتظر 5 ثواني
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // السر هنا: نبحث عن الكلاس الأساسي مال واجهتك بالذاكرة
        // إذا تستخدم الدايليب القديم مالتك، تأكد أن هذا الاسم يطابق اسم الواجهة بيك
        // مثل: HassanyWelcomeView أو HassanyUniversalAlert
        Class mySecretClass = NSClassFromString(@"HassanyWelcomeView");
        
        if (!mySecretClass) {
            // إذا الكلاس ما موجود بالذاكرة، معناها الدايليب انحذف أو تبدل بواحد مزيف!
            // اضرب اللعبة بكراش فوري
            abort();
        }
    });
}

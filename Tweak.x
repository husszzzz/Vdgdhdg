#import <UIKit/UIKit.h>

// 1. إخفاء أي تنبيه (Alert) يظهر عند تشغيل التطبيق
%hook UIAlertController
- (void)viewDidAppear:(BOOL)animated {
    // إغلاق التنبيه فوراً دون تدخل المستخدم
    [self dismissViewControllerAnimated:NO completion:nil];
    %orig;
}
%end

// 2. اعتراض تنبيهات UIAlertView القديمة
%hook UIAlertView
- (void)show {
    // منع التنبيه من الظهور نهائياً
    return;
}
%end

// 3. محاولة تعطيل دوال التحقق من التوقيع أو الحقوق الشائعة
// ملاحظة: هذا الجزء تجريبي ويعتمد على مهارة المطور الأصلي
%hook NSUserDefaults
- (id)objectForKey:(NSString *)defaultName {
    // إذا كان التطبيق يبحث عن مفتاح يخص "الحقوق" أو "الترحيب"، يمكننا التلاعب به هنا
    if ([defaultName containsString:@"showWelcome"] || [defaultName containsString:@"credits"]) {
        return @NO; // إرجاع "كاذب" لعدم إظهار الرسالة
    }
    return %orig;
}
%end

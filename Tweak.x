#import <UIKit/UIKit.h>

// تعريف دوال إضافية للنافذة
@interface UIWindow (HassanyProtect)
- (void)showHassanyActivation;
- (void)setupHassanyTimerWithExpiry:(NSDate *)expiryDate;
@end

// متغيرات عامة للعداد واللون
UILabel *hassanyFloatingLabel;
NSTimer *hassanyTimer;
CGFloat rgbHue = 0.0;

// قائمة الأكواد والأيام (مثل ما طلبت بالضبط)
static NSDictionary *getValidCodes() {
    return @{
        @"hassany-CFHUDD-30": @30,
        @"hassany-HONGYDG-30": @30,
        @"hassany-BBBYT7D-30": @30,
        @"hassany-HBGTEKL-7": @7,
        @"hassany-VVXYIP77-7": @7,
        @"hassany-NGUTRDK-7": @7,
        @"hassany-BNOGYG-1": @1,
        @"hassany-KKhICXQR-1": @1,
        @"hassany-HPUTQB-1": @1,
        @"hassany-HOGTJ88-1": @1
    };
}

%hook UIWindow

- (void)makeKeyAndVisible {
    %orig; // تشغيل نافذة التطبيق الأصلية
    
    // تشغيل الكود مرة واحدة فقط عند فتح التطبيق
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // تأخير ثانية واحدة حتى يكتمل تحميل واجهة التطبيق
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSDate *expiryDate = [defaults objectForKey:@"HassanyExpiryDate"];
            
            // فحص هل المستخدم مفعل التطبيق والوقت ما خلص؟
            if (expiryDate && [[NSDate date] compare:expiryDate] == NSOrderedAscending) {
                // تفعيل ساري، نشغل العداد
                [self setupHassanyTimerWithExpiry:expiryDate];
            } else {
                // يحتاج تفعيل
                [self showHassanyActivation];
            }
        });
    });
}

%new
- (void)showHassanyActivation {
    // إيجاد الواجهة الأمامية الحالية لعرض الرسالة
    UIViewController *rootVC = self.rootViewController;
    while (rootVC.presentedViewController) {
        rootVC = rootVC.presentedViewController;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"🛡️ تفعيل التطبيق"
                                                                   message:@"يرجى إدخال كود التفعيل الخاص بمتجر الحسني للاستمرار."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"أدخل الكود هنا...";
        textField.textAlignment = NSTextAlignmentCenter;
    }];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"تفعيل" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *inputCode = alert.textFields.firstObject.text;
        NSDictionary *validCodes = getValidCodes();
        
        if (validCodes[inputCode]) {
            // الكود صحيح ✅
            int days = [validCodes[inputCode] intValue];
            NSDate *newExpiry = [[NSDate date] dateByAddingTimeInterval:days * 24 * 60 * 60];
            
            // حفظ وقت الانتهاء في الجهاز
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:newExpiry forKey:@"HassanyExpiryDate"];
            [defaults synchronize];
            
            // رسالة النجاح
            UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:@"✅ تمت العملية بنجاح" message:@"تم تفعيل التطبيق، استمتع!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"حسناً" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a){
                [self setupHassanyTimerWithExpiry:newExpiry];
            }];
            [successAlert addAction:ok];
            [rootVC presentViewController:successAlert animated:YES completion:nil];
            
        } else {
            // الكود خطأ ❌
            UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"❌ خطأ" message:@"الكود غير صحيح أو مستخدم، حاول مرة أخرى." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *retry = [UIAlertAction actionWithTitle:@"إعادة المحاولة" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a){
                [self showHassanyActivation]; // إرجاع رسالة التفعيل
            }];
            // إضافة زر للخروج من التطبيق إذا ماعنده كود
            UIAlertAction *exitApp = [UIAlertAction actionWithTitle:@"خروج" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *a){
                exit(0); // يكرش التطبيق ويطلع
            }];
            
            [errorAlert addAction:retry];
            [errorAlert addAction:exitApp];
            [rootVC presentViewController:errorAlert animated:YES completion:nil];
        }
    }];
    
    [alert addAction:confirm];
    [rootVC presentViewController:alert animated:YES completion:nil];
}

%new
- (void)setupHassanyTimerWithExpiry:(NSDate *)expiryDate {
    if (!hassanyFloatingLabel) {
        // إنشاء النص الصغير (العداد)
        // مكانه: فوق بالوسط (تقدر تغير الأرقام لتغيير مكانه)
        hassanyFloatingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 25)];
        hassanyFloatingLabel.textAlignment = NSTextAlignmentCenter;
        hassanyFloatingLabel.font = [UIFont boldSystemFontOfSize:11];
        hassanyFloatingLabel.userInteractionEnabled = NO; // حتى ما يمنع اللمس
        hassanyFloatingLabel.layer.zPosition = 9999; // حتى يبقى فوگ كل شي
        [self addSubview:hassanyFloatingLabel];
        
        // تشغيل العداد كل ثانية
        hassanyTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSTimeInterval timeRemaining = [expiryDate timeIntervalSinceDate:[NSDate date]];
            
            if (timeRemaining <= 0) {
                // إذا خلص الوقت
                hassanyFloatingLabel.text = @"انتهى الاشتراك ❌";
                [timer invalidate];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HassanyExpiryDate"];
                [self showHassanyActivation]; // يطلب كود جديد
                return;
            }
            
            // حساب الأيام والساعات والدقائق والثواني
            int days = timeRemaining / (24 * 3600);
            int hours = fmod((timeRemaining / 3600), 24);
            int minutes = fmod((timeRemaining / 60), 60);
            int seconds = fmod(timeRemaining, 60);
            
            hassanyFloatingLabel.text = [NSString stringWithFormat:@"💎 اشتراك الحسني متبقي: %d يوم، %d ساعة، %d دقيقة، %d ثانية", days, hours, minutes, seconds];
            
            // تأثير ألوان الـ RGB
            rgbHue += 0.05; // سرعة تغيير اللون
            if (rgbHue > 1.0) rgbHue = 0.0;
            hassanyFloatingLabel.textColor = [UIColor colorWithHue:rgbHue saturation:1.0 brightness:1.0 alpha:1.0];
        }];
    }
}

%end

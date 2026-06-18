#import <UIKit/UIKit.h>

// إعدادات الكود الثابتة
#define PREF_KEY @"isHassaniStoreVerified"
#define CORRECT_CODE @"@hassanyIPA"

%hook UIApplication

- (void)applicationDidBecomeActive:(UIApplication *)application {
    %orig; // استدعاء الدالة الأصلية

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // تأخير ظهور الرسالة ثانيتين لضمان تحميل واجهة التطبيق/العبة بدون كراش
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            BOOL isVerified = [defaults boolForKey:PREF_KEY];

            // البحث عن الواجهة الرئيسية لعرض الرسالة عليها
            UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
            while (rootVC.presentedViewController) {
                rootVC = rootVC.presentedViewController;
            }

            if (isVerified) {
                // إذا كان المستخدم قد أدخل الكود مسبقاً، تظهر رسالة ترحيبية فقط
                UIAlertController *welcomeAlert = [UIAlertController alertControllerWithTitle:@"متجر الحسني" message:@"مرحباً بك مجدداً في متجر الحسني" preferredStyle:UIAlertControllerStyleAlert];
                
                [welcomeAlert addAction:[UIAlertAction actionWithTitle:@"دخول" style:UIAlertActionStyleDefault handler:nil]];
                
                [rootVC presentViewController:welcomeAlert animated:YES completion:nil];
            } else {
                // إذا لم يقم بإدخال الكود، تظهر رسالة المطالبة بالكود
                UIAlertController *authAlert = [UIAlertController alertControllerWithTitle:@"مرحبا بك في متجر الحسني" message:@"الرجاء إدخال كود الدخول للمتابعة" preferredStyle:UIAlertControllerStyleAlert];

                // حقل إدخال الكود
                [authAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    textField.placeholder = @"أدخل الكود هنا";
                    textField.textAlignment = NSTextAlignmentCenter;
                }];

                // زر التأكيد
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"تأكيد" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    UITextField *textField = authAlert.textFields.firstObject;
                    
                    if ([textField.text isEqualToString:CORRECT_CODE]) {
                        // حفظ الدخول بنجاح
                        [defaults setBool:YES forKey:PREF_KEY];
                        [defaults synchronize];

                        UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:@"تم التأكيد بنجاح ✅" message:@"نتمنى لك تجربة ممتعة" preferredStyle:UIAlertControllerStyleAlert];
                        [successAlert addAction:[UIAlertAction actionWithTitle:@"موافق" style:UIAlertActionStyleDefault handler:nil]];
                        [rootVC presentViewController:successAlert animated:YES completion:nil];
                        
                    } else {
                        // كود خاطئ
                        UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"خطأ ❌" message:@"الكود غير صحيح! يرجى إدخال الكود الصحيح. سيتم إغلاق اللعبة." preferredStyle:UIAlertControllerStyleAlert];
                        
                        [errorAlert addAction:[UIAlertAction actionWithTitle:@"خروج" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                            // إغلاق التطبيق/اللعبة بقوة (ترسيت)
                            exit(0);
                        }]];
                        
                        [rootVC presentViewController:errorAlert animated:YES completion:nil];
                    }
                }];

                // زر القناة الرسمية
                UIAlertAction *channelAction = [UIAlertAction actionWithTitle:@"القناة الرسمية" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/hassanyIPA"] options:@{} completionHandler:nil];
                    exit(0); // اختياري: يغلق اللعبة عند الذهاب للتليجرام لضمان عدم تخطي الكود
                }];

                // زر المطور
                UIAlertAction *devAction = [UIAlertAction actionWithTitle:@"المطور" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/OM_G9"] options:@{} completionHandler:nil];
                    exit(0);
                }];

                [authAlert addAction:confirmAction];
                [authAlert addAction:channelAction];
                [authAlert addAction:devAction];

                [rootVC presentViewController:authAlert animated:YES completion:nil];
            }
        });
    });
}

%end

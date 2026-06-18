#import <UIKit/UIKit.h>

// تغيير المفتاح لضمان تصفير البيانات السابقة وظهور الرسالة لك للتجربة
#define PREF_KEY @"HassaniStoreVerified_V2" 
#define CORRECT_CODE @"@hassanyIPA"

// متغير لضمان ظهور الرسالة مرة واحدة فقط عند كل مرة تفتح فيها اللعبة
static BOOL hasCheckedCodeThisSession = NO;

%hook UIViewController

- (void)viewDidAppear:(BOOL)animated {
    %orig; // السماح للواجهة الأصلية بالظهور أولاً

    // إذا تم عرض الرسالة مسبقاً في هذه الجلسة، تجاهل الأمر
    if (hasCheckedCodeThisSession) return;

    // تخطي بعض واجهات النظام المخفية (مثل الكيبورد) لتجنب الأخطاء
    NSString *vcName = NSStringFromClass([self class]);
    if ([vcName containsString:@"UICompatibilityInput"] || [vcName containsString:@"Keyboard"] || [vcName containsString:@"Input"]) {
        return;
    }

    // بمجرد وصولنا هنا، نغلق الباب حتى لا تتكرر الرسالة
    hasCheckedCodeThisSession = YES; 

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isVerified = [defaults boolForKey:PREF_KEY];

    if (isVerified) {
        // رسالة الترحيب للمستخدم المفعل مسبقاً
        UIAlertController *welcomeAlert = [UIAlertController alertControllerWithTitle:@"متجر الحسني" message:@"مرحباً بك مجدداً في متجر الحسني" preferredStyle:UIAlertControllerStyleAlert];
        
        [welcomeAlert addAction:[UIAlertAction actionWithTitle:@"دخول" style:UIAlertActionStyleDefault handler:nil]];
        
        [self presentViewController:welcomeAlert animated:YES completion:nil];
    } else {
        // رسالة طلب الكود
        UIAlertController *authAlert = [UIAlertController alertControllerWithTitle:@"مرحبا بك في متجر الحسني" message:@"الرجاء إدخال كود الدخول للمتابعة" preferredStyle:UIAlertControllerStyleAlert];

        [authAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"أدخل الكود هنا";
            textField.textAlignment = NSTextAlignmentCenter;
        }];

        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"تأكيد" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textField = authAlert.textFields.firstObject;
            
            if ([textField.text isEqualToString:CORRECT_CODE]) {
                // حفظ التفعيل بنجاح
                [defaults setBool:YES forKey:PREF_KEY];
                [defaults synchronize];

                UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:@"تم التأكيد بنجاح ✅" message:@"نتمنى لك تجربة ممتعة" preferredStyle:UIAlertControllerStyleAlert];
                [successAlert addAction:[UIAlertAction actionWithTitle:@"موافق" style:UIAlertActionStyleDefault handler:nil]];
                
                [self presentViewController:successAlert animated:YES completion:nil];
                
            } else {
                // كود خاطئ وإغلاق اللعبة
                UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"خطأ ❌" message:@"الكود غير صحيح! يرجى إدخال الكود الصحيح. سيتم إغلاق اللعبة." preferredStyle:UIAlertControllerStyleAlert];
                
                [errorAlert addAction:[UIAlertAction actionWithTitle:@"خروج" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    exit(0);
                }]];
                
                [self presentViewController:errorAlert animated:YES completion:nil];
            }
        }];

        UIAlertAction *channelAction = [UIAlertAction actionWithTitle:@"القناة الرسمية" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/hassanyIPA"] options:@{} completionHandler:nil];
            exit(0); 
        }];

        UIAlertAction *devAction = [UIAlertAction actionWithTitle:@"المطور" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/OM_G9"] options:@{} completionHandler:nil];
            exit(0);
        }];

        [authAlert addAction:confirmAction];
        [authAlert addAction:channelAction];
        [authAlert addAction:devAction];

        [self presentViewController:authAlert animated:YES completion:nil];
    }
}

%end

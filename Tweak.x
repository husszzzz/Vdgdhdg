#import <UIKit/UIKit.h>

// دالة لحساب وعرض الوقت المتبقي بالساعات والدقائق
NSString* getRemainingTimeStr() {
    NSDate *expDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"hassanyIPA_expirationDate"];
    if (!expDate) return @"";
    
    NSTimeInterval remaining = [expDate timeIntervalSinceNow];
    if (remaining <= 0) return @"منتهي";
    
    int hours = (int)(remaining / 3600);
    int mins = (int)((remaining - (hours * 3600)) / 60);
    return [NSString stringWithFormat:@"الوقت المتبقي: %d ساعة و %d دقيقة", hours, mins];
}

// دالة للتحقق من حالة التفعيل
BOOL isActivatedLocally() {
    NSDate *expDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"hassanyIPA_expirationDate"];
    if (expDate && [expDate timeIntervalSinceNow] > 0) {
        return YES;
    }
    return NO;
}

// إنشاء نافذة التفعيل الاحترافية مع الصورة والأكواد
void showActivationAlert(UIViewController *rootVC) {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"مرحباً بك في HassanyIPA\n\n\n\n\n\n\n" 
                                                                   message:@"قم بإدخال كود التفعيل للاستمرار:" 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    // إضافة صورة القناة للـ Alert
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(alert.view.bounds.size.width/2 - 110, 50, 220, 120)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [alert.view addSubview:imageView];
    
    // تحميل الصورة بالخلفية لضمان سرعة واستقرار التطبيق
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://f.top4top.io/p_382878vxb0.jpeg"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = [UIImage imageWithData:imgData];
        });
    });

    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"أدخل الكود هنا...";
        textField.secureTextEntry = NO;
    }];

    UIAlertAction *activateAction = [UIAlertAction actionWithTitle:@"تفعيل" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *inputCode = alert.textFields.firstObject.text;
        
        // قائمة الأكواد الخاصة بك
        NSArray *validCodes = @[
            @"hassanyIPA-7-HHG8628H",
            @"hassanyIPA-7-OXZSQT87C",
@"hassanyIPA-7-YIKPBGTEH",
@"hassanyIPA-7-VBIUIF737",
@"hassanyIPA-7-GG86771AS",
@"hassanyIPA-7-GG9991BM",
@"hassanyIPA-7-YYYYYY77X",
            @"hassanyIPA-7-GHKLPPPP6",
            @"hassanyIPA-1-ONE1",
            @"hassanyIPA-30-GHKPUTTYU",
            @"hassanyIPA-7-NMPU8537"
        ];
        
        if ([validCodes containsObject:inputCode]) {
            // استخراج المدة الزمنية من الكود
            int days = 0;
            if ([inputCode containsString:@"-30-"]) days = 30;
            else if ([inputCode containsString:@"-7-"]) days = 7;
            else if ([inputCode containsString:@"-1-"]) days = 1;
            
            if (days > 0) {
                // حساب تاريخ انتهاء الصلاحية
                NSTimeInterval seconds = days * 24 * 60 * 60;
                NSDate *expirationDate = [[NSDate date] dateByAddingTimeInterval:seconds];
                
                // حفظ التفعيل على جهاز المستخدم
                [[NSUserDefaults standardUserDefaults] setObject:expirationDate forKey:@"hassanyIPA_expirationDate"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                // إشعار النجاح ✅
                UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:@"تم التفعيل ✅" 
                                                                                       message:[NSString stringWithFormat:@"تم تفعيل التطبيق بنجاح لمدة %d أيام.", days] 
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                [successAlert addAction:[UIAlertAction actionWithTitle:@"استمرار" style:UIAlertActionStyleDefault handler:nil]];
                [rootVC presentViewController:successAlert animated:YES completion:nil];
            }
        } else {
            // إشعار الخطأ ❌
            UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"خطأ ❌" 
                                                                                 message:@"الكود الذي أدخلته غير صحيح أو مستخدم." 
                                                                          preferredStyle:UIAlertControllerStyleAlert];
            [errorAlert addAction:[UIAlertAction actionWithTitle:@"حسناً" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
                // إعادة فتح نافذة طلب الكود تلقائياً عند الخطأ
                showActivationAlert(rootVC);
            }]];
            [rootVC presentViewController:errorAlert animated:YES completion:nil];
        }
    }];

    [alert addAction:activateAction];
    [rootVC presentViewController:alert animated:YES completion:nil];
}

// هوك للتحقق من التفعيل وعرض مؤقت الوقت المتبقي
%hook UIViewController

- (void)viewDidAppear:(BOOL)animated {
    %orig;
    
    // التحقق عند الواجهة الرئيسية فقط لمنع التكرار المزعج
    if (self.isBeingPresented || self.movingToParentViewController) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (!isActivatedLocally()) {
                // طلب الكود إذا لم يكن الجهاز مفعلاً
                showActivationAlert(self);
            } else {
                // إذا كان مفعلاً، يتم إظهار شريط أسود احترافي بالوقت المتبقي
                UILabel *timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, [UIScreen mainScreen].bounds.size.width - 40, 40)];
                timerLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
                timerLabel.textColor = [UIColor whiteColor];
                timerLabel.textAlignment = NSTextAlignmentCenter;
                timerLabel.layer.cornerRadius = 10;
                timerLabel.clipsToBounds = YES;
                timerLabel.font = [UIFont boldSystemFontOfSize:14];
                timerLabel.text = getRemainingTimeStr();
                
                // الحل الحديث والمتوافق مع iOS 13 فما فوق لتجنب خطأ الـ keyWindow القديم
                UIWindow *currentWindow = self.view.window;
                if (currentWindow) {
                    [currentWindow addSubview:timerLabel];
                } else {
                    [self.view addSubview:timerLabel];
                }
                
                // إخفاء مؤقت الوقت المتبقي تلقائياً بتأثير تلاشي (Fade out) بعد 5 ثوانٍ
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.5 animations:^{
                        timerLabel.alpha = 0;
                    } completion:^(BOOL finished) {
                        [timerLabel removeFromSuperview];
                    }];
                });
            }
        });
    }
}

%end

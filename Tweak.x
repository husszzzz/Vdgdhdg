#import <UIKit/UIKit.h>

// دالة لحساب وعرض الوقت المتبقي
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

// إنشاء نافذة التفعيل
void showActivationAlert(UIViewController *rootVC) {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"مرحباً بك في HassanyIPA\n\n\n\n\n\n\n" 
                                                                   message:@"قم بإدخال كود التفعيل للاستمرار:" 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    // إضافة صورة القناة
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(alert.view.bounds.size.width/2 - 110, 50, 220, 120)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [alert.view addSubview:imageView];
    
    // تحميل الصورة بالخلفية حتى لا يعلق التطبيق
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
        
        // قائمة الأكواد الصالحة
        NSArray *validCodes = @[
            @"hassanyIPA-7-GHPBDYI",
            @"hassanyIPA-7-KPYVODR",
            @"hassanyIPA-7-JOVIRUV",
            @"hassanyIPA-1-ICOPVTRI1",
            @"hassanyIPA-30-BOGUDSSNO",
            @"hassanyIPA-7-LBIFHASAU"
        ];
        
        if ([validCodes containsObject:inputCode]) {
            // استخراج عدد الأيام من الكود
            int days = 0;
            if ([inputCode containsString:@"-30-"]) days = 30;
            else if ([inputCode containsString:@"-7-"]) days = 7;
            else if ([inputCode containsString:@"-1-"]) days = 1;
            
            if (days > 0) {
                // حساب تاريخ الانتهاء
                NSTimeInterval seconds = days * 24 * 60 * 60;
                NSDate *expirationDate = [[NSDate date] dateByAddingTimeInterval:seconds];
                
                // حفظ التفعيل بالجهاز
                [[NSUserDefaults standardUserDefaults] setObject:expirationDate forKey:@"hassanyIPA_expirationDate"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                // رسالة نجاح ✅
                UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:@"تم التفعيل ✅" message:[NSString stringWithFormat:@"تم تفعيل التطبيق بنجاح لمدة %d أيام.", days] preferredStyle:UIAlertControllerStyleAlert];
                [successAlert addAction:[UIAlertAction actionWithTitle:@"استمرار" style:UIAlertActionStyleDefault handler:nil]];
                [rootVC presentViewController:successAlert animated:YES completion:nil];
            }
        } else {
            // رسالة خطأ ❌
            UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"خطأ ❌" message:@"الكود الذي أدخلته غير صحيح أو مستخدم." preferredStyle:UIAlertControllerStyleAlert];
            [errorAlert addAction:[UIAlertAction actionWithTitle:@"حسناً" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
                // إعادة طلب الكود
                showActivationAlert(rootVC);
            }]];
            [rootVC presentViewController:errorAlert animated:YES completion:nil];
        }
    }];

    [alert addAction:activateAction];
    [rootVC presentViewController:alert animated:YES completion:nil];
}

// هوك (Hook) للواجهة الرئيسية للتطبيق للتحقق أول ما يفتح
%hook UIViewController

- (void)viewDidAppear:(BOOL)animated {
    %orig;
    
    // تأكد أننا في الواجهة الرئيسية فقط لتجنب التكرار
    if (self.isBeingPresented || self.movingToParentViewController) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (!isActivatedLocally()) {
                // إذا لم يكن مفعل، اطلب الكود
                showActivationAlert(self);
            } else {
                // إذا كان مفعل، اعرض الوقت المتبقي كرسالة سريعة أعلى الشاشة
                UILabel *timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, [UIScreen mainScreen].bounds.size.width - 40, 40)];
                timerLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
                timerLabel.textColor = [UIColor whiteColor];
                timerLabel.textAlignment = NSTextAlignmentCenter;
                timerLabel.layer.cornerRadius = 10;
                timerLabel.clipsToBounds = YES;
                timerLabel.font = [UIFont boldSystemFontOfSize:14];
                timerLabel.text = getRemainingTimeStr();
                
                UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
                [keyWindow addSubview:timerLabel];
                
                // إخفاء المؤقت بعد 5 ثواني
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

#import <UIKit/UIKit.h>

// دالة لإظهار القفل
void showPinLock() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"نظام الحماية"
                                                                       message:@"ادخل كود التفعيل للاستمرار"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"الكود هنا...";
            textField.secureTextEntry = NO; // خليه NO حتى يشوف الـ HU وهو يكتبها
        }];
        
        UIAlertAction *checkAction = [UIAlertAction actionWithTitle:@"دخول" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSString *code = alert.textFields.firstObject.text;
            
            if ([code isEqualToString:@"HU"]) {
                // إذا الكود صح
                UIAlertController *success = [UIAlertController alertControllerWithTitle:@"✅"
                                                                               message:@"تم التحقق بنجاح، استمتع!"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                [root presentViewController:success animated:YES completion:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [success dismissViewControllerAnimated:YES completion:nil];
                });
            } else {
                // إذا الكود غلط، نعيد القفل فوراً
                showPinLock();
            }
        }];
        
        [alert addAction:checkAction];
        [root presentViewController:alert animated:YES completion:nil];
    });
}

%ctor {
    showPinLock();
}

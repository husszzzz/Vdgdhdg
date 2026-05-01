#import <UIKit/UIKit.h>

// كود إظهار الرسالة بدون الحاجة لـ SDK كامل
%hook AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL result = %orig;
    
    // تأخير بسيط لضمان ظهور الواجهة
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Hassany Store"
                                                                       message:@"ادخل قيمة المجوهرات الجديدة:"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"القيمة الحالية: 636264";
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
        
        UIAlertAction *apply = [UIAlertAction actionWithTitle:@"تطبيق التعديل" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            NSString *val = alert.textFields.firstObject.text;
            NSLog(@"[Hassany] تم طلب تغيير القيمة إلى: %@", val);
        }];
        
        [alert addAction:apply];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
    
    return result;
}
%end

#import <UIKit/UIKit.h>

void showLock() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = nil;
        
        // طريقة الحصول على النافذة في الإصدارات الحديثة (iOS 13+)
        if (@available(iOS 13.0, *)) {
            for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                    window = ((UIWindowScene *)scene).windows.firstObject;
                    break;
                }
            }
        }
        
        if (!window) {
            window = [UIApplication sharedApplication].windows.firstObject;
        }

        UIViewController *root = window.rootViewController;
        if (!root) return;

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"نظام الحماية"
                                                                       message:@"ادخل الكود للاستمرار"
                                                                preferredStyle:UIAlertControllerStyleAlert];

        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"ادخل الكود هنا...";
            textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        }];

        UIAlertAction *login = [UIAlertAction actionWithTitle:@"دخول" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSString *input = alert.textFields.firstObject.text;
            
            if ([input isEqualToString:@"HU"]) {
                // إذا الكود صح
                UIAlertController *success = [UIAlertController alertControllerWithTitle:@"✅" message:@"تم التحقق بنجاح" preferredStyle:UIAlertControllerStyleAlert];
                [root presentViewController:success animated:YES completion:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [success dismissViewControllerAnimated:YES completion:nil];
                });
            } else {
                // إذا الكود غلط، تظهر الرسالة مرة أخرى
                showLock();
            }
        }];

        [alert addAction:login];
        [root presentViewController:alert animated:YES completion:nil];
    });
}

%ctor {
    showLock();
}

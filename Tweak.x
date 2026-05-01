#import <UIKit/UIKit.h>

void showPinLock() {
    // تأخير بسيط لضمان أن واجهة اللعبة تحملت بالكامل
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIWindow *window = nil;
        
        // حل مشكلة keyWindow المتوقفة في الإصدارات الجديدة (iOS 13+)
        if (@available(iOS 13.0, *)) {
            for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                    window = ((UIWindowScene *)scene).windows.firstObject;
                    break;
                }
            }
        }
        
        // إذا كان النظام قديماً أو لم يجد نافذة Scene
        if (!window) {
            window = [UIApplication sharedApplication].keyWindow;
        }

        UIViewController *root = window.rootViewController;
        if (!root) return;

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"نظام الحماية"
                                                                       message:@"ادخل كود التفعيل (HU) للاستمرار"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"الكود هنا...";
            textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        }];
        
        UIAlertAction *checkAction = [UIAlertAction actionWithTitle:@"دخول" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSString *code = alert.textFields.firstObject.text;
            
            if ([code isEqualToString:@"HU"]) {
                // الكود صحيح ✅
                UIAlertController *success = [UIAlertController alertControllerWithTitle:@"✅"
                                                                               message:@"تم التحقق بنجاح!"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                [root presentViewController:success animated:YES completion:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [success dismissViewControllerAnimated:YES completion:nil];
                });
            } else {
                // الكود خطأ، نعيد القفل فوراً
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

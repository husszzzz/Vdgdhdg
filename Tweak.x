#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// 1. هوك لتجاوز قيود الشبكة (يعمل التطبيق على البيانات)
%hook NSObject
- (BOOL)isReachableViaWWAN { return NO; }
- (BOOL)isReachableViaWiFi { return YES; }
%end

%hook NWPath
- (BOOL)isExpensive { return NO; }
- (BOOL)isConstrained { return NO; }
%end

// 2. كود الحماية
@interface UIWindow (Hassany)
- (void)showHassanyAlert;
@end

%hook UIWindow
- (void)makeKeyAndVisible {
    %orig;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showHassanyAlert];
    });
}

%new
- (void)showHassanyAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"🛡️ HassanyProtect"
                                                                   message:@"أدخل كود التفعيل للوصول:"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"الكود...";
    }];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"دخول" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *code = alert.textFields.firstObject.text;
        if ([code isEqualToString:@"Hassany123"]) {
            // كود صحيح
        } else {
            exit(0);
        }
    }];
    [alert addAction:action];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.rootViewController presentViewController:alert animated:YES completion:nil];
}
%end

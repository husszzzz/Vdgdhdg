#import <UIKit/UIKit.h>

%hook UIApplication

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL result = %orig;
    
    // تأخير 1.5 ثانية لضمان جاهزية النافذة
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if (!keyWindow) {
            // محاولة الحصول على أول نافذة
            keyWindow = [UIApplication sharedApplication].windows.firstObject;
        }
        
        if (keyWindow) {
            // 1. إنشاء الـ Alert
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"مرحباً!"
                                                                           message:@"هذه رسالة من التوييك المضمون"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"تمام ✅"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 NSLog(@"تم الضغط على تمام");
                                                             }];
            [alert addAction:okAction];
            
            // 2. عرض الـ Alert على النافذة الرئيسية
            [keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
            
            NSLog(@"✅ تم عرض الرسالة بنجاح");
        } else {
            NSLog(@"❌ لم يتم العثور على نافذة");
        }
    });
    
    return result;
}

%end

// دالة التأكد من تحميل التوييك
%ctor {
    NSLog(@"🚀 تم تحميل توييك الرسالة المضمونة");
}

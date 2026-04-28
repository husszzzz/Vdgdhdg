#import <UIKit/UIKit.h>

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIWindow *activeWindow = nil;
        
        // الطريقة الحديثة للحصول على النافذة في iOS 13 وما فوق
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    activeWindow = scene.windows.firstObject;
                    break;
                }
            }
        }
        
        // إذا لم يجد نافذة بالطريقة الحديثة، يستخدم الطريقة التقليدية
        if (!activeWindow) {
            activeWindow = [UIApplication sharedApplication].windows.firstObject;
        }

        if (activeWindow.rootViewController) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"أهلاً بك" 
                message:@"تم حقن ملف dylib بنجاح!" 
                preferredStyle:UIAlertControllerStyleAlert];
                
            [alert addAction:[UIAlertAction actionWithTitle:@"تم" style:UIAlertActionStyleDefault handler:nil]];
            
            [activeWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    });
}

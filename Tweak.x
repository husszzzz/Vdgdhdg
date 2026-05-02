#import <UIKit/UIKit.h>

// تعريف المتغيرات عالمياً لضمان استقرارها
UILabel *hassanyLabel;
NSTimer *colorTimer;

@interface HassanyOverlay : NSObject
+ (void)showOverlay;
+ (void)changeColor;
@end

@implementation HassanyOverlay

+ (void)showOverlay {
    // إنشاء النص في نافذة التطبيق الرئيسية
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // الحصول على النافذة الرئيسية (Window)
        UIWindow *keyWindow = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene* scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    keyWindow = scene.windows.firstObject;
                    break;
                }
            }
        } else {
            keyWindow = [UIApplication sharedApplication].keyWindow;
        }

        if (keyWindow && !hassanyLabel) {
            // إعدادات النص (الحجم والموقع)
            // جعلناه في المنتصف الأعلى بحجم صغير
            hassanyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, keyWindow.frame.size.width, 20)];
            hassanyLabel.text = @"hassany IPA";
            hassanyLabel.font = [UIFont boldSystemFontOfSize:10]; // حجم صغير
            hassanyLabel.textAlignment = NSTextAlignmentCenter;
            hassanyLabel.backgroundColor = [UIColor clearColor];
            
            // وضع النص في أعلى الشاشة (فوق الـ Status Bar)
            hassanyLabel.center = CGPointMake(keyWindow.center.x, 15);
            
            [keyWindow addSubview:hassanyLabel];
            
            // بدء مؤقت تغيير الألوان (كل 0.5 ثانية يتغير اللون)
            colorTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 
                                                          target:self 
                                                        selector:@selector(changeColor) 
                                                        userInfo:nil 
                                                         repeats:YES];
        }
    });
}

+ (void)changeColor {
    if (hassanyLabel) {
        // ميزة الألوان العشوائية (RGB)
        CGFloat red = (arc4random() % 255) / 255.0f;
        CGFloat green = (arc4random() % 255) / 255.0f;
        CGFloat blue = (arc4random() % 255) / 255.0f;
        
        [UIView animateWithDuration:0.4 animations:^{
            hassanyLabel.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        }];
    }
}

@end

// ==========================================
// نقطة الحقن (Hooking)
// ==========================================
%hook UIApplication

- (void)applicationDidBecomeActive:(id)application {
    %orig;
    // تشغيل الأداة عند فتح التطبيق
    [HassanyOverlay showOverlay];
}

%end

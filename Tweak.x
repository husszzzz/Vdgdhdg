#import <UIKit/UIKit.h>

// تعريف المتغيرات
static UILabel *hassanyLabel;
static NSTimer *colorTimer;

@interface HassanyOverlay : NSObject
+ (void)showOverlay;
+ (void)changeColor;
@end

@implementation HassanyOverlay

+ (void)showOverlay {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIWindow *activeWindow = nil;
        
        // الطريقة الحديثة والآمنة للحصول على النافذة بدون استخدام keyWindow
        if (@available(iOS 13.0, *)) {
            NSSet *scenes = [[UIApplication sharedApplication] connectedScenes];
            for (UIScene *scene in scenes) {
                if ([scene isKindOfClass:[UIWindowScene class]] && scene.activationState == UISceneActivationStateForegroundActive) {
                    UIWindowScene *windowScene = (UIWindowScene *)scene;
                    // نأخذ أول نافذة صالحة في المشهد النشط
                    for (UIWindow *window in windowScene.windows) {
                        if (!window.hidden && window.isKeyWindow) {
                            activeWindow = window;
                            break;
                        }
                    }
                }
            }
        } else {
            // للأجهزة القديمة جداً
            activeWindow = [[UIApplication sharedApplication] keyWindow];
        }

        // إنشاء النص إذا وجدت النافذة
        if (activeWindow && !hassanyLabel) {
            hassanyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, activeWindow.frame.size.width, 20)];
            hassanyLabel.text = @"hassany IPA";
            hassanyLabel.font = [UIFont boldSystemFontOfSize:10];
            hassanyLabel.textAlignment = NSTextAlignmentCenter;
            hassanyLabel.backgroundColor = [UIColor clearColor];
            hassanyLabel.userInteractionEnabled = NO;
            
            // وضع النص في الأعلى
            hassanyLabel.center = CGPointMake(activeWindow.center.x, 15);
            
            [activeWindow addSubview:hassanyLabel];
            
            // مؤقت الألوان
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
// الربط مع التطبيق
// ==========================================
%hook UIApplication
- (void)applicationDidBecomeActive:(id)application {
    %orig;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HassanyOverlay showOverlay];
    });
}
%end

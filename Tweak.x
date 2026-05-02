#import <UIKit/UIKit.h>

static UILabel *hassanyLabel;
static NSTimer *colorTimer;
static NSTimer *retryTimer;

@interface HassanyOverlay : NSObject
+ (void)startHassany;
+ (void)tryToInject;
+ (void)changeColor;
@end

@implementation HassanyOverlay

+ (void)startHassany {
    if (!retryTimer) {
        retryTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 
                                                      target:self 
                                                    selector:@selector(tryToInject) 
                                                    userInfo:nil 
                                                     repeats:YES];
    }
}

+ (void)tryToInject {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *activeWindow = nil;

        if (@available(iOS 13.0, *)) {
            for (UIScene *scene in [[UIApplication sharedApplication] connectedScenes]) {
                if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                    UIWindowScene *windowScene = (UIWindowScene *)scene;
                    for (UIWindow *window in windowScene.windows) {
                        // استخدام Selector للهروب من فحص المترجم
                        SEL keySel = NSSelectorFromString(@"isKeyWindow");
                        if ([window respondsToSelector:keySel]) {
                            BOOL isKey = ((BOOL (*)(id, SEL))objc_msgSend)(window, keySel);
                            if (isKey) {
                                activeWindow = window;
                                break;
                            }
                        }
                    }
                }
            }
        }

        // خطة بديلة (Fallback) إذا لم يجد النافذة بالطريقة السابقة
        if (!activeWindow) {
            activeWindow = [[UIApplication sharedApplication] delegate].window;
        }

        if (activeWindow && !hassanyLabel) {
            [retryTimer invalidate];
            retryTimer = nil;

            // إنشاء النص
            hassanyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, activeWindow.frame.size.width, 30)];
            hassanyLabel.text = @"hassany IPA";
            hassanyLabel.font = [UIFont boldSystemFontOfSize:14]; // تكبير الخط شوي عشان يبين
            hassanyLabel.textAlignment = NSTextAlignmentCenter;
            hassanyLabel.backgroundColor = [UIColor clearColor];
            hassanyLabel.userInteractionEnabled = NO;
            
            // تحديد الموقع (25 هو الارتفاع المناسب تحت النوتش)
            hassanyLabel.center = CGPointMake(activeWindow.frame.size.width / 2, 25);
            
            // رفعه فوق كل الطبقات
            hassanyLabel.layer.zPosition = MAXFLOAT;
            [activeWindow addSubview:hassanyLabel];
            [activeWindow bringSubviewToFront:hassanyLabel];

            // تشغيل مؤقت الألوان
            colorTimer = [NSTimer scheduledTimerWithTimeInterval:0.4 
                                                          target:self 
                                                        selector:@selector(changeColor) 
                                                        userInfo:nil 
                                                         repeats:YES];
        }
    });
}

+ (void)changeColor {
    if (hassanyLabel) {
        CGFloat r = (arc4random() % 255) / 255.0f;
        CGFloat g = (arc4random() % 255) / 255.0f;
        CGFloat b = (arc4random() % 255) / 255.0f;
        
        [UIView animateWithDuration:0.3 animations:^{
            hassanyLabel.textColor = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
        }];
    }
}
@end

%hook UIApplication
- (void)applicationDidBecomeActive:(id)application {
    %orig;
    [HassanyOverlay startHassany];
}
%end

#import <UIKit/UIKit.h>

static UILabel *hassanyLabel;
static NSTimer *colorTimer;
static NSTimer *retryTimer;

@interface HassanyOverlay : NSObject
+ (void)startHassany;
+ (void)tryToInject;
+ (void)changeColor;
+ (void)animateMovement;
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

        // البحث عن النافذة النشطة بطريقة مخفية لتجاوز المترجم
        if (@available(iOS 13.0, *)) {
            for (UIScene *scene in [[UIApplication sharedApplication] connectedScenes]) {
                if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                    UIWindowScene *windowScene = (UIWindowScene *)scene;
                    for (UIWindow *window in windowScene.windows) {
                        @try {
                            if ([[window valueForKey:@"isKeyWindow"] boolValue]) {
                                activeWindow = window;
                                break;
                            }
                        } @catch (NSException *e) {}
                    }
                }
            }
        }

        if (!activeWindow) {
            @try { activeWindow = [[UIApplication sharedApplication] delegate].window; } @catch (NSException *e) {}
        }

        // إذا وجدت النافذة ولم يتم حقن النص بعد
        if (activeWindow && !hassanyLabel) {
            [retryTimer invalidate];
            retryTimer = nil;

            // إنشاء التسمية (Label)
            hassanyLabel = [[UILabel alloc] initWithFrame:CGRectMake(-150, 30, 150, 30)]; // يبدأ من خارج الشاشة يساراً
            hassanyLabel.text = @"hassany IPA";
            hassanyLabel.font = [UIFont boldSystemFontOfSize:16]; // خط أوضح
            hassanyLabel.textAlignment = NSTextAlignmentCenter;
            hassanyLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2]; // خلفية خفيفة جداً لضمان الظهور
            hassanyLabel.layer.cornerRadius = 8;
            hassanyLabel.clipsToBounds = YES;
            hassanyLabel.userInteractionEnabled = NO;
            hassanyLabel.layer.zPosition = 9999; // فوق كل شيء

            [activeWindow addSubview:hassanyLabel];
            [activeWindow bringSubviewToFront:hassanyLabel];

            // تشغيل الألوان
            colorTimer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(changeColor) userInfo:nil repeats:YES];

            // تشغيل الحركة
            [self animateMovement];
        }
    });
}

// دالة الحركة (تحريك النص من اليسار لليمين وبالعكس)
+ (void)animateMovement {
    if (!hassanyLabel) return;

    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;

    [UIView animateWithDuration:4.0 
                          delay:0 
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction 
                     animations:^{
        // تحريك النص إلى أقصى اليمين
        CGRect frame = hassanyLabel.frame;
        frame.origin.x = screenWidth + 10;
        hassanyLabel.frame = frame;
    } completion:^(BOOL finished) {
        // إعادة النص لليسار والبدء من جديد
        CGRect frame = hassanyLabel.frame;
        frame.origin.x = -150;
        hassanyLabel.frame = frame;
        [self animateMovement];
    }];
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

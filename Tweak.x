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
                        
                        // استخدام KVC للهروب من المترجم تماماً
                        // هذي الطريقة تجلب قيمة isKeyWindow بدون ما المترجم يحس
                        @try {
                            id isKey = [window valueForKey:@"isKeyWindow"];
                            if ([isKey boolValue]) {
                                activeWindow = window;
                                break;
                            }
                        } @catch (NSException *exception) {}
                    }
                }
            }
        }

        // إذا ما لقى النافذة بالطريقة اللي فوگ، يستخدم الـ Delegate
        if (!activeWindow) {
            @try {
                activeWindow = [[UIApplication sharedApplication] delegate].window;
            } @catch (NSException *exception) {}
        }

        if (activeWindow && !hassanyLabel) {
            [retryTimer invalidate];
            retryTimer = nil;

            // إعدادات النص (hassany IPA)
            hassanyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, activeWindow.frame.size.width, 30)];
            hassanyLabel.text = @"hassany IPA";
            hassanyLabel.font = [UIFont boldSystemFontOfSize:14];
            hassanyLabel.textAlignment = NSTextAlignmentCenter;
            hassanyLabel.backgroundColor = [UIColor clearColor];
            hassanyLabel.userInteractionEnabled = NO;
            
            // الموقع (تحت الساعة بـ 25 بكسل)
            hassanyLabel.center = CGPointMake(activeWindow.frame.size.width / 2, 25);
            
            // نخليه فوق كل شي
            hassanyLabel.layer.zPosition = MAXFLOAT;
            [activeWindow addSubview:hassanyLabel];
            [activeWindow bringSubviewToFront:hassanyLabel];

            // تشغيل مؤقت الألوان (كل 0.4 ثانية)
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

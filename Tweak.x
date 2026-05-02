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
    // البدء بمحاولة الحقن كل ثانية حتى تظهر الواجهة
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

        // الطريقة الأكثر أماناً للوصول للنافذة النشطة
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene* scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    for (UIWindow *window in scene.windows) {
                        if (window.isKeyWindow || window.windowLevel == UIWindowLevelNormal) {
                            activeWindow = window;
                            break;
                        }
                    }
                }
            }
        }

        if (!activeWindow) {
            activeWindow = [[UIApplication sharedApplication] keyWindow];
        }

        // إذا وجدت النافذة، نقوم بحقن النص وإيقاف مؤقت المحاولة
        if (activeWindow && !hassanyLabel) {
            [retryTimer invalidate];
            retryTimer = nil;

            hassanyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, activeWindow.frame.size.width, 25)];
            hassanyLabel.text = @"hassany IPA";
            hassanyLabel.font = [UIFont boldSystemFontOfSize:12];
            hassanyLabel.textAlignment = NSTextAlignmentCenter;
            hassanyLabel.backgroundColor = [UIColor clearColor];
            hassanyLabel.userInteractionEnabled = NO;
            
            // وضعه في أعلى الشاشة (تأكد من رفعه ليكون ظاهراً)
            hassanyLabel.center = CGPointMake(activeWindow.frame.size.width / 2, 20);
            
            // إضافة النص فوق كل شيء
            hassanyLabel.layer.zPosition = MAXFLOAT;
            [activeWindow addSubview:hassanyLabel];
            [activeWindow bringSubviewToFront:hassanyLabel];

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

%hook UIApplication
- (void)applicationDidBecomeActive:(id)application {
    %orig;
    [HassanyOverlay startHassany];
}
%end

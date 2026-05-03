#import <UIKit/UIKit.h>

static UILabel *hassanyLabel;

@interface HassanyTool : NSObject
+ (void)injectLabel;
+ (void)animateLabel;
+ (void)changeColor;
@end

@implementation HassanyTool

+ (void)injectLabel {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 1. البحث عن النافذة الرئيسية للتطبيق بأي طريقة ممكنة
        UIWindow *appWindow = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene* scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    appWindow = scene.windows.firstObject;
                    break;
                }
            }
        }
        if (!appWindow) appWindow = [UIApplication sharedApplication].keyWindow;
        if (!appWindow) appWindow = [[[UIApplication sharedApplication] delegate] window];

        // 2. إذا لكينا النافذة وما ضايفين النص قبل، نضيفه هسه
        if (appWindow && !hassanyLabel) {
            hassanyLabel = [[UILabel alloc] initWithFrame:CGRectMake(-150, 40, 150, 30)];
            hassanyLabel.text = @"hassany IPA";
            hassanyLabel.font = [UIFont boldSystemFontOfSize:16];
            hassanyLabel.textColor = [UIColor whiteColor];
            hassanyLabel.textAlignment = NSTextAlignmentCenter;
            hassanyLabel.layer.zPosition = 10000; // نخليه فوك كل شي
            hassanyLabel.userInteractionEnabled = NO;

            // إضافة ظل فخم جداً عشان يبين بالخلفيات البيضة والسودة
            hassanyLabel.layer.shadowColor = [UIColor blackColor].CGColor;
            hassanyLabel.layer.shadowOffset = CGSizeMake(0, 0);
            hassanyLabel.layer.shadowOpacity = 1.0;
            hassanyLabel.layer.shadowRadius = 4.0;

            [appWindow addSubview:hassanyLabel];
            [appWindow bringSubviewToFront:hassanyLabel];

            // تشغيل الحركة والألوان
            [self animateLabel];
            [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(changeColor) userInfo:nil repeats:YES];
        }
    });
}

+ (void)animateLabel {
    if (!hassanyLabel) return;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;

    [UIView animateWithDuration:6.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect frame = hassanyLabel.frame;
        frame.origin.x = screenWidth + 20;
        hassanyLabel.frame = frame;
    } completion:^(BOOL finished) {
        CGRect frame = hassanyLabel.frame;
        frame.origin.x = -150;
        hassanyLabel.frame = frame;
        [self animateLabel];
    }];
}

+ (void)changeColor {
    if (hassanyLabel) {
        CGFloat r = (arc4random() % 255) / 255.0f;
        CGFloat g = (arc4random() % 255) / 255.0f;
        CGFloat b = (arc4random() % 255) / 255.0f;
        [UIView animateWithDuration:0.2 animations:^{
            hassanyLabel.textColor = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
        }];
    }
}
@end

// ==========================================
// الحقن الذكي: نشغله بكل لحظة التطبيق يتفاعل بيها
// ==========================================
%hook UIWindow
- (void)makeKeyAndVisible {
    %orig;
    [HassanyTool injectLabel];
}
%end

%hook UIApplication
- (void)applicationDidBecomeActive:(id)application {
    %orig;
    // نكرر المحاولة بعد ثانية وثلاث ثواني لضمان الظهور
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HassanyTool injectLabel];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HassanyTool injectLabel];
    });
}
%end

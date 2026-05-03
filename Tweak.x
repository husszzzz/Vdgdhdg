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
        UIWindow *appWindow = nil;

        // 1. الطريقة الآمنة للبحث عن النافذة (بدون الكلمات الممنوعة)
        if (@available(iOS 13.0, *)) {
            for (UIScene *scene in [[UIApplication sharedApplication] connectedScenes]) {
                if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                    UIWindowScene *windowScene = (UIWindowScene *)scene;
                    for (UIWindow *window in windowScene.windows) {
                        @try {
                            // استخدام KVC للهروب من المترجم
                            if ([[window valueForKey:@"isKeyWindow"] boolValue]) {
                                appWindow = window;
                                break;
                            }
                        } @catch (NSException *e) {}
                    }
                }
            }
        }

        // 2. خطة بديلة باستخدام KVC فقط للمترجم العنيد
        if (!appWindow) {
            @try {
                appWindow = [[UIApplication sharedApplication] valueForKey:@"keyWindow"];
            } @catch (NSException *e) {}
        }

        // 3. خطة الطوارئ الأخيرة
        if (!appWindow) {
            @try {
                appWindow = [[[UIApplication sharedApplication] delegate] window];
            } @catch (NSException *e) {}
        }

        // إذا لقينا النافذة وما ضايفين النص، هسه نضيفه
        if (appWindow && !hassanyLabel) {
            
            // إنشاء النص مع خلفية شبه شفافة لضمان الوضوح التام
            hassanyLabel = [[UILabel alloc] initWithFrame:CGRectMake(-200, 50, 200, 35)];
            hassanyLabel.text = @"hassany IPA";
            hassanyLabel.font = [UIFont boldSystemFontOfSize:18];
            hassanyLabel.textColor = [UIColor whiteColor];
            hassanyLabel.textAlignment = NSTextAlignmentCenter;
            hassanyLabel.userInteractionEnabled = NO;
            
            // ترتيبات الشكل لضمان الظهور مليون بالمية
            hassanyLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5]; // خلفية سوداء شفافة
            hassanyLabel.layer.cornerRadius = 8;
            hassanyLabel.clipsToBounds = YES;
            hassanyLabel.layer.zPosition = 999999; // أعلى طبقة ممكنة
            
            // إضافة ظل
            hassanyLabel.layer.shadowColor = [UIColor blackColor].CGColor;
            hassanyLabel.layer.shadowOffset = CGSizeMake(2, 2);
            hassanyLabel.layer.shadowOpacity = 1.0;

            [appWindow addSubview:hassanyLabel];
            [appWindow bringSubviewToFront:hassanyLabel];

            // تشغيل الحركة والألوان
            [self animateLabel];
            [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(changeColor) userInfo:nil repeats:YES];
        }
    });
}

+ (void)animateLabel {
    if (!hassanyLabel) return;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;

    [UIView animateWithDuration:5.0 delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
        CGRect frame = hassanyLabel.frame;
        frame.origin.x = screenWidth + 20;
        hassanyLabel.frame = frame;
    } completion:^(BOOL finished) {
        CGRect frame = hassanyLabel.frame;
        frame.origin.x = -200;
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
// الحقن الإجباري المطلق
// ==========================================
%hook UIWindow

- (void)makeKeyAndVisible {
    %orig;
    [HassanyTool injectLabel];
}

// هذه الدالة تضمن "مليون بالمية" أن النص يبقى في المقدمة 
// حتى لو اللعبة رسمت واجهات جديدة فوقه
- (void)layoutSubviews {
    %orig;
    if (hassanyLabel && self == hassanyLabel.superview) {
        [self bringSubviewToFront:hassanyLabel];
    }
}

%end

%hook UIApplication
- (void)applicationDidBecomeActive:(id)application {
    %orig;
    // المحاولة بعد ثانية ونص من تشغيل التطبيق
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HassanyTool injectLabel];
    });
}
%end

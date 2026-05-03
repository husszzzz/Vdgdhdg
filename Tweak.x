#import <UIKit/UIKit.h>

// 1. تعريف متحكم الواجهة (ضروري جداً لظهور النافذة في الإصدارات الجديدة)
@interface HassanyViewController : UIViewController
@property (nonatomic, strong) UILabel *movingLabel;
@end

@implementation HassanyViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    // إنشاء النص
    self.movingLabel = [[UILabel alloc] initWithFrame:CGRectMake(-150, 10, 150, 30)];
    self.movingLabel.text = @"hassany IPA";
    self.movingLabel.font = [UIFont boldSystemFontOfSize:15];
    self.movingLabel.textColor = [UIColor cyanColor];
    self.movingLabel.textAlignment = NSTextAlignmentCenter;
    
    // إضافة ظل فخم للنص
    self.movingLabel.shadowColor = [UIColor blackColor];
    self.movingLabel.shadowOffset = CGSizeMake(1, 1);
    
    [self.view addSubview:self.movingLabel];
}
@end

// 2. تعريف النافذة المستقلة
static UIWindow *hWindow = nil;

@interface HassanyManager : NSObject
+ (void)launchOverlay;
+ (void)animateLabel;
+ (void)changeColor;
@end

@implementation HassanyManager

+ (void)launchOverlay {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (hWindow) return;

        // البحث عن المشهد النشط (WindowScene) - هذا هو السر!
        UIWindowScene *activeScene = nil;
        if (@available(iOS 13.0, *)) {
            for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                    activeScene = (UIWindowScene *)scene;
                    break;
                }
            }
        }

        // إنشاء النافذة وربطها بالمشهد
        if (activeScene) {
            hWindow = [[UIWindow alloc] initWithWindowScene:activeScene];
        } else {
            hWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        }

        hWindow.windowLevel = UIWindowLevelAlert + 1000; // أعلى مستوى ممكن
        hWindow.backgroundColor = [UIColor clearColor];
        hWindow.userInteractionEnabled = NO; // حتى لا يضايق اللمس
        
        // تعيين المتحكم الجذري (هذا اللي كان ناقص)
        HassanyViewController *vc = [[HassanyViewController alloc] init];
        hWindow.rootViewController = vc;
        
        [hWindow setHidden:NO];
        [hWindow makeKeyAndVisible];

        // بدء الحركة والألوان
        [self animateLabel];
        [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(changeColor) userInfo:nil repeats:YES];
    });
}

+ (void)animateLabel {
    HassanyViewController *vc = (HassanyViewController *)hWindow.rootViewController;
    if (!vc.movingLabel) return;

    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;

    [UIView animateWithDuration:5.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect frame = vc.movingLabel.frame;
        frame.origin.x = screenWidth + 20;
        vc.movingLabel.frame = frame;
    } completion:^(BOOL finished) {
        CGRect frame = vc.movingLabel.frame;
        frame.origin.x = -150;
        vc.movingLabel.frame = frame;
        [self animateLabel]; // إعادة الحركة للأبد
    }];
}

+ (void)changeColor {
    HassanyViewController *vc = (HassanyViewController *)hWindow.rootViewController;
    if (vc.movingLabel) {
        CGFloat r = (arc4random() % 255) / 255.0f;
        CGFloat g = (arc4random() % 255) / 255.0f;
        CGFloat b = (arc4random() % 255) / 255.0f;
        
        [UIView animateWithDuration:0.3 animations:^{
            vc.movingLabel.textColor = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
        }];
    }
}
@end

// 3. الحقن في التطبيق
%hook UIApplication
- (void)applicationDidBecomeActive:(id)application {
    %orig;
    // تأخير بسيط للتأكد من أن التطبيق جاهز لعرض النوافذ
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HassanyManager launchOverlay];
    });
}
%end

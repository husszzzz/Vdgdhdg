#import <UIKit/UIKit.h>

// تعريف واجهة النافذة الخاصة بنا
@interface HassanyWindow : UIWindow
@property (nonatomic, strong) UILabel *label;
@end

@implementation HassanyWindow
@end

static HassanyWindow *hWindow;
static NSTimer *colorTimer;

@interface HassanyManager : NSObject
+ (void)createOverlay;
+ (void)changeColor;
+ (void)startAnimation;
@end

@implementation HassanyManager

+ (void)createOverlay {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (hWindow) return; // إذا موجودة لا تسوي وحدة ثانية

        // 1. إنشاء النافذة بحجم صغير في أعلى الشاشة
        // استخدمت CGRect كـ سحب من الشاشة مباشرة
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        hWindow = [[HassanyWindow alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 50)];
        
        // 2. جعل النافذة شفافة وفوق كل شيء (حتى فوق الـ Status Bar)
        hWindow.backgroundColor = [UIColor clearColor];
        hWindow.windowLevel = UIWindowLevelStatusBar + 100.0;
        hWindow.userInteractionEnabled = NO; // حتى ما تعيق اللمس
        [hWindow setHidden:NO];
        
        // 3. إضافة النص
        hWindow.label = [[UILabel alloc] initWithFrame:CGRectMake(-150, 10, 150, 30)];
        hWindow.label.text = @"hassany IPA";
        hWindow.label.font = [UIFont boldSystemFontOfSize:15];
        hWindow.label.textAlignment = NSTextAlignmentCenter;
        hWindow.label.textColor = [UIColor cyanColor];
        
        // إضافة ظل للنص عشان يبين بوضوح
        hWindow.label.shadowColor = [UIColor blackColor];
        hWindow.label.shadowOffset = CGSizeMake(1, 1);
        
        [hWindow addSubview:hWindow.label];
        
        // 4. تشغيل الألوان والحركة
        [self startAnimation];
        
        colorTimer = [NSTimer scheduledTimerWithTimeInterval:0.4 
                                                      target:self 
                                                    selector:@selector(changeColor) 
                                                    userInfo:nil 
                                                     repeats:YES];
    });
}

+ (void)startAnimation {
    if (!hWindow.label) return;

    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;

    // حركة من اليسار لليمين بشكل مستمر
    [UIView animateWithDuration:5.0 
                          delay:0 
                        options:UIViewAnimationOptionCurveLinear 
                     animations:^{
        CGRect frame = hWindow.label.frame;
        frame.origin.x = screenWidth + 20;
        hWindow.label.frame = frame;
    } completion:^(BOOL finished) {
        CGRect frame = hWindow.label.frame;
        frame.origin.x = -150;
        hWindow.label.frame = frame;
        [self startAnimation];
    }];
}

+ (void)changeColor {
    if (hWindow.label) {
        CGFloat r = (arc4random() % 255) / 255.0f;
        CGFloat g = (arc4random() % 255) / 255.0f;
        CGFloat b = (arc4random() % 255) / 255.0f;
        
        [UIView animateWithDuration:0.3 animations:^{
            hWindow.label.textColor = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
        }];
    }
}
@end

// ==========================================
// الحقن عند تشغيل أي تطبيق
// ==========================================
%hook UIApplication
- (void)applicationDidBecomeActive:(id)application {
    %orig;
    // ننتظر ثانية وحدة بعدين نشغل النافذة مالتنا
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HassanyManager createOverlay];
    });
}
%end

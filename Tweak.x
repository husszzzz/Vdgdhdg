#import <UIKit/UIKit.h>

// تعريف المتغيرات والروابط الخاصة بك
#define TELEGRAM_LINK @"https://t.me/hassanyIPA"
#define DEV_ACCOUNT @"https://t.me/OM_G9" // أو رابط تويتر الخاص بك

@interface HassanyWelcomeView : UIView
@end

@implementation HassanyWelcomeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 1. خلفية زجاجية داكنة (Dark Blur)
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurView.frame = self.bounds;
        blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:blurView];
        
        // 2. الحاوية الرئيسية (Box) - تصميم قاسي واحترافي
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
        container.center = self.center;
        container.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.9]; // رمادي غامق جداً
        container.layer.cornerRadius = 12;
        container.layer.borderWidth = 1.5;
        container.layer.borderColor = [UIColor darkGrayColor].CGColor;
        container.layer.shadowColor = [UIColor blackColor].CGColor;
        container.layer.shadowOpacity = 0.8;
        container.layer.shadowOffset = CGSizeMake(0, 5);
        container.layer.shadowRadius = 10;
        [self addSubview:container];
        
        // 3. سحب الصورة من ملف الدايليب (hassany.jpg)
        // ملاحظة: مسار الباندل مخصص للـ Jailed (بدون جلبريك)
        NSString *bundlePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Vdgdhdg.bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
        UIImage *devImage = [UIImage imageNamed:@"hassany.jpg" inBundle:bundle compatibleWithTraitCollection:nil];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((320-100)/2, -40, 100, 100)];
        imageView.image = devImage;
        imageView.layer.cornerRadius = 15; // زوايا شبه حادة
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderWidth = 2;
        imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [container addSubview:imageView];
        
        // 4. النصوص (العنوان)
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 280, 30)];
        titleLabel.text = @"hassanyIPA";
        titleLabel.font = [UIFont boldSystemFontOfSize:24];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [container addSubview:titleLabel];
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 105, 280, 60)];
        descLabel.text = @"تم تفعيل التعديلات بنجاح. أي محاولة لإزالة هذا الملف ستؤدي إلى إيقاف التطبيق بالكامل.";
        descLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        descLabel.textColor = [UIColor lightGrayColor];
        descLabel.textAlignment = NSTextAlignmentCenter;
        descLabel.numberOfLines = 0;
        [container addSubview:descLabel];
        
        // 5. الأزرار (تصميم صارم بدون ألوان فاقعة)
        UIButton *tgButton = [self createButtonWithTitle:@"قناة التلجرام" yPosition:190 action:@selector(openTelegram)];
        [container addSubview:tgButton];
        
        UIButton *devButton = [self createButtonWithTitle:@"حساب المطور (@OM_G9)" yPosition:250 action:@selector(openDeveloper)];
        [container addSubview:devButton];
        
        UIButton *closeButton = [self createButtonWithTitle:@"موافق" yPosition:330 action:@selector(closeAlert)];
        closeButton.backgroundColor = [UIColor colorWithRed:0.7 green:0.1 blue:0.1 alpha:1.0]; // أحمر داكن جداً
        closeButton.layer.borderColor = [UIColor clearColor].CGColor;
        [container addSubview:closeButton];
    }
    return self;
}

- (UIButton *)createButtonWithTitle:(NSString *)title yPosition:(CGFloat)y action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(20, y, 280, 45);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    btn.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    btn.layer.cornerRadius = 8;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)openTelegram { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TELEGRAM_LINK] options:@{} completionHandler:nil]; }
- (void)openDeveloper { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:DEV_ACCOUNT] options:@{} completionHandler:nil]; }
- (void)closeAlert {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        self.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end

// استدعاء الواجهة عند فتح التطبيق
%hook UIApplication
- (void)applicationDidBecomeActive:(UIApplication *)application {
    %orig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIWindow *keyWindow = application.keyWindow;
            if (!keyWindow) {
                keyWindow = application.windows.firstObject;
            }
            if (keyWindow) {
                HassanyWelcomeView *alert = [[HassanyWelcomeView alloc] initWithFrame:keyWindow.bounds];
                alert.alpha = 0;
                [keyWindow addSubview:alert];
                [UIView animateWithDuration:0.4 animations:^{
                    alert.alpha = 1;
                }];
            }
        });
    });
}
%end

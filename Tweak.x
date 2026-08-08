#import <UIKit/UIKit.h>

// ==========================================
// 1. إعدادات الروابط الخاصة بك
// ==========================================
#define TELEGRAM_LINK @"https://t.me/hassanyIPA"
#define DEV_ACCOUNT @"https://t.me/OM_G9" 

// ==========================================
// 2. تصميم الواجهة الاحترافية (Full Screen Effect & Notifications)
// ==========================================
@interface HassanyWelcomeView : UIView
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation HassanyWelcomeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 1. خلفية تعتيم (Blur) تغطي الشاشة بالكامل
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurView.frame = self.bounds;
        blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        blurView.alpha = 0.85;
        [self addSubview:blurView];
        
        // 2. خلفية متدرجة (Gradient) كطبقة أساسية
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.frame = self.bounds;
        self.gradientLayer.colors = @[(id)[UIColor colorWithRed:0.05 green:0.05 blue:0.15 alpha:0.7].CGColor,
                                      (id)[UIColor colorWithRed:0.1 green:0.05 blue:0.2 alpha:0.7].CGColor,
                                      (id)[UIColor colorWithRed:0.05 green:0.1 blue:0.2 alpha:0.7].CGColor];
        self.gradientLayer.startPoint = CGPointMake(0, 0);
        self.gradientLayer.endPoint = CGPointMake(1, 1);
        [self.layer addSublayer:self.gradientLayer];
        
        // 3. تأثير الدوائر العائمة (Floating Bubbles) في الخلفية
        [self createFloatingBubbles];
        
        // 4. الحاوية الرئيسية (Box) - حجم أكبر وتصميم عصري
        CGFloat boxWidth = self.bounds.size.width - 40; // ياخذ عرض الشاشة مع هوامش
        if (boxWidth > 360) boxWidth = 360; // حد أقصى للايباد
        CGFloat boxHeight = 460;
        
        self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boxWidth, boxHeight)];
        self.container.center = self.center;
        self.container.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.18 alpha:0.95];
        self.container.layer.cornerRadius = 24;
        self.container.layer.shadowColor = [UIColor blackColor].CGColor;
        self.container.layer.shadowOpacity = 0.6;
        self.container.layer.shadowOffset = CGSizeMake(0, 10);
        self.container.layer.shadowRadius = 20;
        [self addSubview:self.container];
        
        // 5. الصورة الشخصية (إصلاح مسار الاستدعاء)
        NSString *bundlePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Vdgdhdg.bundle"];
        NSString *imagePath = [bundlePath stringByAppendingPathComponent:@"hassany.JPG"];
        UIImage *devImage = [UIImage imageWithContentsOfFile:imagePath]; // استخدام المسار المباشر أضمن
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((boxWidth-100)/2, 30, 100, 100)];
        imageView.image = devImage;
        imageView.backgroundColor = [UIColor darkGrayColor]; // لون احتياطي إذا لم توجد الصورة
        imageView.layer.cornerRadius = 22; 
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderWidth = 1.5;
        imageView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
        [self.container addSubview:imageView];
        
        // 6. النصوص
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 145, boxWidth-40, 35)];
        titleLabel.text = @"يا هلا بيك";
        titleLabel.font = [UIFont systemFontOfSize:28 weight:UIFontWeightBold];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.container addSubview:titleLabel];
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 185, boxWidth-40, 50)];
        descLabel.text = @"تابعنا للمزيد من التطبيقات المميزة ، ولا تتردد بالتواصل مع المطور لطرح أي سؤال أو حل مشكلة ❤️.";
        descLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        descLabel.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
        descLabel.textAlignment = NSTextAlignmentCenter;
        descLabel.numberOfLines = 0;
        [self.container addSubview:descLabel];
        
        // خط فاصل
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(30, 255, boxWidth-60, 1)];
        separator.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.15];
        [self.container addSubview:separator];
        
        // 7. الأزرار 
        UIColor *blueButtonColor = [UIColor colorWithRed:0.25 green:0.45 blue:0.95 alpha:1.0];
        CGFloat btnWidth = boxWidth - 50;
        
        UIButton *tgButton = [self createModernButtonWithTitle:@"Telegram" yPosition:280 width:btnWidth color:blueButtonColor action:@selector(openTelegram)];
        [self.container addSubview:tgButton];
        
        UIButton *devButton = [self createModernButtonWithTitle:@"Developer" yPosition:335 width:btnWidth color:blueButtonColor action:@selector(openDeveloper)];
        [self.container addSubview:devButton];
        
        UIButton *closeButton = [self createModernButtonWithTitle:@"شكراً ❤️" yPosition:390 width:btnWidth color:[UIColor colorWithWhite:0.25 alpha:1.0] action:@selector(closeAlertAndShowNotification)];
        [self.container addSubview:closeButton];
        
        // تأثير الظهور
        self.container.transform = CGAffineTransformMakeScale(0.8, 0.8);
        self.alpha = 0;
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.container.transform = CGAffineTransformIdentity;
            self.alpha = 1;
        } completion:nil];
    }
    return self;
}

// دالة الدوائر المتحركة في الخلفية
- (void)createFloatingBubbles {
    for (int i = 0; i < 5; i++) {
        CGFloat size = arc4random_uniform(150) + 100; // أحجام مختلفة
        CGFloat x = arc4random_uniform((int)self.bounds.size.width);
        CGFloat y = arc4random_uniform((int)self.bounds.size.height);
        
        UIView *bubble = [[UIView alloc] initWithFrame:CGRectMake(x, y, size, size)];
        bubble.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.03]; // دوائر شفافة جداً
        bubble.layer.cornerRadius = size / 2;
        [self insertSubview:bubble belowSubview:self.container];
        
        // حركة مستمرة
        [UIView animateWithDuration:(arc4random_uniform(5) + 5) 
                              delay:0 
                            options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut 
                         animations:^{
            bubble.transform = CGAffineTransformMakeTranslation(arc4random_uniform(50)-25, arc4random_uniform(50)-25);
            bubble.transform = CGAffineTransformScale(bubble.transform, 1.2, 1.2);
        } completion:nil];
    }
}

// إنشاء الأزرار
- (UIButton *)createModernButtonWithTitle:(NSString *)title yPosition:(CGFloat)y width:(CGFloat)width color:(UIColor *)bgColor action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(25, y, width, 45);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    btn.backgroundColor = bgColor;
    btn.layer.cornerRadius = 14; 
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)openTelegram { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TELEGRAM_LINK] options:@{} completionHandler:nil]; }
- (void)openDeveloper { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:DEV_ACCOUNT] options:@{} completionHandler:nil]; }

// دالة الإغلاق وعرض "الإشعار" من الأعلى (نظام iOS البانر)
- (void)closeAlertAndShowNotification {
    [UIView animateWithDuration:0.3 animations:^{
        self.container.transform = CGAffineTransformMakeScale(0.9, 0.9);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        UIView *parentView = self.superview;
        [self removeFromSuperview];
        
        if (parentView) {
            // 1. تصميم بانر الإشعار (Notification Banner)
            CGFloat bannerHeight = 70;
            CGFloat safeTop = 40; // مسافة من الأعلى (للنوتش/الجزيرة)
            UIView *banner = [[UIView alloc] initWithFrame:CGRectMake(15, safeTop - 100, parentView.bounds.size.width - 30, bannerHeight)];
            banner.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.95];
            banner.layer.cornerRadius = 20;
            banner.layer.shadowColor = [UIColor blackColor].CGColor;
            banner.layer.shadowOpacity = 0.3;
            banner.layer.shadowOffset = CGSizeMake(0, 5);
            banner.layer.shadowRadius = 10;
            
            // 2. صورة مصغرة داخل الإشعار
            NSString *bundlePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Vdgdhdg.bundle"];
            NSString *imagePath = [bundlePath stringByAppendingPathComponent:@"hassany.jpg"];
            UIImage *devImage = [UIImage imageWithContentsOfFile:imagePath];
            
            UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 40, 40)];
            iconView.image = devImage;
            iconView.backgroundColor = [UIColor grayColor];
            iconView.layer.cornerRadius = 10;
            iconView.layer.masksToBounds = YES;
            [banner addSubview:iconView];
            
            // 3. نصوص الإشعار
            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(65, 15, banner.bounds.size.width - 80, 20)];
            titleLab.text = @"hassanyIPA";
            titleLab.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
            titleLab.textColor = [UIColor whiteColor];
            [banner addSubview:titleLab];
            
            UILabel *msgLab = [[UILabel alloc] initWithFrame:CGRectMake(65, 35, banner.bounds.size.width - 80, 20)];
            msgLab.text = @"شكراً لكم المطور الوحيد حسين الحسني";
            msgLab.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
            msgLab.textColor = [UIColor lightGrayColor];
            [banner addSubview:msgLab];
            
            [parentView addSubview:banner];
            
            // 4. حركة نزول الإشعار من فوق (Slide Down)
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
                banner.frame = CGRectMake(15, safeTop, parentView.bounds.size.width - 30, bannerHeight);
            } completion:^(BOOL finished) {
                
                // 5. انتظار ثانيتين ثم الصعود والاختفاء (Slide Up)
                [UIView animateWithDuration:0.4 delay:2.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    banner.frame = CGRectMake(15, safeTop - 100, parentView.bounds.size.width - 30, bannerHeight);
                    banner.alpha = 0;
                } completion:^(BOOL finished) {
                    [banner removeFromSuperview];
                }];
            }];
        }
    }];
}
@end

// ==========================================
// 3. الاستدعاء المضمون 100% (Hook UIViewController)
// ==========================================
%hook UIViewController

- (void)viewDidAppear:(BOOL)animated {
    %orig; 
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UIView *targetView = self.view.window;
            if (!targetView) {
                targetView = self.view; 
            }
            
            if (targetView) {
                HassanyWelcomeView *alert = [[HassanyWelcomeView alloc] initWithFrame:targetView.bounds];
                alert.layer.zPosition = 9999; 
                [targetView addSubview:alert];
            }
        });
    });
}

%end

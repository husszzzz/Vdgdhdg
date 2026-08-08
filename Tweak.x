#import <UIKit/UIKit.h>

// ==========================================
// 1. إعدادات الروابط 
// ==========================================
#define TELEGRAM_LINK @"https://t.me/hassanyIPA"
#define DEV_ACCOUNT @"https://t.me/OM_G9" 

// ==========================================
// 2. تصميم الواجهة الاحترافية والانسيابية
// ==========================================
@interface HassanyWelcomeView : UIView
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation HassanyWelcomeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 1. خلفية التعتيم الشاملة (Blur)
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurView.frame = self.bounds;
        blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        blurView.alpha = 0.8;
        [self addSubview:blurView];
        
        // 2. خلفية متحركة (Gradient Animation) للـ View الرئيسي لمسة احترافية
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.frame = self.bounds;
        self.gradientLayer.colors = @[(id)[UIColor colorWithRed:0.05 green:0.05 blue:0.15 alpha:0.6].CGColor,
                                      (id)[UIColor colorWithRed:0.15 green:0.05 blue:0.25 alpha:0.6].CGColor,
                                      (id)[UIColor colorWithRed:0.05 green:0.15 blue:0.2 alpha:0.6].CGColor];
        self.gradientLayer.startPoint = CGPointMake(0, 0);
        self.gradientLayer.endPoint = CGPointMake(1, 1);
        [self.layer addSublayer:self.gradientLayer];
        [self animateGradient];

        // 3. الحاوية (Container) - زوايا دائرية ناعمة ولون أنيق
        self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 310, 420)];
        self.container.center = self.center;
        self.container.backgroundColor = [UIColor colorWithRed:0.12 green:0.13 blue:0.17 alpha:1.0];
        self.container.layer.cornerRadius = 24; // زوايا ناعمة مثل الصورة
        self.container.layer.shadowColor = [UIColor blackColor].CGColor;
        self.container.layer.shadowOpacity = 0.5;
        self.container.layer.shadowOffset = CGSizeMake(0, 8);
        self.container.layer.shadowRadius = 15;
        [self addSubview:self.container];
        
        // 4. الصورة الشخصية
        NSString *bundlePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Vdgdhdg.bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
        UIImage *devImage = [UIImage imageNamed:@"hassany.jpg" inBundle:bundle compatibleWithTraitCollection:nil];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((310-90)/2, 30, 90, 90)];
        imageView.image = devImage;
        imageView.layer.cornerRadius = 20; // زوايا مطابقة لتصميم الايفون الحديث
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderWidth = 1.5;
        imageView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.2].CGColor;
        [self.container addSubview:imageView];
        
        // 5. النصوص (خطوط أنيقة ومرتبة)
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 135, 270, 35)];
        titleLabel.text = @"يا هلا بيك";
        titleLabel.font = [UIFont systemFontOfSize:26 weight:UIFontWeightBold];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.container addSubview:titleLabel];
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 175, 270, 50)];
        descLabel.text = @"تابعنا للمزيد من التطبيقات المميزة ، ولا تتردد بالتواصل مع المطور لطرح أي سؤال أو حل مشكلة ❤️.";
        descLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        descLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        descLabel.textAlignment = NSTextAlignmentCenter;
        descLabel.numberOfLines = 0;
        [self.container addSubview:descLabel];
        
        // خط فاصل رفيع وأنيق
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(30, 240, 250, 1)];
        separator.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
        [self.container addSubview:separator];
        
        // 6. الأزرار بتصميم عصري (أزرق فاهي ورمادي)
        UIColor *blueButtonColor = [UIColor colorWithRed:0.25 green:0.45 blue:0.95 alpha:1.0];
        
        UIButton *tgButton = [self createModernButtonWithTitle:@"Telegram" yPosition:260 color:blueButtonColor action:@selector(openTelegram)];
        [self.container addSubview:tgButton];
        
        UIButton *devButton = [self createModernButtonWithTitle:@"Developer" yPosition:315 color:blueButtonColor action:@selector(openDeveloper)];
        [self.container addSubview:devButton];
        
        UIButton *closeButton = [self createModernButtonWithTitle:@"شكراً ❤️" yPosition:370 color:[UIColor colorWithWhite:0.25 alpha:1.0] action:@selector(closeAlertAndShowThanks)];
        [self.container addSubview:closeButton];
        
        // تأثير الظهور (Pop Animation)
        self.container.transform = CGAffineTransformMakeScale(0.8, 0.8);
        self.container.alpha = 0;
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.container.transform = CGAffineTransformIdentity;
            self.container.alpha = 1;
        } completion:nil];
    }
    return self;
}

// دالة تحريك الخلفية بشكل مستمر (انسيابي)
- (void)animateGradient {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"colors"];
    animation.toValue = @[(id)[UIColor colorWithRed:0.05 green:0.15 blue:0.2 alpha:0.6].CGColor,
                          (id)[UIColor colorWithRed:0.05 green:0.05 blue:0.15 alpha:0.6].CGColor,
                          (id)[UIColor colorWithRed:0.15 green:0.05 blue:0.25 alpha:0.6].CGColor];
    animation.duration = 4.0;
    animation.autoreverses = YES;
    animation.repeatCount = HUGE_VALF;
    [self.gradientLayer addAnimation:animation forKey:@"colorChange"];
}

// دالة إنشاء الأزرار بالتصميم الجديد
- (UIButton *)createModernButtonWithTitle:(NSString *)title yPosition:(CGFloat)y color:(UIColor *)bgColor action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(25, y, 260, 45);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    btn.backgroundColor = bgColor;
    btn.layer.cornerRadius = 12; // زوايا دائرية للأزرار
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)openTelegram { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TELEGRAM_LINK] options:@{} completionHandler:nil]; }
- (void)openDeveloper { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:DEV_ACCOUNT] options:@{} completionHandler:nil]; }

// دالة الإغلاق الانسيابي وعرض رسالة الشكر المنبثقة (Toast)
- (void)closeAlertAndShowThanks {
    // 1. إخفاء الواجهة بانسيابية
    [UIView animateWithDuration:0.3 animations:^{
        self.container.transform = CGAffineTransformMakeScale(0.9, 0.9);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        // 2. إزالة الواجهة القديمة
        UIView *parentView = self.superview;
        [self removeFromSuperview];
        
        // 3. إنشاء رسالة الشكر (Toast)
        if (parentView) {
            UILabel *toastLabel = [[UILabel alloc] init];
            toastLabel.text = @"شكراً لكم المطور الوحيد حسين الحسني";
            toastLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
            toastLabel.textColor = [UIColor whiteColor];
            toastLabel.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.9];
            toastLabel.textAlignment = NSTextAlignmentCenter;
            toastLabel.layer.cornerRadius = 20;
            toastLabel.layer.masksToBounds = YES;
            
            // ضبط حجم الرسالة بناءً على النص
            CGSize textSize = [toastLabel.text sizeWithAttributes:@{NSFontAttributeName:toastLabel.font}];
            toastLabel.frame = CGRectMake((parentView.bounds.size.width - textSize.width - 40)/2,
                                          parentView.bounds.size.height - 100, // تظهر في أسفل الشاشة
                                          textSize.width + 40, 40);
            
            toastLabel.alpha = 0;
            toastLabel.transform = CGAffineTransformMakeTranslation(0, 20);
            [parentView addSubview:toastLabel];
            
            // أنيميشن ظهور رسالة الشكر
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                toastLabel.alpha = 1;
                toastLabel.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                // أنيميشن اختفاء رسالة الشكر بعد ثانيتين
                [UIView animateWithDuration:0.4 delay:2.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    toastLabel.alpha = 0;
                    toastLabel.transform = CGAffineTransformMakeTranslation(0, 20);
                } completion:^(BOOL finished) {
                    [toastLabel removeFromSuperview];
                }];
            }];
        }
    }];
}
@end

// ==========================================
// 3. الاستدعاء المضمون (Hook UIViewController)
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
                alert.layer.zPosition = 9999; // البقاء في أعلى طبقة
                [targetView addSubview:alert];
            }
        });
    });
}

%end

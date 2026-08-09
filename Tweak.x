#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

static NSString *const kHideHassanyWelcome = @"HassanyWelcomeDismissed_v2";

// ==========================================
// 1. دالة لجلب النافذة الفعالة لأي تطبيق بالعالم
// ==========================================
UIWindow *GetUniversalWindow() {
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *w in windowScene.windows) {
                    if (w.isKeyWindow) return w;
                }
                return windowScene.windows.firstObject;
            }
        }
    }
    return [[UIApplication sharedApplication].windows firstObject];
}

// ==========================================
// 2. كلاس الإشعار (Notification Banner)
// ==========================================
@interface HassanyBanner : UIView
+ (void)showBanner;
@end

@implementation HassanyBanner
+ (void)showBanner {
    UIWindow *window = GetUniversalWindow();
    if (!window) return;

    CGFloat bannerWidth = window.bounds.size.width - 32;
    CGFloat topPadding = 50; // حتى يعبر النوتش أو الجزيرة التفاعلية
    
    // تصميم الإشعار (Blur)
    UIVisualEffectView *banner = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemChromeMaterialDark]];
    banner.frame = CGRectMake(16, -100, bannerWidth, 75);
    banner.layer.cornerRadius = 20;
    banner.layer.cornerCurve = kCACornerCurveContinuous;
    banner.clipsToBounds = YES;
    banner.layer.borderWidth = 0.5;
    banner.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
    
    // صورة الإشعار (صورة قناتك)
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 50, 50)];
    icon.layer.cornerRadius = 12;
    icon.clipsToBounds = YES;
    icon.contentMode = UIViewContentModeScaleAspectFill;
    [banner.contentView addSubview:icon];
    
    // تحميل الصورة للإشعار
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://k.top4top.io/p_3872ymbwu0.jpeg"]];
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                icon.image = [UIImage imageWithData:data];
            });
        }
    });

    // عنوان الإشعار
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, bannerWidth - 100, 20)];
    title.text = @"Hassany Store";
    title.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentLeft;
    [banner.contentView addSubview:title];

    // نص الإشعار
    UILabel *body = [[UILabel alloc] initWithFrame:CGRectMake(80, 38, bannerWidth - 100, 20)];
    body.text = @"شكراً لكم الحسني معكم";
    body.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    body.textColor = [UIColor lightGrayColor];
    body.textAlignment = NSTextAlignmentLeft;
    [banner.contentView addSubview:body];

    [window addSubview:banner];

    // أنيميشن النزول (Spring Animation مثل أبل)
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        banner.frame = CGRectMake(16, topPadding, bannerWidth, 75);
    } completion:^(BOOL finished) {
        // أنيميشن الصعود والاختفاء بعد 3 ثواني
        [UIView animateWithDuration:0.4 delay:3.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            banner.frame = CGRectMake(16, -100, bannerWidth, 75);
            banner.alpha = 0;
        } completion:^(BOOL finished) {
            [banner removeFromSuperview];
        }];
    }];
}
@end


// ==========================================
// 3. كلاس الرسالة الترحيبية (Universal Alert)
// ==========================================
@interface HassanyUniversalAlert : UIView
@property (nonatomic, strong) UISwitch *toggleSwitch;
@end

@implementation HassanyUniversalAlert

+ (void)show {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kHideHassanyWelcome]) return;
    
    UIWindow *window = GetUniversalWindow();
    if (!window) return;

    HassanyUniversalAlert *alert = [[HassanyUniversalAlert alloc] initWithFrame:window.bounds];
    [window addSubview:alert];
    [alert animateIn];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 1. الخلفية الشفافة (Dark Blur)
        UIVisualEffectView *bgBlur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        bgBlur.frame = self.bounds;
        bgBlur.alpha = 0.9;
        [self addSubview:bgBlur];

        // 2. دوائر مضيئة متحركة بشكل احترافي بالخلفية
        UIView *glow1 = [[UIView alloc] initWithFrame:CGRectMake(-100, -100, 400, 400)];
        glow1.backgroundColor = [[UIColor systemBlueColor] colorWithAlphaComponent:0.4];
        glow1.layer.cornerRadius = 200;
        glow1.layer.filters = @[[CAFilter filterWithName:@"gaussianBlur"]]; // تأثير ضبابي
        [glow1.layer setValue:@(80) forKeyPath:@"filters.gaussianBlur.inputRadius"];
        [self addSubview:glow1];

        UIView *glow2 = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width - 200, frame.size.height - 300, 350, 350)];
        glow2.backgroundColor = [[UIColor systemPurpleColor] colorWithAlphaComponent:0.4];
        glow2.layer.cornerRadius = 175;
        glow2.layer.filters = @[[CAFilter filterWithName:@"gaussianBlur"]];
        [glow2.layer setValue:@(80) forKeyPath:@"filters.gaussianBlur.inputRadius"];
        [self addSubview:glow2];

        // تحريك الإضاءة
        [UIView animateWithDuration:8.0 delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut animations:^{
            glow1.transform = CGAffineTransformMakeTranslation(150, 200);
            glow2.transform = CGAffineTransformMakeTranslation(-150, -200);
        } completion:nil];

        // 3. المربع الأساسي (الكارد الأكبر والأفخم)
        CGFloat cardWidth = frame.size.width * 0.88;
        UIView *card = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cardWidth, 520)];
        card.center = self.center;
        card.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.75]; // شفافية زجاجية
        card.layer.cornerRadius = 28;
        card.layer.cornerCurve = kCACornerCurveContinuous;
        card.clipsToBounds = YES;
        card.layer.borderWidth = 1.5;
        card.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.15].CGColor;
        [self addSubview:card];
        
        // تأثير بلور للكارد نفسه (Glassmorphism)
        UIVisualEffectView *cardBlur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemChromeMaterialDark]];
        cardBlur.frame = card.bounds;
        [card addSubview:cardBlur];
        [card sendSubviewToBack:cardBlur];

        // 4. صورة المطور
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((cardWidth-110)/2, 35, 110, 110)];
        imageView.layer.cornerRadius = 25;
        imageView.layer.cornerCurve = kCACornerCurveContinuous;
        imageView.clipsToBounds = YES;
        imageView.layer.borderWidth = 2;
        imageView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.8].CGColor;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [card addSubview:imageView];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://k.top4top.io/p_3872ymbwu0.jpeg"]];
            if (data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.image = [UIImage imageWithData:data];
                });
            }
        });

        // 5. النصوص
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 165, cardWidth-40, 35)];
        title.text = @"يا هلا بيك";
        title.textColor = [UIColor whiteColor];
        title.font = [UIFont systemFontOfSize:26 weight:UIFontWeightHeavy];
        title.textAlignment = NSTextAlignmentCenter;
        [card addSubview:title];

        UILabel *sub = [[UILabel alloc] initWithFrame:CGRectMake(25, 205, cardWidth-50, 65)];
        sub.text = @"تابعنا للمزيد من التطبيقات المميزة، ولا تتردد بالتواصل مع المطور لطرح أي سؤال أو حل مشكلة.";
        sub.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
        sub.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        sub.textAlignment = NSTextAlignmentCenter;
        sub.numberOfLines = 0;
        [card addSubview:sub];

        // 6. مفتاح (لا تظهر مجدداً) باستخدام أيقونة جرس
        UIImageView *bellIcon = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"bell.slash.fill"]];
        bellIcon.frame = CGRectMake(25, 290, 20, 20);
        bellIcon.tintColor = [UIColor whiteColor];
        [card addSubview:bellIcon];

        UILabel *switchLbl = [[UILabel alloc] initWithFrame:CGRectMake(55, 285, cardWidth-120, 30)];
        switchLbl.text = @"عدم الإظهار مجدداً";
        switchLbl.textColor = [UIColor whiteColor];
        switchLbl.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
        [card addSubview:switchLbl];

        self.toggleSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(cardWidth - 75, 285, 50, 30)];
        self.toggleSwitch.onTintColor = [UIColor systemBlueColor];
        [card addSubview:self.toggleSwitch];

        // 7. إنشاء الأزرار مع رسمات أبل الرسمية (SF Symbols) بدل الايموجي
        CGFloat btnY = 340;
        
        [self createButtonOnView:card frame:CGRectMake(25, btnY, cardWidth-50, 50) title:@"قناتنا الرسمية" iconName:@"paperplane.fill" color:[UIColor systemBlueColor] action:@selector(openTg)];
        btnY += 60;
        
        [self createButtonOnView:card frame:CGRectMake(25, btnY, cardWidth-50, 50) title:@"المطور" iconName:@"terminal.fill" color:[UIColor systemIndigoColor] action:@selector(openDev)];
        btnY += 60;
        
        [self createButtonOnView:card frame:CGRectMake(25, btnY, cardWidth-50, 50) title:@"شكراً" iconName:@"checkmark.seal.fill" color:[UIColor colorWithWhite:1 alpha:0.15] action:@selector(dismissAlert)];
    }
    return self;
}

// دالة مساعدة لرسم الأزرار بشكل احترافي مع الأيقونات
- (void)createButtonOnView:(UIView *)parent frame:(CGRect)frame title:(NSString *)title iconName:(NSString *)iconName color:(UIColor *)color action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = frame;
    btn.backgroundColor = color;
    btn.layer.cornerRadius = 16;
    btn.layer.cornerCurve = kCACornerCurveContinuous;
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    // إضافة الأيقونة البرمجية
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:iconName]];
    icon.frame = CGRectMake(20, 12, 26, 26);
    icon.tintColor = [UIColor whiteColor];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    [btn addSubview:icon];
    
    // إضافة النص
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, frame.size.width - 75, 50)];
    lbl.text = title;
    lbl.textColor = [UIColor whiteColor];
    lbl.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
    lbl.textAlignment = NSTextAlignmentLeft;
    [btn addSubview:lbl];
    
    [parent addSubview:btn];
}

- (void)openTg {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/hassanyIPA"] options:@{} completionHandler:nil];
}

- (void)openDev {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/OM_G9"] options:@{} completionHandler:nil];
}

- (void)dismissAlert {
    if (self.toggleSwitch.isOn) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kHideHassanyWelcome];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    // إخفاء الشاشة الحالية
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
        self.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        // 🔥 تشغيل إشعار النظام بعد إخفاء الشاشة مباشرة
        dispatch_async(dispatch_get_main_queue(), ^{
            [HassanyBanner showBanner];
        });
    }];
}

- (void)animateIn {
    self.alpha = 0.0;
    self.transform = CGAffineTransformMakeScale(1.1, 1.1);
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1.0;
        self.transform = CGAffineTransformIdentity;
    } completion:nil];
}
@end


// ==========================================
// 4. قلب الدايليب: تشغيل غصباً على أي تطبيق
// ==========================================
%ctor {
    // ننتظر التطبيق يفتح ويصير جاهز 100% باستخدام نظام المراقبة العالمي
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            // تأخير ثانية وحدة حتى تظهر واجهة التطبيق بشكل كامل وتستقر
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [HassanyUniversalAlert show];
            });
        });
        
    }];
}

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// مفتاح الحفظ حتى ما تظهر الرسالة مرة ثانية إذا تفعل الزر
static NSString *const kHideHassanyWelcome = @"HassanyWelcomeDismissed";

@interface HassanyWelcomeAlert : UIView
@property (nonatomic, strong) UISwitch *toggleSwitch;
@end

@implementation HassanyWelcomeAlert

+ (void)show {
    // التحقق إذا المستخدم طلب عدم إظهار الرسالة
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kHideHassanyWelcome]) return;

    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *targetWindow = nil;

        // الطريقة الحديثة والآمنة لجلب النافذة 
        if (@available(iOS 13.0, *)) {
            for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                    UIWindowScene *windowScene = (UIWindowScene *)scene;
                    targetWindow = windowScene.windows.firstObject; 
                    for (UIWindow *w in windowScene.windows) {
                        if (w.isKeyWindow) {
                            targetWindow = w;
                            break;
                        }
                    }
                    break;
                }
            }
        }
        
        if (!targetWindow) {
            targetWindow = [[UIApplication sharedApplication] delegate].window;
        }
        if (!targetWindow) {
            targetWindow = [[UIApplication sharedApplication].windows firstObject];
        }

        if (!targetWindow) return;

        HassanyWelcomeAlert *alert = [[HassanyWelcomeAlert alloc] initWithFrame:targetWindow.bounds];
        [targetWindow addSubview:alert];
        [alert animateIn];
    });
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 1. الخلفية الشفافة والدوائر المتحركة
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];

        UIView *purpleCircle = [[UIView alloc] initWithFrame:CGRectMake(-50, -50, 300, 300)];
        purpleCircle.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.4];
        purpleCircle.layer.cornerRadius = 150;
        [self addSubview:purpleCircle];

        UIView *blueCircle = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width - 200, frame.size.height - 300, 250, 250)];
        blueCircle.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.4];
        blueCircle.layer.cornerRadius = 125;
        [self addSubview:blueCircle];

        UIVisualEffectView *bgBlur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        bgBlur.frame = self.bounds;
        [self addSubview:bgBlur];

        // تحريك الدوائر باستمرار
        [UIView animateWithDuration:6.0 delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut animations:^{
            purpleCircle.frame = CGRectOffset(purpleCircle.frame, 100, 150);
            blueCircle.frame = CGRectOffset(blueCircle.frame, -100, -150);
        } completion:nil];

        // 2. المربع الأساسي (Card)
        CGFloat cardWidth = frame.size.width * 0.85;
        UIView *card = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cardWidth, 480)];
        card.center = self.center;
        card.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.18 alpha:1.0]; 
        card.layer.cornerRadius = 22;
        card.clipsToBounds = YES;
        card.layer.borderWidth = 1;
        card.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.1].CGColor;
        [self addSubview:card];

        // 3. صورة المطور (تحميل مباشر من الرابط)
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((cardWidth-100)/2, 30, 100, 100)];
        imageView.layer.cornerRadius = 20;
        imageView.clipsToBounds = YES;
        imageView.layer.borderWidth = 1.5;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
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

        // 4. العنوان
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 145, cardWidth-40, 30)];
        title.text = @"يا هلا بيك";
        title.textColor = [UIColor whiteColor];
        title.font = [UIFont boldSystemFontOfSize:22];
        title.textAlignment = NSTextAlignmentCenter;
        [card addSubview:title];

        // 5. الوصف
        UILabel *sub = [[UILabel alloc] initWithFrame:CGRectMake(20, 180, cardWidth-40, 60)];
        sub.text = @"تابعنا للمزيد من التطبيقات المميزة ، ولا تتردد بالتواصل مع المطور لطرح اي سؤال او حل مشكلة ❤️ .";
        sub.textColor = [UIColor lightGrayColor];
        sub.font = [UIFont systemFontOfSize:13.5];
        sub.textAlignment = NSTextAlignmentCenter;
        sub.numberOfLines = 0;
        [card addSubview:sub];

        // خط فاصل
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(20, 255, cardWidth-40, 1)];
        sep.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
        [card addSubview:sep];

        // 6. زر التفعيل والنص (لا تظهر مجدداً)
        UILabel *switchLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 270, cardWidth-90, 30)];
        switchLbl.text = @"لا تظهر هذه الرسالة مجدداً 🔔";
        switchLbl.textColor = [UIColor whiteColor];
        switchLbl.font = [UIFont systemFontOfSize:14];
        switchLbl.textAlignment = NSTextAlignmentLeft;
        [card addSubview:switchLbl];

        self.toggleSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(cardWidth - 70, 270, 50, 30)];
        self.toggleSwitch.onTintColor = [UIColor colorWithRed:0.25 green:0.4 blue:0.95 alpha:1.0];
        [card addSubview:self.toggleSwitch];

        // 7. الأزرار
        CGFloat btnY = 320;

        UIButton *tgBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        tgBtn.frame = CGRectMake(20, btnY, cardWidth-40, 45);
        tgBtn.backgroundColor = [UIColor colorWithRed:0.25 green:0.4 blue:0.95 alpha:1.0]; 
        [tgBtn setTitle:@"قـناتـنـا ✈️" forState:UIControlStateNormal];
        [tgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        tgBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        tgBtn.layer.cornerRadius = 12;
        [tgBtn addTarget:self action:@selector(openTg) forControlEvents:UIControlEventTouchUpInside];
        [card addSubview:tgBtn];
        btnY += 55;

        UIButton *devBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        devBtn.frame = CGRectMake(20, btnY, cardWidth-40, 45);
        devBtn.backgroundColor = [UIColor colorWithRed:0.25 green:0.4 blue:0.95 alpha:1.0]; 
        [devBtn setTitle:@"المطـور 👨🏻‍💻" forState:UIControlStateNormal];
        [devBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        devBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        devBtn.layer.cornerRadius = 12;
        [devBtn addTarget:self action:@selector(openDev) forControlEvents:UIControlEventTouchUpInside];
        [card addSubview:devBtn];
        btnY += 55;

        UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        dismissBtn.frame = CGRectMake(20, btnY, cardWidth-40, 45);
        dismissBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1]; 
        [dismissBtn setTitle:@"شكراً ❤️" forState:UIControlStateNormal];
        [dismissBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        dismissBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        dismissBtn.layer.cornerRadius = 12;
        [dismissBtn addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
        [card addSubview:dismissBtn];
    }
    return self;
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
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
        self.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)animateIn {
    self.alpha = 0.0;
    self.transform = CGAffineTransformMakeScale(1.1, 1.1);
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
        self.transform = CGAffineTransformIdentity;
    }];
}
@end

// تشغيل الشاشة غصباً عن التطبيق أول ما تظهر واجهته
%hook UIViewController

- (void)viewDidAppear:(BOOL)animated {
    %orig;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HassanyWelcomeAlert show];
        });
    });
}

%end

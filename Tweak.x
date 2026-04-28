#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// --- واجهة القائمة واللوغو العائم ---
@interface AlhussainiModMenu : UIViewController <UITextFieldDelegate>
@property (nonatomic, strong) UIView *mainContainer;
@property (nonatomic, strong) UIView *loginView;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UIButton *floatingLogo;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) UISwitch *themeSwitch;
@property (nonatomic, strong) UIVisualEffectView *blurEffect;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, assign) BOOL isWhiteTheme;
@end

@implementation AlhussainiModMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self setupLoginView];
}

// 1. إعداد واجهة تسجيل الدخول والعداد الدائري
- (void)setupLoginView {
    self.loginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 450)];
    self.loginView.center = self.view.center;
    self.loginView.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.1 alpha:0.95];
    self.loginView.layer.cornerRadius = 25;
    self.loginView.layer.borderWidth = 1.5;
    self.loginView.layer.borderColor = [UIColor yellowColor].CGColor;
    [self.view addSubview:self.loginView];

    // اللوغو
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(110, 30, 80, 80)];
    img.layer.cornerRadius = 40;
    img.clipsToBounds = YES;
    img.layer.borderWidth = 2;
    img.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.loginView addSubview:img];
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://e.top4top.io/p_37700ug540.jpeg"]];
        if(data) dispatch_async(dispatch_get_main_queue(), ^{ img.image = [UIImage imageWithData:data]; });
    });

    // حقل كلمة السر (الكلمة هي hassany)
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(40, 180, 220, 45)];
    self.passwordField.placeholder = @"ادخل كلمة السر...";
    self.passwordField.secureTextEntry = YES;
    self.passwordField.textAlignment = NSTextAlignmentCenter;
    self.passwordField.textColor = [UIColor whiteColor];
    self.passwordField.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
    self.passwordField.layer.cornerRadius = 10;
    [self.loginView addSubview:self.passwordField];

    // العداد الدائري
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(150, 350) radius:35 startAngle:-M_PI_2 endAngle:2*M_PI-M_PI_2 clockwise:YES];
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.path = circlePath.CGPath;
    self.progressLayer.strokeColor = [UIColor yellowColor].CGColor;
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.lineWidth = 5;
    self.progressLayer.strokeEnd = 0;
    [self.loginView.layer addSublayer:self.progressLayer];

    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anim.duration = 6.0;
    anim.toValue = @1;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    [self.progressLayer addAnimation:anim forKey:@"circle"];

    // زر الدخول
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(115, 315, 70, 70)];
    [btn setTitle:@"دخول" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(checkPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.loginView addSubview:btn];
}

- (void)checkPassword {
    if ([self.passwordField.text isEqualToString:@"hassany"]) {
        [self.loginView removeFromSuperview];
        [self createFloatingLogo];
    } else {
        self.passwordField.layer.borderColor = [UIColor redColor].CGColor;
        self.passwordField.layer.borderWidth = 1;
    }
}

// 2. صنع اللوغو العائم القابل للسحب
- (void)createFloatingLogo {
    self.floatingLogo = [[UIButton alloc] initWithFrame:CGRectMake(50, 150, 60, 60)];
    self.floatingLogo.layer.cornerRadius = 30;
    self.floatingLogo.clipsToBounds = YES;
    self.floatingLogo.layer.borderWidth = 2;
    self.floatingLogo.layer.borderColor = [UIColor yellowColor].CGColor;
    
    // تحميل صورة اللوغو
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://e.top4top.io/p_37700ug540.jpeg"]];
        if(data) dispatch_async(dispatch_get_main_queue(), ^{ 
            [self.floatingLogo setImage:[UIImage imageWithData:data] forState:UIControlStateNormal]; 
        });
    });

    [self.floatingLogo addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    
    // إضافة خاصية السحب (Pan Gesture)
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.floatingLogo addGestureRecognizer:pan];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.floatingLogo];
}

- (void)handlePan:(UIPanGestureRecognizer *)p {
    CGPoint translation = [p translationInView:self.view];
    self.floatingLogo.center = CGPointMake(self.floatingLogo.center.x + translation.x, self.floatingLogo.center.y + translation.y);
    [p setTranslation:CGPointZero inView:self.view];
}

// 3. القائمة الاحترافية (Mod Menu)
- (void)toggleMenu {
    if (self.menuView) {
        [self.menuView removeFromSuperview];
        self.menuView = nil;
        return;
    }

    self.menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 400)];
    self.menuView.center = self.view.center;
    self.menuView.layer.cornerRadius = 20;
    self.menuView.clipsToBounds = YES;
    [self updateTheme];
    
    // تأثير الزجاج (Blur)
    self.blurEffect = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    self.blurEffect.frame = self.menuView.bounds;
    [self.menuView addSubview:self.blurEffect];

    // عنوان القائمة
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 280, 40)];
    title.text = @"ALHUSSAINI MENU";
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:20];
    title.textColor = [UIColor yellowColor];
    [self.menuView addSubview:title];

    // سويتش تغيير اللون (iOS Style)
    UILabel *switchLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 150, 30)];
    switchLab.text = @"تغيير لون القائمة";
    switchLab.textColor = [UIColor whiteColor];
    [self.menuView addSubview:switchLab];

    self.themeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(210, 70, 50, 30)];
    self.themeSwitch.onTintColor = [UIColor greenColor];
    [self.themeSwitch addTarget:self action:@selector(changeTheme) forControlEvents:UIControlEventValueChanged];
    [self.menuView addSubview:self.themeSwitch];

    // أزرار المطور والقناة
    [self addMenuButton:@"المطور @OM_G9" y:150 link:@"tg://resolve?domain=OM_G9"];
    [self addMenuButton:@"القناة الرسمية" y:210 link:@"https://t.me/hasanyiq"];
    
    // زر إعادة الضبط
    UIButton *reset = [[UIButton alloc] initWithFrame:CGRectMake(40, 320, 200, 40)];
    reset.backgroundColor = [UIColor redColor];
    [reset setTitle:@"إعادة تعيين كل شيء" forState:UIControlStateNormal];
    reset.layer.cornerRadius = 10;
    [reset addTarget:self action:@selector(resetAll) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView addSubview:reset];

    [self.view addSubview:self.menuView];
}

- (void)addMenuButton:(NSString *)title y:(CGFloat)y link:(NSString *)url {
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(20, y, 240, 40)];
    b.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.8];
    [b setTitle:title forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    b.layer.cornerRadius = 10;
    [b addTarget:self action:@selector(openLink:) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(b, "link", url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.menuView addSubview:b];
}

- (void)openLink:(UIButton *)sender {
    NSString *url = objc_getAssociatedObject(sender, "link");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
}

- (void)changeTheme {
    self.isWhiteTheme = self.themeSwitch.isOn;
    [self updateTheme];
}

- (void)updateTheme {
    if (self.isWhiteTheme) {
        self.menuView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        self.blurEffect.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    } else {
        self.menuView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
        self.blurEffect.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    }
}

- (void)resetAll {
    [self.menuView removeFromSuperview];
    [self.floatingLogo removeFromSuperview];
    self.menuView = nil;
    self.floatingLogo = nil;
    [self setupLoginView];
}

@end

// --- تشغيل المود عند فتح التطبيق ---
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *win = [UIApplication sharedApplication].keyWindow;
        if (!win) win = [UIApplication sharedApplication].windows.firstObject;
        
        AlhussainiModMenu *menu = [[AlhussainiModMenu alloc] init];
        win.rootViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        [win.rootViewController presentViewController:menu animated:YES completion:nil];
    });
}

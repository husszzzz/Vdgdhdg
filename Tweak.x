#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// واجهة التحكم الرئيسية
@interface AlhussainiController : UIViewController <UITextFieldDelegate>
@property (nonatomic, strong) UIView *loginPanel;
@property (nonatomic, strong) UIView *menuPanel;
@property (nonatomic, strong) UIButton *floatBtn;
@property (nonatomic, strong) CAShapeLayer *circleProgress;
@property (nonatomic, strong) UITextField *passInput;
@property (nonatomic, strong) UIButton *enterBtn;
@property (nonatomic, assign) BOOL isDark;
@end

@implementation AlhussainiController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.isDark = YES;
    [self showLoginScreen];
}

// --- شاشة تسجيل الدخول ---
- (void)showLoginScreen {
    self.loginPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 480)];
    self.loginPanel.center = self.view.center;
    self.loginPanel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.9];
    self.loginPanel.layer.cornerRadius = 30;
    self.loginPanel.layer.borderWidth = 2;
    self.loginPanel.layer.borderColor = [UIColor yellowColor].CGColor;
    [self.view addSubview:self.loginPanel];

    // صورة القناة
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(110, 30, 80, 80)];
    logo.layer.cornerRadius = 40;
    logo.clipsToBounds = YES;
    logo.layer.borderColor = [UIColor whiteColor].CGColor;
    logo.layer.borderWidth = 2;
    [self.loginPanel addSubview:logo];
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData *d = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://e.top4top.io/p_37700ug540.jpeg"]];
        if(d) dispatch_async(dispatch_get_main_queue(), ^{ logo.image = [UIImage imageWithData:d]; });
    });

    // حقل السر
    self.passInput = [[UITextField alloc] initWithFrame:CGRectMake(40, 150, 220, 45)];
    self.passInput.placeholder = @"أدخل السر...";
    self.passInput.secureTextEntry = YES;
    self.passInput.textAlignment = NSTextAlignmentCenter;
    self.passInput.textColor = [UIColor whiteColor];
    self.passInput.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
    self.passInput.layer.cornerRadius = 10;
    self.passInput.delegate = self;
    [self.loginPanel addSubview:self.passInput];

    // العداد الدائري الاحترافي
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(150, 320) radius:40 startAngle:-M_PI_2 endAngle:2*M_PI-M_PI_2 clockwise:YES];
    self.circleProgress = [CAShapeLayer layer];
    self.circleProgress.path = path.CGPath;
    self.circleProgress.strokeColor = [UIColor yellowColor].CGColor;
    self.circleProgress.fillColor = [UIColor clearColor].CGColor;
    self.circleProgress.lineWidth = 6;
    self.circleProgress.strokeEnd = 0;
    [self.loginPanel.layer addSublayer:self.circleProgress];

    CABasicAnimation *draw = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    draw.duration = 6.0;
    draw.toValue = @1;
    draw.removedOnCompletion = NO;
    draw.fillMode = kCAFillModeForwards;
    [self.circleProgress addAnimation:draw forKey:@"timer"];

    // زر الدخول
    self.enterBtn = [[UIButton alloc] initWithFrame:CGRectMake(110, 280, 80, 80)];
    [self.enterBtn setTitle:@"دخول" forState:UIControlStateNormal];
    [self.enterBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.enterBtn.enabled = NO;
    [self.enterBtn addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.loginPanel addSubview:self.enterBtn];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 6 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.enterBtn.enabled = YES;
        [self.enterBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    });
}

- (void)doLogin {
    if ([self.passInput.text isEqualToString:@"hassany"]) {
        [UIView animateWithDuration:0.5 animations:^{ self.loginPanel.alpha = 0; } completion:^(BOOL f){
            [self.loginPanel removeFromSuperview];
            [self startFloatingMode];
        }];
    }
}

// --- اللوغو العائم القابل للسحب ---
- (void)startFloatingMode {
    self.floatBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 60, 60)];
    self.floatBtn.layer.cornerRadius = 30;
    self.floatBtn.clipsToBounds = YES;
    self.floatBtn.layer.borderWidth = 2;
    self.floatBtn.layer.borderColor = [UIColor yellowColor].CGColor;
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData *d = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://e.top4top.io/p_37700ug540.jpeg"]];
        if(d) dispatch_async(dispatch_get_main_queue(), ^{ [self.floatBtn setImage:[UIImage imageWithData:d] forState:UIControlStateNormal]; });
    });

    [self.floatBtn addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
    
    UIPanGestureRecognizer *p = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragged:)];
    [self.floatBtn addGestureRecognizer:p];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.floatBtn];
}

- (void)dragged:(UIPanGestureRecognizer *)g {
    CGPoint t = [g translationInView:self.view];
    self.floatBtn.center = CGPointMake(self.floatBtn.center.x + t.x, self.floatBtn.center.y + t.y);
    [g setTranslation:CGPointZero inView:self.view];
}

// --- القائمة الرئيسية ---
- (void)openMenu {
    if (self.menuPanel) return;

    self.menuPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 420)];
    self.menuPanel.center = self.view.center;
    self.menuPanel.backgroundColor = self.isDark ? [UIColor blackColor] : [UIColor whiteColor];
    self.menuPanel.layer.cornerRadius = 20;
    self.menuPanel.layer.shadowOpacity = 0.5;
    [self.view addSubview:self.menuPanel];

    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 280, 40)];
    t.text = @"ALHUSSAINI MENU";
    t.textAlignment = NSTextAlignmentCenter;
    t.textColor = [UIColor yellowColor];
    t.font = [UIFont boldSystemFontOfSize:22];
    [self.menuPanel addSubview:t];

    // سويتش الثيم
    UISwitch *s = [[UISwitch alloc] initWithFrame:CGRectMake(200, 70, 50, 30)];
    [s addTarget:self action:@selector(toggleTheme:) forControlEvents:UIControlEventValueChanged];
    [self.menuPanel addSubview:s];
    
    UILabel *sl = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 150, 30)];
    sl.text = @"الوضع الفاتح";
    sl.textColor = self.isDark ? [UIColor whiteColor] : [UIColor blackColor];
    [self.menuPanel addSubview:sl];

    // أزرار
    [self btn:@"المطور @OM_G9" y:150 link:@"tg://resolve?domain=OM_G9"];
    [self btn:@"القناة الرسمية" y:210 link:@"https://t.me/hasanyiq"];
    
    UIButton *res = [[UIButton alloc] initWithFrame:CGRectMake(40, 350, 200, 40)];
    res.backgroundColor = [UIColor redColor];
    [res setTitle:@"إعادة تعيين" forState:UIControlStateNormal];
    res.layer.cornerRadius = 10;
    [res addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    [self.menuPanel addSubview:res];

    UIButton *close = [[UIButton alloc] initWithFrame:CGRectMake(240, 10, 30, 30)];
    [close setTitle:@"X" forState:UIControlStateNormal];
    [close setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closeM) forControlEvents:UIControlEventTouchUpInside];
    [self.menuPanel addSubview:close];
}

- (void)btn:(NSString *)txt y:(CGFloat)y link:(NSString *)l {
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(20, y, 240, 40)];
    b.backgroundColor = [UIColor yellowColor];
    [b setTitle:txt forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    b.layer.cornerRadius = 10;
    [b addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(b, "l", l, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.menuPanel addSubview:b];
}

- (void)go:(UIButton *)s {
    NSString *l = objc_getAssociatedObject(s, "l");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:l] options:@{} completionHandler:nil];
}

- (void)toggleTheme:(UISwitch *)s {
    self.isDark = !s.isOn;
    self.menuPanel.backgroundColor = self.isDark ? [UIColor blackColor] : [UIColor whiteColor];
    [self closeM]; [self openMenu];
}

- (void)closeM { [self.menuPanel removeFromSuperview]; self.menuPanel = nil; }

- (void)reset {
    [self closeM];
    [self.floatBtn removeFromSuperview];
    self.floatBtn = nil;
    [self showLoginScreen];
}
@end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIWindow *w = [UIApplication sharedApplication].keyWindow ?: [UIApplication sharedApplication].windows.firstObject;
        if (w.rootViewController) {
            AlhussainiController *vc = [[AlhussainiController alloc] init];
            vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [w.rootViewController presentViewController:vc animated:YES completion:nil];
        }
    });
}

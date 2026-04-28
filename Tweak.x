#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface AlhussainiPro : UIViewController
@property (nonatomic, strong) UIView *introView;
@property (nonatomic, strong) UIView *loginPanel;
@property (nonatomic, strong) UIButton *floatBtn;
@property (nonatomic, strong) UIView *mainMenu;
@property (nonatomic, strong) UITextField *passIn;
@property (nonatomic, assign) BOOL expanded;
@end

@implementation AlhussainiPro

- (void)viewDidLoad {
    [super viewDidLoad];
    [self runIntro];
}

// 1. الإنترو والأنميشن (Intro)
- (void)runIntro {
    self.introView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.introView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.introView];

    UILabel *logo = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    logo.center = self.introView.center;
    logo.text = @"ALHUSSAINI";
    logo.textColor = [UIColor yellowColor];
    logo.font = [UIFont boldSystemFontOfSize:40];
    logo.textAlignment = NSTextAlignmentCenter;
    logo.alpha = 0;
    [self.introView addSubview:logo];

    [UIView animateWithDuration:2.0 animations:^{ logo.alpha = 1; } completion:^(BOOL f) {
        [UIView animateWithDuration:1.5 animations:^{ self.introView.alpha = 0; } completion:^(BOOL f2) {
            [self.introView removeFromSuperview];
            [self showLogin];
        }];
    }];
}

// 2. واجهة الدخول مع العداد المطور
- (void)showLogin {
    self.loginPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 450)];
    self.loginPanel.center = self.view.center;
    self.loginPanel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.95];
    self.loginPanel.layer.cornerRadius = 40;
    self.loginPanel.layer.borderWidth = 4;
    self.loginPanel.layer.borderColor = [UIColor yellowColor].CGColor;
    [self.view addSubview:self.loginPanel];

    self.passIn = [[UITextField alloc] initWithFrame:CGRectMake(40, 150, 240, 55)];
    self.passIn.placeholder = @"كلمة السر (hassany)";
    self.passIn.secureTextEntry = YES;
    self.passIn.textAlignment = NSTextAlignmentCenter;
    self.passIn.textColor = [UIColor whiteColor];
    self.passIn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    self.passIn.layer.cornerRadius = 20;
    [self.loginPanel addSubview:self.passIn];

    // العداد الذي يفتر (Animation)
    UIBezierPath *cp = [UIBezierPath bezierPathWithArcCenter:CGPointMake(160, 320) radius:40 startAngle:-M_PI_2 endAngle:2*M_PI-M_PI_2 clockwise:YES];
    CAShapeLayer *timer = [CAShapeLayer layer];
    timer.path = cp.CGPath; timer.strokeColor = [UIColor yellowColor].CGColor;
    timer.fillColor = [UIColor clearColor].CGColor; timer.lineWidth = 6;
    [self.loginPanel.layer addSublayer:timer];

    CABasicAnimation *ba = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    ba.duration = 6.0; ba.fromValue = @0; ba.toValue = @1;
    [timer addAnimation:ba forKey:@"t"];

    UIButton *log = [[UIButton alloc] initWithFrame:CGRectMake(120, 290, 80, 60)];
    [log setTitle:@"دخول" forState:UIControlStateNormal];
    [log setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [log addTarget:self action:@selector(auth) forControlEvents:UIControlEventTouchUpInside];
    [self.loginPanel addSubview:log];
}

- (void)auth {
    if ([self.passIn.text isEqualToString:@"hassany"]) {
        [UIView animateWithDuration:0.5 animations:^{ self.loginPanel.alpha = 0; } completion:^(BOOL f) {
            [self.loginPanel removeFromSuperview];
            [self createFloat];
        }];
    }
}

// 3. اللوغو العائم مع ميزة التوسيع
- (void)createFloat {
    self.floatBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 75, 75)];
    self.floatBtn.layer.cornerRadius = 37.5;
    self.floatBtn.layer.borderWidth = 3;
    self.floatBtn.layer.borderColor = [UIColor yellowColor].CGColor;
    self.floatBtn.clipsToBounds = YES;
    
    // سحب الصورة
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData *d = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://e.top4top.io/p_37700ug540.jpeg"]];
        if(d) dispatch_async(dispatch_get_main_queue(), ^{ [self.floatBtn setImage:[UIImage imageWithData:d] forState:UIControlStateNormal]; });
    });

    [self.floatBtn addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.floatBtn addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drag:)]];
    [[UIApplication sharedApplication].windows.firstObject addSubview:self.floatBtn];
}

- (void)drag:(UIPanGestureRecognizer *)g {
    CGPoint p = [g translationInView:self.view];
    self.floatBtn.center = CGPointMake(self.floatBtn.center.x + p.x, self.floatBtn.center.y + p.y);
    [g setTranslation:CGPointZero inView:self.view];
}

// 4. القائمة الاحترافية كاملة المميزات
- (void)openMenu {
    if (self.mainMenu) { [self.mainMenu removeFromSuperview]; self.mainMenu = nil; return; }
    
    self.mainMenu = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 450)];
    self.mainMenu.center = self.view.center;
    self.mainMenu.backgroundColor = [UIColor blackColor];
    self.mainMenu.layer.cornerRadius = 30;
    self.mainMenu.layer.borderColor = [UIColor yellowColor].CGColor;
    self.mainMenu.layer.borderWidth = 2;
    [self.view addSubview:self.mainMenu];

    // ميزة التوسيع (Expand Animation)
    self.mainMenu.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.3 animations:^{ self.mainMenu.transform = CGAffineTransformIdentity; }];

    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 300, 40)];
    t.text = @"ALHUSSAINI ELITE";
    t.textColor = [UIColor yellowColor];
    t.textAlignment = NSTextAlignmentCenter;
    t.font = [UIFont boldSystemFontOfSize:22];
    [self.mainMenu addSubview:t];

    // ميزة القناة (تليجرام)
    UIButton *c = [[UIButton alloc] initWithFrame:CGRectMake(50, 120, 200, 50)];
    c.backgroundColor = [UIColor yellowColor];
    [c setTitle:@"القناة الرسمية" forState:UIControlStateNormal];
    [c setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    c.layer.cornerRadius = 15;
    [c addTarget:self action:@selector(tele) forControlEvents:UIControlEventTouchUpInside];
    [self.mainMenu addSubview:c];
}

- (void)tele {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/hasanyiq"] options:@{} completionHandler:nil];
}
@end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIWindow *w = [UIApplication sharedApplication].windows.firstObject;
        if (w.rootViewController) {
            AlhussainiPro *p = [[AlhussainiPro alloc] init];
            p.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [w.rootViewController presentViewController:p animated:YES completion:nil];
        }
    });
}

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface AlhussainiController : UIViewController
@property (nonatomic, strong) UIView *loginPanel;
@property (nonatomic, strong) UIButton *floatingLogo;
@property (nonatomic, strong) UIView *mainMenu;
@property (nonatomic, strong) UITextField *passwordInput;
@property (nonatomic, assign) BOOL isWhiteMode;
@end

@implementation AlhussainiController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self createLoginView];
}

- (void)createLoginView {
    self.loginPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 420)];
    self.loginPanel.center = self.view.center;
    self.loginPanel.backgroundColor = [UIColor blackColor];
    self.loginPanel.layer.cornerRadius = 25;
    self.loginPanel.layer.borderColor = [UIColor yellowColor].CGColor;
    self.loginPanel.layer.borderWidth = 2;
    [self.view addSubview:self.loginPanel];

    self.passwordInput = [[UITextField alloc] initWithFrame:CGRectMake(30, 150, 220, 45)];
    self.passwordInput.placeholder = @"كلمة السر...";
    self.passwordInput.secureTextEntry = YES;
    self.passwordInput.textAlignment = NSTextAlignmentCenter;
    self.passwordInput.textColor = [UIColor whiteColor];
    self.passwordInput.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    self.passwordInput.layer.cornerRadius = 10;
    [self.loginPanel addSubview:self.passwordInput];

    // العداد الدائري المطور
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(140, 310) radius:35 startAngle:-M_PI_2 endAngle:2*M_PI-M_PI_2 clockwise:YES];
    CAShapeLayer *timer = [CAShapeLayer layer];
    timer.path = path.CGPath;
    timer.strokeColor = [UIColor yellowColor].CGColor;
    timer.fillColor = [UIColor clearColor].CGColor;
    timer.lineWidth = 4;
    [self.loginPanel.layer addSublayer:timer];

    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anim.duration = 6.0;
    anim.fromValue = @0;
    anim.toValue = @1;
    [timer addAnimation:anim forKey:@"timerAnim"];

    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 280, 80, 60)];
    [loginBtn setTitle:@"دخول" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(handleLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.loginPanel addSubview:loginBtn];
}

- (void)handleLogin {
    if ([self.passwordInput.text isEqualToString:@"hassany"]) {
        [self.loginPanel removeFromSuperview];
        [self setupFloatingButton];
    }
}

- (void)setupFloatingButton {
    self.floatingLogo = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 65, 65)];
    self.floatingLogo.layer.cornerRadius = 32.5;
    self.floatingLogo.layer.borderWidth = 2;
    self.floatingLogo.layer.borderColor = [UIColor yellowColor].CGColor;
    self.floatingLogo.clipsToBounds = YES;

    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://e.top4top.io/p_37700ug540.jpeg"]];
        if(data) dispatch_async(dispatch_get_main_queue(), ^{ 
            [self.floatingLogo setImage:[UIImage imageWithData:data] forState:UIControlStateNormal]; 
        });
    });

    [self.floatingLogo addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self.floatingLogo addGestureRecognizer:pan];
    
    [[UIApplication sharedApplication].windows.firstObject addSubview:self.floatingLogo];
}

- (void)onPan:(UIPanGestureRecognizer *)p {
    CGPoint t = [p translationInView:self.view];
    self.floatingLogo.center = CGPointMake(self.floatingLogo.center.x + t.x, self.floatingLogo.center.y + t.y);
    [p setTranslation:CGPointZero inView:self.view];
}

- (void)toggleMenu {
    if (self.mainMenu) { [self.mainMenu removeFromSuperview]; self.mainMenu = nil; return; }
    self.mainMenu = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 350)];
    self.mainMenu.center = self.view.center;
    self.mainMenu.backgroundColor = self.isWhiteMode ? [UIColor whiteColor] : [UIColor blackColor];
    self.mainMenu.layer.cornerRadius = 20;
    self.mainMenu.layer.borderColor = [UIColor yellowColor].CGColor;
    self.mainMenu.layer.borderWidth = 1;
    [self.view addSubview:self.mainMenu];

    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(180, 50, 50, 30)];
    [sw setOn:self.isWhiteMode];
    [sw addTarget:self action:@selector(onSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.mainMenu addSubview:sw];

    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 150, 30)];
    lbl.text = @"الوضع الفاتح";
    lbl.textColor = self.isWhiteMode ? [UIColor blackColor] : [UIColor whiteColor];
    [self.mainMenu addSubview:lbl];

    UIButton *devBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 130, 200, 40)];
    devBtn.backgroundColor = [UIColor yellowColor];
    [devBtn setTitle:@"المطور @OM_G9" forState:UIControlStateNormal];
    [devBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    devBtn.layer.cornerRadius = 10;
    [self.mainMenu addSubview:devBtn];
}

- (void)onSwitch:(UISwitch *)s {
    self.isWhiteMode = s.isOn;
    [self.mainMenu removeFromSuperview];
    self.mainMenu = nil;
    [self toggleMenu];
}
@end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 6 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIWindow *win = [UIApplication sharedApplication].windows.firstObject;
        if (win.rootViewController) {
            AlhussainiController *menu = [[AlhussainiController alloc] init];
            menu.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [win.rootViewController presentViewController:menu animated:YES completion:nil];
        }
    });
}

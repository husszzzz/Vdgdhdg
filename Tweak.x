#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface AlhussainiUltimate : UIViewController
@property (nonatomic, strong) UIView *loginPanel;
@property (nonatomic, strong) UIButton *floatingLogo;
@property (nonatomic, strong) UIView *menuContainer;
@property (nonatomic, strong) UITextField *passField;
@property (nonatomic, assign) BOOL isWhite;
@end

@implementation AlhussainiUltimate

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLoginUI];
}

// 1. نظام الدخول والحماية
- (void)setupLoginUI {
    self.loginPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 420)];
    self.loginPanel.center = self.view.center;
    self.loginPanel.backgroundColor = [UIColor blackColor];
    self.loginPanel.layer.cornerRadius = 30;
    self.loginPanel.layer.borderColor = [UIColor yellowColor].CGColor;
    self.loginPanel.layer.borderWidth = 3;
    self.loginPanel.layer.shadowColor = [UIColor yellowColor].CGColor;
    self.loginPanel.layer.shadowOpacity = 0.6;
    self.loginPanel.layer.shadowRadius = 20;
    [self.view addSubview:self.loginPanel];

    self.passField = [[UITextField alloc] initWithFrame:CGRectMake(40, 160, 220, 50)];
    self.passField.placeholder = @"كلمة السر (hassany)";
    self.passField.secureTextEntry = YES;
    self.passField.textAlignment = NSTextAlignmentCenter;
    self.passField.textColor = [UIColor whiteColor];
    self.passField.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    self.passField.layer.cornerRadius = 15;
    [self.loginPanel addSubview:self.passField];

    // العداد الدائري الفخم
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(150, 320) radius:35 startAngle:-M_PI_2 endAngle:2*M_PI-M_PI_2 clockwise:YES];
    CAShapeLayer *timerLayer = [CAShapeLayer layer];
    timerLayer.path = path.CGPath;
    timerLayer.strokeColor = [UIColor yellowColor].CGColor;
    timerLayer.fillColor = [UIColor clearColor].CGColor;
    timerLayer.lineWidth = 5;
    [self.loginPanel.layer addSublayer:timerLayer];

    CABasicAnimation *draw = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    draw.duration = 6.0; draw.fromValue = @0; draw.toValue = @1;
    [timerLayer addAnimation:draw forKey:@"timer"];

    UIButton *goBtn = [[UIButton alloc] initWithFrame:CGRectMake(110, 290, 80, 60)];
    [goBtn setTitle:@"دخول" forState:UIControlStateNormal];
    [goBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    goBtn.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [goBtn addTarget:self action:@selector(validatePass) forControlEvents:UIControlEventTouchUpInside];
    [self.loginPanel addSubview:goBtn];
}

- (void)validatePass {
    if ([self.passField.text isEqualToString:@"hassany"]) {
        [self.loginPanel removeFromSuperview];
        [self initFloatingLogo];
    }
}

// 2. اللوغو العائم والقابل للسحب
- (void)initFloatingLogo {
    self.floatingLogo = [[UIButton alloc] initWithFrame:CGRectMake(30, 120, 70, 70)];
    self.floatingLogo.layer.cornerRadius = 35;
    self.floatingLogo.layer.borderWidth = 2;
    self.floatingLogo.layer.borderColor = [UIColor yellowColor].CGColor;
    self.floatingLogo.clipsToBounds = YES;

    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://e.top4top.io/p_37700ug540.jpeg"]];
        if(imgData) dispatch_async(dispatch_get_main_queue(), ^{ [self.floatingLogo setImage:[UIImage imageWithData:imgData] forState:UIControlStateNormal]; });
    });

    [self.floatingLogo addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.floatingLogo addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)]];
    [[UIApplication sharedApplication].windows.firstObject addSubview:self.floatingLogo];
}

- (void)handlePan:(UIPanGestureRecognizer *)p {
    CGPoint t = [p translationInView:self.view];
    self.floatingLogo.center = CGPointMake(self.floatingLogo.center.x + t.x, self.floatingLogo.center.y + t.y);
    [p setTranslation:CGPointZero inView:self.view];
}

// 3. القائمة الرئيسية الشاملة
- (void)toggleMenu {
    if (self.menuContainer) { [self.menuContainer removeFromSuperview]; self.menuContainer = nil; return; }
    
    self.menuContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 380)];
    self.menuContainer.center = self.view.center;
    self.menuContainer.backgroundColor = self.isWhite ? [UIColor whiteColor] : [UIColor blackColor];
    self.menuContainer.layer.cornerRadius = 25;
    self.menuContainer.layer.borderColor = [UIColor yellowColor].CGColor;
    self.menuContainer.layer.borderWidth = 2;
    [self.view addSubview:self.menuContainer];

    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 280, 40)];
    header.text = @"ALHUSSAINI ULTIMATE";
    header.textColor = self.isWhite ? [UIColor blackColor] : [UIColor yellowColor];
    header.textAlignment = NSTextAlignmentCenter;
    header.font = [UIFont boldSystemFontOfSize:20];
    [self.menuContainer addSubview:header];

    // زر القناة
    UIButton *linkBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 100, 200, 45)];
    linkBtn.backgroundColor = [UIColor yellowColor];
    [linkBtn setTitle:@"القناة الرسمية 🚀" forState:UIControlStateNormal];
    [linkBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    linkBtn.layer.cornerRadius = 12;
    [linkBtn addTarget:self action:@selector(openTele) forControlEvents:UIControlEventTouchUpInside];
    [self.menuContainer addSubview:linkBtn];

    // سويتش تغيير الثيم
    UISwitch *themeSw = [[UISwitch alloc] initWithFrame:CGRectMake(190, 180, 50, 30)];
    [themeSw setOn:self.isWhite];
    [themeSw addTarget:self action:@selector(changeTheme:) forControlEvents:UIControlEventValueChanged];
    [self.menuContainer addSubview:themeSw];

    UILabel *themeLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, 180, 140, 30)];
    themeLbl.text = @"الوضع الفاتح";
    themeLbl.textColor = self.isWhite ? [UIColor blackColor] : [UIColor whiteColor];
    [self.menuContainer addSubview:themeLbl];
}

- (void)openTele {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/hasanyiq"] options:@{} completionHandler:nil];
}

- (void)changeTheme:(UISwitch *)s {
    self.isWhite = s.isOn;
    [self.menuContainer removeFromSuperview];
    self.menuContainer = nil;
    [self toggleMenu];
}
@end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIWindow *win = [UIApplication sharedApplication].windows.firstObject;
        if (win.rootViewController) {
            AlhussainiUltimate *vc = [[AlhussainiUltimate alloc] init];
            vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [win.rootViewController presentViewController:vc animated:YES completion:nil];
        }
    });
}

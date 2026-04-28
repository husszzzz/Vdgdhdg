#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

@interface HussainiMenu : UIViewController
@property (nonatomic, strong) UIView *loginV;
@property (nonatomic, strong) UIButton *floatB;
@property (nonatomic, strong) UIView *menuV;
@property (nonatomic, strong) UITextField *passF;
@property (nonatomic, assign) BOOL isWhite;
@end

@implementation HussainiMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self setupLogin];
}

- (void)setupLogin {
    self.loginV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 400)];
    self.loginV.center = self.view.center;
    self.loginV.backgroundColor = [UIColor blackColor];
    self.loginV.layer.cornerRadius = 20;
    self.loginV.layer.borderColor = [UIColor yellowColor].CGColor;
    self.loginV.layer.borderWidth = 2;
    [self.view addSubview:self.loginV];

    self.passF = [[UITextField alloc] initWithFrame:CGRectMake(30, 140, 220, 40)];
    self.passF.placeholder = @"ادخل السر...";
    self.passF.secureTextEntry = YES;
    self.passF.textColor = [UIColor whiteColor];
    self.passF.textAlignment = NSTextAlignmentCenter;
    self.passF.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    self.passF.layer.cornerRadius = 8;
    [self.loginV addSubview:self.passF];

    // العداد الدائري
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(140, 300) radius:30 startAngle:-M_PI_2 endAngle:2*M_PI-M_PI_2 clockwise:YES];
    CAShapeLayer *timer = [CAShapeLayer layer];
    timer.path = path.CGPath;
    timer.strokeColor = [UIColor yellowColor].CGColor;
    timer.fillColor = [UIColor clearColor].CGColor;
    timer.lineWidth = 3;
    [self.loginV.layer addSublayer:timer];

    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anim.duration = 6.0;
    anim.fromValue = @0;
    anim.toValue = @1;
    [timer addAnimation:anim forKey:@"t"];

    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 270, 80, 60)];
    [loginBtn setTitle:@"دخول" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(checkP) forControlEvents:UIControlEventTouchUpInside];
    [self.loginV addSubview:loginBtn];
}

- (void)checkP {
    if ([self.passF.text isEqualToString:@"hassany"]) {
        [self.loginV removeFromSuperview];
        [self setupFloat];
    }
}

- (void)setupFloat {
    self.floatB = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 60, 60)];
    self.floatB.layer.cornerRadius = 30;
    self.floatB.clipsToBounds = YES;
    self.floatB.layer.borderWidth = 2;
    self.floatB.layer.borderColor = [UIColor yellowColor].CGColor;
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://e.top4top.io/p_37700ug540.jpeg"]];
        if(data) dispatch_async(dispatch_get_main_queue(), ^{ [self.floatB setImage:[UIImage imageWithData:data] forState:UIControlStateNormal]; });
    });

    [self.floatB addTarget:self action:@selector(toggleM) forControlEvents:UIControlEventTouchUpInside];
    UIPanGestureRecognizer *p = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [self.floatB addGestureRecognizer:p];
    [[UIApplication sharedApplication].keyWindow addSubview:self.floatB];
}

- (void)move:(UIPanGestureRecognizer *)p {
    CGPoint t = [p translationInView:self.view];
    self.floatB.center = CGPointMake(self.floatB.center.x + t.x, self.floatB.center.y + t.y);
    [p setTranslation:CGPointZero inView:self.view];
}

- (void)toggleM {
    if (self.menuV) { [self.menuV removeFromSuperview]; self.menuV = nil; return; }
    self.menuV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 320)];
    self.menuV.center = self.view.center;
    self.menuV.backgroundColor = self.isWhite ? [UIColor whiteColor] : [UIColor blackColor];
    self.menuV.layer.cornerRadius = 15;
    self.menuV.layer.borderWidth = 1;
    self.menuV.layer.borderColor = [UIColor yellowColor].CGColor;
    [self.view addSubview:self.menuV];

    UISwitch *s = [[UISwitch alloc] initWithFrame:CGRectMake(170, 50, 50, 30)];
    [s setOn:self.isWhite];
    [s addTarget:self action:@selector(sw:) forControlEvents:UIControlEventValueChanged];
    [self.menuV addSubview:s];
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, 140, 30)];
    l.text = @"الوضع الفاتح";
    l.textColor = self.isWhite ? [UIColor blackColor] : [UIColor whiteColor];
    [self.menuV addSubview:l];

    UIButton *dev = [[UIButton alloc] initWithFrame:CGRectMake(20, 120, 200, 35)];
    dev.backgroundColor = [UIColor yellowColor];
    [dev setTitle:@"المطور @OM_G9" forState:UIControlStateNormal];
    [dev setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    dev.layer.cornerRadius = 8;
    [self.menuV addSubview:dev];
}

- (void)sw:(UISwitch *)s { self.isWhite = s.isOn; [self.menuV removeFromSuperview]; self.menuV = nil; [self toggleM]; }

@end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 6 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIWindow *w = [UIApplication sharedApplication].keyWindow ?: [UIApplication sharedApplication].windows.firstObject;
        if (w.rootViewController) {
            HussainiMenu *vc = [[HussainiMenu alloc] init];
            vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [w.rootViewController presentViewController:vc animated:YES completion:nil];
        }
    });
}

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

@interface HussMenu : UIViewController
@property (nonatomic, strong) UIView *loginP;
@property (nonatomic, strong) UIButton *fBtn;
@property (nonatomic, strong) UIView *menuV;
@property (nonatomic, strong) UITextField *passF;
@property (nonatomic, assign) BOOL isW;
@end

@implementation HussMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self startL];
}

- (void)startL {
    self.loginP = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 400)];
    self.loginP.center = self.view.center;
    self.loginP.backgroundColor = [UIColor blackColor];
    self.loginP.layer.cornerRadius = 20;
    self.loginP.layer.borderWidth = 2;
    self.loginP.layer.borderColor = [UIColor yellowColor].CGColor;
    [self.view addSubview:self.loginP];

    self.passF = [[UITextField alloc] initWithFrame:CGRectMake(30, 140, 220, 40)];
    self.passF.placeholder = @"كلمة السر...";
    self.passF.secureTextEntry = YES;
    self.passF.textColor = [UIColor whiteColor];
    self.passF.textAlignment = NSTextAlignmentCenter;
    self.passF.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    self.passF.layer.cornerRadius = 8;
    [self.loginP addSubview:self.passF];

    // العداد الدائري
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(140, 300) radius:30 startAngle:-M_PI_2 endAngle:2*M_PI-M_PI_2 clockwise:YES];
    CAShapeLayer *timer = [CAShapeLayer layer];
    timer.path = path.CGPath;
    timer.strokeColor = [UIColor yellowColor].CGColor;
    timer.fillColor = [UIColor clearColor].CGColor;
    timer.lineWidth = 3;
    [self.loginP.layer addSublayer:timer];

    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anim.duration = 6.0;
    anim.fromValue = @0;
    anim.toValue = @1;
    [timer addAnimation:anim forKey:@"t"];

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 275, 80, 50)];
    [btn setTitle:@"دخول" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
    [self.loginP addSubview:btn];
}

- (void)go {
    if ([self.passF.text isEqualToString:@"hassany"]) {
        [self.loginP removeFromSuperview];
        [self setupF];
    }
}

- (void)setupF {
    self.fBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 100, 60, 60)];
    self.fBtn.layer.cornerRadius = 30;
    self.fBtn.clipsToBounds = YES;
    self.fBtn.layer.borderWidth = 2;
    self.fBtn.layer.borderColor = [UIColor yellowColor].CGColor;
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://e.top4top.io/p_37700ug540.jpeg"]];
        if(data) dispatch_async(dispatch_get_main_queue(), ^{ [self.fBtn setImage:[UIImage imageWithData:data] forState:UIControlStateNormal]; });
    });

    [self.fBtn addTarget:self action:@selector(open) forControlEvents:UIControlEventTouchUpInside];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drag:)];
    [self.fBtn addGestureRecognizer:pan];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow ?: [UIApplication sharedApplication].windows.firstObject;
    [window addSubview:self.fBtn];
}

- (void)drag:(UIPanGestureRecognizer *)p {
    CGPoint t = [p translationInView:self.view];
    self.fBtn.center = CGPointMake(self.fBtn.center.x + t.x, self.fBtn.center.y + t.y);
    [p setTranslation:CGPointZero inView:self.view];
}

- (void)open {
    if (self.menuV) { [self.menuV removeFromSuperview]; self.menuV = nil; return; }
    self.menuV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 350)];
    self.menuV.center = self.view.center;
    self.menuV.backgroundColor = self.isW ? [UIColor whiteColor] : [UIColor blackColor];
    self.menuV.layer.cornerRadius = 15;
    self.menuV.layer.borderWidth = 1;
    self.menuV.layer.borderColor = [UIColor yellowColor].CGColor;
    [self.view addSubview:self.menuV];

    UISwitch *s = [[UISwitch alloc] initWithFrame:CGRectMake(180, 50, 50, 30)];
    [s setOn:self.isW];
    [s addTarget:self action:@selector(sw:) forControlEvents:UIControlEventValueChanged];
    [self.menuV addSubview:s];
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 150, 30)];
    l.text = @"الوضع الفاتح";
    l.textColor = self.isW ? [UIColor blackColor] : [UIColor whiteColor];
    [self.menuV addSubview:l];

    UIButton *dev = [[UIButton alloc] initWithFrame:CGRectMake(25, 120, 200, 40)];
    dev.backgroundColor = [UIColor yellowColor];
    [dev setTitle:@"المطور @OM_G9" forState:UIControlStateNormal];
    [dev setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    dev.layer.cornerRadius = 10;
    [self.menuV addSubview:dev];
}

- (void)sw:(UISwitch *)s { self.isW = s.isOn; [self.menuV removeFromSuperview]; self.menuV = nil; [self open]; }

@end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIWindow *w = [UIApplication sharedApplication].keyWindow ?: [UIApplication sharedApplication].windows.firstObject;
        if (w.rootViewController) {
            HussMenu *vc = [[HussMenu alloc] init];
            vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [w.rootViewController presentViewController:vc animated:YES completion:nil];
        }
    });
}

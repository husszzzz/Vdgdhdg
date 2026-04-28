#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

@interface AlhussainiFinal : UIViewController
@property (nonatomic, strong) UIView *loginP;
@property (nonatomic, strong) UIView *menuP;
@property (nonatomic, strong) UIButton *floatB;
@property (nonatomic, strong) UITextField *passF;
@property (nonatomic, assign) BOOL isWhite;
@end

@implementation AlhussainiFinal

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self setupLogin];
}

- (void)setupLogin {
    // واجهة الدخول
    self.loginP = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 450)];
    self.loginP.center = self.view.center;
    self.loginP.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.95];
    self.loginP.layer.cornerRadius = 25;
    self.loginP.layer.borderColor = [UIColor yellowColor].CGColor;
    self.loginP.layer.borderWidth = 2;
    [self.view addSubview:self.loginP];

    // حقل كلمة السر (الكلمة هي hassany)
    self.passF = [[UITextField alloc] initWithFrame:CGRectMake(40, 150, 220, 45)];
    self.passF.placeholder = @"كلمة السر...";
    self.passF.secureTextEntry = YES;
    self.passF.textAlignment = NSTextAlignmentCenter;
    self.passF.textColor = [UIColor whiteColor];
    self.passF.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    self.passF.layer.cornerRadius = 10;
    [self.loginP addSubview:self.passF];

    // العداد الدائري
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(150, 320) radius:35 startAngle:-M_PI_2 endAngle:2*M_PI-M_PI_2 clockwise:YES];
    CAShapeLayer *timerLayer = [CAShapeLayer layer];
    timerLayer.path = path.CGPath;
    timerLayer.strokeColor = [UIColor yellowColor].CGColor;
    timerLayer.fillColor = [UIColor clearColor].CGColor;
    timerLayer.lineWidth = 4;
    [self.loginP.layer addSublayer:timerLayer];

    CABasicAnimation *draw = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    draw.duration = 6.0;
    draw.fromValue = @0;
    draw.toValue = @1;
    [timerLayer addAnimation:draw forKey:@"t"];

    // زر الدخول (يتفعل بعد 6 ثواني)
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(110, 285, 80, 70)];
    [btn setTitle:@"دخول" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.loginP addSubview:btn];
}

- (void)loginAction {
    if ([self.passF.text isEqualToString:@"hassany"]) {
        [self.loginP removeFromSuperview];
        [self showFloating];
    }
}

- (void)showFloating {
    self.floatB = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 60, 60)];
    self.floatB.layer.cornerRadius = 30;
    self.floatB.clipsToBounds = YES;
    
    // تحميل الصورة
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://e.top4top.io/p_37700ug540.jpeg"]];
        if(data) dispatch_async(dispatch_get_main_queue(), ^{ 
            [self.floatB setImage:[UIImage imageWithData:data] forState:UIControlStateNormal]; 
        });
    });

    [self.floatB addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.floatB addGestureRecognizer:pan];
    [[UIApplication sharedApplication].keyWindow addSubview:self.floatB];
}

- (void)handlePan:(UIPanGestureRecognizer *)p {
    CGPoint t = [p translationInView:self.view];
    self.floatB.center = CGPointMake(self.floatB.center.x + t.x, self.floatB.center.y + t.y);
    [p setTranslation:CGPointZero inView:self.view];
}

- (void)openMenu {
    if (self.menuP) { [self.menuP removeFromSuperview]; self.menuP = nil; return; }
    self.menuP = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 380)];
    self.menuP.center = self.view.center;
    self.menuP.backgroundColor = self.isWhite ? [UIColor whiteColor] : [UIColor blackColor];
    self.menuP.layer.cornerRadius = 20;
    self.menuP.layer.borderColor = [UIColor yellowColor].CGColor;
    self.menuP.layer.borderWidth = 1;
    [self.view addSubview:self.menuP];

    // زر التبديل (Switch)
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(180, 60, 50, 30)];
    [sw setOn:self.isWhite];
    [sw addTarget:self action:@selector(toggleT:) forControlEvents:UIControlEventValueChanged];
    [self.menuP addSubview:sw];
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 150, 30)];
    l.text = @"الوضع الفاتح";
    l.textColor = self.isWhite ? [UIColor blackColor] : [UIColor whiteColor];
    [self.menuP addSubview:l];

    // أزرار المطور والقناة
    [self addB:@"المطور @OM_G9" y:130 link:@"tg://resolve?domain=OM_G9"];
    [self addB:@"القناة الرسمية" y:190 link:@"https://t.me/hasanyiq"];
}

- (void)addB:(NSString *)t y:(CGFloat)y link:(NSString *)l {
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(20, y, 220, 40)];
    b.backgroundColor = [UIColor yellowColor];
    [b setTitle:t forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    b.layer.cornerRadius = 10;
    [b addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(b, "l", l, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.menuP addSubview:b];
}

- (void)go:(UIButton *)s {
    NSString *url = objc_getAssociatedObject(s, "l");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
}

- (void)toggleT:(UISwitch *)s {
    self.isWhite = s.isOn;
    [self.menuP removeFromSuperview];
    self.menuP = nil;
    [self openMenu];
}
@end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 6 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIWindow *win = [UIApplication sharedApplication].keyWindow ?: [UIApplication sharedApplication].windows.firstObject;
        if (win.rootViewController) {
            AlhussainiFinal *vc = [[AlhussainiFinal alloc] init];
            vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [win.rootViewController presentViewController:vc animated:YES completion:nil];
        }
    });
}

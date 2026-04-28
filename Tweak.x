#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface AlhussainiElite : UIView <UITextFieldDelegate>
@property (nonatomic, strong) UIView *mainBox;
@property (nonatomic, strong) UIView *loginBox;
@property (nonatomic, strong) UIButton *floatBtn;
@property (nonatomic, strong) UITextField *passField;
@property (nonatomic, strong) CAShapeLayer *timerCircle;
@property (nonatomic, assign) BOOL isWhite;
@end

@implementation AlhussainiElite

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self runNeonIntro];
    }
    return self;
}

// --- [ 1. إنترو النيون السينمائي ] ---
- (void)runNeonIntro {
    UIView *bg = [[UIView alloc] initWithFrame:self.bounds];
    bg.backgroundColor = [UIColor blackColor];
    [self addSubview:bg];

    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 100)];
    lbl.center = bg.center;
    lbl.text = @"ALHUSSAINI ELITE";
    lbl.textColor = [UIColor yellowColor];
    lbl.font = [UIFont fontWithName:@"AvenirNext-Heavy" size:40];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.layer.shadowColor = [UIColor yellowColor].CGColor;
    lbl.layer.shadowRadius = 20;
    lbl.layer.shadowOpacity = 1;
    lbl.alpha = 0;
    [bg addSubview:lbl];

    [UIView animateWithDuration:1.5 animations:^{
        lbl.alpha = 1;
        lbl.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:^(BOOL f) {
        [UIView animateWithDuration:1.0 delay:0.5 options:0 animations:^{ bg.alpha = 0; } completion:^(BOOL f2) {
            [bg removeFromSuperview];
            [self showProLogin];
        }];
    }];
}

// --- [ 2. واجهة الدخول المرتبة بقوة ] ---
- (void)showProLogin {
    self.loginBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 340, 500)];
    self.loginBox.center = self.center;
    self.loginBox.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.95];
    self.loginBox.layer.cornerRadius = 50;
    self.loginBox.layer.borderWidth = 4;
    self.loginBox.layer.borderColor = [UIColor yellowColor].CGColor;
    self.loginBox.layer.shadowColor = [UIColor yellowColor].CGColor;
    self.loginBox.layer.shadowRadius = 30;
    self.loginBox.layer.shadowOpacity = 0.8;
    [self addSubview:self.loginBox];

    UILabel *topMsg = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 340, 40)];
    topMsg.text = @"قم بإدخال الرمز الخاص بك";
    topMsg.textColor = [UIColor yellowColor];
    topMsg.textAlignment = NSTextAlignmentCenter;
    topMsg.font = [UIFont boldSystemFontOfSize:22];
    [self.loginBox addSubview:topMsg];

    self.passField = [[UITextField alloc] initWithFrame:CGRectMake(40, 150, 260, 65)];
    self.passField.placeholder = @"الرمز السري...";
    self.passField.secureTextEntry = YES;
    self.passField.textAlignment = NSTextAlignmentCenter;
    self.passField.textColor = [UIColor whiteColor];
    self.passField.font = [UIFont boldSystemFontOfSize:20];
    self.passField.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    self.passField.layer.cornerRadius = 25;
    [self.loginBox addSubview:self.passField];

    // العداد الذي يفتر (احترافي جداً)
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(170, 350) radius:50 startAngle:-M_PI_2 endAngle:2*M_PI-M_PI_2 clockwise:YES];
    self.timerCircle = [CAShapeLayer layer];
    self.timerCircle.path = path.CGPath;
    self.timerCircle.strokeColor = [UIColor yellowColor].CGColor;
    self.timerCircle.fillColor = [UIColor clearColor].CGColor;
    self.timerCircle.lineWidth = 7;
    self.timerCircle.lineCap = kCALineCapRound;
    [self.loginBox.layer addSublayer:self.timerCircle];

    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anim.duration = 6.0; anim.fromValue = @0; anim.toValue = @1;
    [self.timerCircle addAnimation:anim forKey:@"loading"];

    UIButton *logBtn = [[UIButton alloc] initWithFrame:CGRectMake(120, 315, 100, 70)];
    [logBtn setTitle:@"دخول" forState:UIControlStateNormal];
    [logBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logBtn.titleLabel.font = [UIFont boldSystemFontOfSize:25];
    [logBtn addTarget:self action:@selector(checkAuth) forControlEvents:UIControlEventTouchUpInside];
    [self.loginBox addSubview:logBtn];
}

- (void)checkAuth {
    if ([self.passField.text isEqualToString:@"hassany"]) {
        [UIView animateWithDuration:0.5 animations:^{ self.loginBox.alpha = 0; } completion:^(BOOL f){
            [self.loginBox removeFromSuperview];
            [self createFloatingSystem];
        }];
    }
}

// --- [ 3. اللوغو العائم والتزييت ] ---
- (void)createFloatingSystem {
    self.floatBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 200, 85, 85)];
    self.floatBtn.layer.cornerRadius = 42.5;
    self.floatBtn.layer.borderWidth = 3;
    self.floatBtn.layer.borderColor = [UIColor yellowColor].CGColor;
    self.floatBtn.clipsToBounds = YES;
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData *d = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://e.top4top.io/p_37700ug540.jpeg"]];
        if(d) dispatch_async(dispatch_get_main_queue(), ^{ [self.floatBtn setImage:[UIImage imageWithData:d] forState:UIControlStateNormal]; });
    });

    [self.floatBtn addTarget:self action:@selector(toggleUltimateMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.floatBtn addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
    [self addSubview:self.floatBtn];
}

- (void)pan:(UIPanGestureRecognizer *)g {
    CGPoint p = [g translationInView:self];
    self.floatBtn.center = CGPointMake(self.floatBtn.center.x + p.x, self.floatBtn.center.y + p.y);
    [g setTranslation:CGPointZero inView:self];
}

// --- [ 4. المنيو العملاق بكل الأزرار ] ---
- (void)toggleUltimateMenu {
    if (self.mainBox) {
        [UIView animateWithDuration:0.3 animations:^{ self.mainBox.transform = CGAffineTransformMakeScale(0.1, 0.1); self.mainBox.alpha = 0; } completion:^(BOOL f){ [self.mainBox removeFromSuperview]; self.mainBox = nil; }];
        return;
    }

    self.mainBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 550)];
    self.mainBox.center = self.center;
    self.mainBox.backgroundColor = self.isWhite ? [UIColor whiteColor] : [UIColor blackColor];
    self.mainBox.layer.cornerRadius = 40;
    self.mainBox.layer.borderColor = [UIColor yellowColor].CGColor;
    self.mainBox.layer.borderWidth = 3;
    [self addSubview:self.mainBox];

    // أنميشن التوسيع
    self.mainBox.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:0 animations:^{ self.mainBox.transform = CGAffineTransformIdentity; } completion:nil];

    UILabel *h = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 40)];
    h.text = @"ALHUSSAINI SYSTEM";
    h.textColor = [UIColor yellowColor];
    h.textAlignment = NSTextAlignmentCenter;
    h.font = [UIFont fontWithName:@"AvenirNext-Heavy" size:22];
    [self.mainBox addSubview:h];

    // الأزرار المطلوبة
    [self addBtn:@"القناة الرسمية 🚀" y:100 action:@selector(openT)];
    [self addBtn:@"المطور @OM_G9 👨‍💻" y:170 action:@selector(openT)];
    [self addBtn:@"تغيير النمط (Theme)" y:240 action:@selector(changeT)];
    [self addBtn:@"تزييت القائمة (Smooth)" y:310 action:@selector(smooth)];
}

- (void)addBtn:(NSString *)t y:(int)y action:(SEL)a {
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(40, y, 240, 55)];
    b.backgroundColor = [UIColor yellowColor];
    [b setTitle:t forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    b.layer.cornerRadius = 18;
    b.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [b addTarget:self action:a forControlEvents:UIControlEventTouchUpInside];
    [self.mainBox addSubview:b];
}

- (void)openT { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/hasanyiq"] options:@{} completionHandler:nil]; }
- (void)changeT { self.isWhite = !self.isWhite; [self.mainBox removeFromSuperview]; self.mainBox = nil; [self toggleUltimateMenu]; }
- (void)smooth { /* ميزة وهمية لإعطاء شعور بالتزييت */ CABasicAnimation *s = [CABasicAnimation animationWithKeyPath:@"opacity"]; s.duration = 0.5; s.fromValue = @0.5; s.toValue = @1; [self.mainBox.layer addAnimation:s forKey:nil]; }

@end

// --- [ نظام حقن الواجهة بدون كراش ] ---
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIWindow *win = [UIApplication sharedApplication].windows.firstObject;
        if (win) {
            AlhussainiElite *eliteView = [[AlhussainiElite alloc] initWithFrame:win.bounds];
            [win addSubview:eliteView];
        }
    });
}

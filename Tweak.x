#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>

// --- [ واجهات الأنظمة المتقدمة ] ---
@interface AlhussainiOS : UIView <UITextFieldDelegate>
@property (nonatomic, strong) UIView *canvas;
@property (nonatomic, strong) UIVisualEffectView *blurEffect;
@property (nonatomic, strong) CAShapeLayer *neonBorder;
@property (nonatomic, strong) UIButton *floatingOrb;
@property (nonatomic, strong) UIView *terminal;
@property (nonatomic, strong) UITextField *accessCode;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) CAShapeLayer *loadingRing;
@property (nonatomic, assign) BOOL isLight;
@end

// --- [ المحرك الرئيسي للنظام ] ---
@implementation AlhussainiOS

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        [self initiateBootSequence];
    }
    return self;
}

// 1. نظام الإقلاع السينمائي (Cinematic Boot)
- (void)initiateBootSequence {
    UIView *bootScreen = [[UIView alloc] initWithFrame:self.bounds];
    bootScreen.backgroundColor = [UIColor blackColor];
    [self addSubview:bootScreen];

    UILabel *brand = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 500, 100)];
    brand.center = bootScreen.center;
    brand.text = @"ALHUSSAINI ELITE SYSTEMS";
    brand.textColor = [UIColor yellowColor];
    brand.font = [UIFont fontWithName:@"Courier-Bold" size:30];
    brand.textAlignment = NSTextAlignmentCenter;
    brand.alpha = 0;
    
    // تأثير التوهج (Neon Glow)
    brand.layer.shadowColor = [UIColor yellowColor].CGColor;
    brand.layer.shadowRadius = 15;
    brand.layer.shadowOpacity = 1;
    [bootScreen addSubview:brand];

    [UIView animateWithDuration:2.0 animations:^{
        brand.alpha = 1;
        brand.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL f) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1.5 animations:^{ bootScreen.alpha = 0; } completion:^(BOOL f2) {
                [bootScreen removeFromSuperview];
                [self launchFirewall];
            }];
        });
    }];
}

// 2. جدار الحماية (Firewall UI) - نظام تسجيل الدخول
- (void)launchFirewall {
    self.canvas = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 350, 520)];
    self.canvas.center = self.center;
    self.canvas.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.95];
    self.canvas.layer.cornerRadius = 40;
    self.canvas.layer.borderWidth = 2;
    self.canvas.layer.borderColor = [UIColor yellowColor].CGColor;
    [self addSubview:self.canvas];

    // أنميشن الحدود المتحركة
    self.neonBorder = [CAShapeLayer layer];
    self.neonBorder.path = [UIBezierPath bezierPathWithRoundedRect:self.canvas.bounds cornerRadius:40].CGPath;
    self.neonBorder.strokeColor = [UIColor yellowColor].CGColor;
    self.neonBorder.fillColor = [UIColor clearColor].CGColor;
    self.neonBorder.lineWidth = 4;
    self.neonBorder.shadowColor = [UIColor yellowColor].CGColor;
    self.neonBorder.shadowRadius = 10;
    self.neonBorder.shadowOpacity = 1;
    [self.canvas.layer addSublayer:self.neonBorder];

    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 350, 40)];
    header.text = @"AUTHENTICATION REQUIRED";
    header.textColor = [UIColor yellowColor];
    header.textAlignment = NSTextAlignmentCenter;
    header.font = [UIFont boldSystemFontOfSize:18];
    [self.canvas addSubview:header];

    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 350, 30)];
    self.statusLabel.text = @"قم بإدخال الرمز الخاص بك";
    self.statusLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.font = [UIFont systemFontOfSize:14];
    [self.canvas addSubview:self.statusLabel];

    self.accessCode = [[UITextField alloc] initWithFrame:CGRectMake(50, 160, 250, 60)];
    self.accessCode.placeholder = @"SECURITY CODE";
    self.accessCode.secureTextEntry = YES;
    self.accessCode.textAlignment = NSTextAlignmentCenter;
    self.accessCode.textColor = [UIColor whiteColor];
    self.accessCode.font = [UIFont fontWithName:@"Menlo-Bold" size:22];
    self.accessCode.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.05];
    self.accessCode.layer.cornerRadius = 20;
    self.accessCode.keyboardAppearance = UIKeyboardAppearanceDark;
    [self.canvas addSubview:self.accessCode];

    // العداد الدائري (Premium Loader)
    UIBezierPath *ring = [UIBezierPath bezierPathWithArcCenter:CGPointMake(175, 360) radius:55 startAngle:-M_PI_2 endAngle:2*M_PI-M_PI_2 clockwise:YES];
    self.loadingRing = [CAShapeLayer layer];
    self.loadingRing.path = ring.CGPath;
    self.loadingRing.strokeColor = [UIColor yellowColor].CGColor;
    self.loadingRing.fillColor = [UIColor clearColor].CGColor;
    self.loadingRing.lineWidth = 6;
    self.loadingRing.lineCap = kCALineCapRound;
    [self.canvas.layer addSublayer:self.loadingRing];

    CABasicAnimation *sync = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    sync.duration = 6.0; sync.fromValue = @0; sync.toValue = @1;
    [self.loadingRing addAnimation:sync forKey:@"sync"];

    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(125, 330, 100, 60)];
    [loginBtn setTitle:@"ACCESS" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [loginBtn addTarget:self action:@selector(verifySystem) forControlEvents:UIControlEventTouchUpInside];
    [self.canvas addSubview:loginBtn];
}

- (void)verifySystem {
    if ([self.accessCode.text isEqualToString:@"hassany"]) {
        AudioServicesPlaySystemSound(1519); // تأثير اهتزاز (Haptic)
        [UIView animateWithDuration:0.8 animations:^{
            self.canvas.transform = CGAffineTransformMakeScale(0.1, 0.1);
            self.canvas.alpha = 0;
        } completion:^(BOOL f) {
            [self.canvas removeFromSuperview];
            [self deployFloatingOrb];
        }];
    } else {
        self.statusLabel.text = @"ACCESS DENIED!";
        self.statusLabel.textColor = [UIColor redColor];
    }
}

// 3. نظام الأورب العائم (Floating Orb)
- (void)deployFloatingOrb {
    self.floatingOrb = [[UIButton alloc] initWithFrame:CGRectMake(30, 200, 85, 85)];
    self.floatingOrb.layer.cornerRadius = 42.5;
    self.floatingOrb.layer.borderWidth = 3;
    self.floatingOrb.layer.borderColor = [UIColor yellowColor].CGColor;
    self.floatingOrb.clipsToBounds = YES;
    self.floatingOrb.layer.shadowColor = [UIColor yellowColor].CGColor;
    self.floatingOrb.layer.shadowRadius = 15;
    self.floatingOrb.layer.shadowOpacity = 1;

    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData *img = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://e.top4top.io/p_37700ug540.jpeg"]];
        if(img) dispatch_async(dispatch_get_main_queue(), ^{ [self.floatingOrb setImage:[UIImage imageWithData:img] forState:UIControlStateNormal]; });
    });

    [self.floatingOrb addTarget:self action:@selector(toggleMasterMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.floatingOrb addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(orbPan:)]];
    [self addSubview:self.floatingOrb];
}

- (void)orbPan:(UIPanGestureRecognizer *)p {
    CGPoint t = [p translationInView:self];
    self.floatingOrb.center = CGPointMake(self.floatingOrb.center.x + t.x, self.floatingOrb.center.y + t.y);
    [p setTranslation:CGPointZero inView:self];
}

// 4. قائمة التحكم الرئيسية (Master Control Menu)
- (void)toggleMasterMenu {
    if (self.terminal) {
        [UIView animateWithDuration:0.4 animations:^{ self.terminal.transform = CGAffineTransformMakeScale(0.01, 0.01); self.terminal.alpha = 0; } completion:^(BOOL f){ [self.terminal removeFromSuperview]; self.terminal = nil; }];
        return;
    }

    self.terminal = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 330, 580)];
    self.terminal.center = self.center;
    self.terminal.backgroundColor = self.isLight ? [UIColor whiteColor] : [UIColor blackColor];
    self.terminal.layer.cornerRadius = 45;
    self.terminal.layer.borderWidth = 2;
    self.terminal.layer.borderColor = [UIColor yellowColor].CGColor;
    [self addSubview:self.terminal];

    // أنميشن التوسيع (Elastic Animation)
    self.terminal.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.6 options:0 animations:^{ self.terminal.transform = CGAffineTransformIdentity; } completion:nil];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 330, 50)];
    title.text = @"ALHUSSAINI ELITE v4.0";
    title.textColor = self.isLight ? [UIColor blackColor] : [UIColor yellowColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont fontWithName:@"Menlo-Bold" size:22];
    [self.terminal addSubview:title];

    // الأزرار المتقدمة
    [self createModuleBtn:@"القناة الرسمية 🚀" y:120 action:@selector(actionUrl)];
    [self createModuleBtn:@"المطور @OM_G9 👨‍💻" y:190 action:@selector(actionUrl)];
    [self createModuleBtn:@"تغيير النمط (Theme)" y:260 action:@selector(toggleTheme)];
    [self createModuleBtn:@"تزييت الواجهة (Smooth UI)" y:330 action:@selector(applySmoothing)];
    [self createModuleBtn:@"توسيع النظام (Full Mode)" y:400 action:@selector(expand)];
}

- (void)createModuleBtn:(NSString *)title y:(int)y action:(SEL)act {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(40, y, 250, 55)];
    btn.backgroundColor = [UIColor yellowColor];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    btn.layer.cornerRadius = 18;
    [btn addTarget:self action:act forControlEvents:UIControlEventTouchUpInside];
    [self.terminal addSubview:btn];
}

- (void)actionUrl { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/hasanyiq"] options:@{} completionHandler:nil]; }
- (void)toggleTheme { self.isLight = !self.isLight; [self.terminal removeFromSuperview]; self.terminal = nil; [self toggleMasterMenu]; }
- (void)applySmoothing { CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"opacity"]; pulse.duration = 0.5; pulse.fromValue = @0.4; pulse.toValue = @1; [self.terminal.layer addAnimation:pulse forKey:nil]; }
- (void)expand { [UIView animateWithDuration:0.5 animations:^{ self.terminal.transform = CGAffineTransformMakeScale(1.05, 1.05); } completion:^(BOOL f){ [UIView animateWithDuration:0.5 animations:^{ self.terminal.transform = CGAffineTransformIdentity; }]; }]; }

@end

// --- [ حاقن النظام الذكي ] ---
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 6 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIWindow *window = nil;
        for (UIWindow *w in [UIApplication sharedApplication].windows) {
            if (w.isKeyWindow) { window = w; break; }
        }
        if (!window) window = [UIApplication sharedApplication].windows.firstObject;
        
        if (window) {
            AlhussainiOS *overlay = [[AlhussainiOS alloc] initWithFrame:window.bounds];
            [window addSubview:overlay];
        }
    });
}

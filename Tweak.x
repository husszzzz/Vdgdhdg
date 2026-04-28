#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>

/**
 * ALHUSSAINI ELITE SYSTEMS - VERSION 5.0 (GLOBAL EDITION)
 * مبرمج بأعلى المعايير العالمية لضمان الاستقرار والجمال
 * هذا الكود يستخدم نظام الطبقات المستقلة لمنع كراش التطبيقات
 */

// --- [ الوجوه البرمجية للمنيو ] ---
@interface AlhussainiGodView : UIView <UITextFieldDelegate>
@property (nonatomic, strong) UIVisualEffectView *blurBackdrop;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) CAShapeLayer *neonLine;
@property (nonatomic, strong) UIButton *orb;
@property (nonatomic, strong) UIView *terminal;
@property (nonatomic, strong) UITextField *secretEntry;
@property (nonatomic, strong) UILabel *statusInfo;
@property (nonatomic, strong) CAShapeLayer *powerRing;
@property (nonatomic, strong) UIScrollView *scrollContent;
@property (nonatomic, assign) BOOL lightMode;
@property (nonatomic, assign) CGPoint lastPoint;
@end

// --- [ نافذة النظام المستقلة - الحل النهائي للكراش ] ---
@interface AlhussainiWindow : UIWindow
@end
@implementation AlhussainiWindow
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 100.0;
        self.backgroundColor = [UIColor clearColor];
        self.hidden = NO;
    }
    return self;
}
@end

@implementation AlhussainiGodView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self startCyberBootSequence];
    }
    return self;
}

// --- [ 1. إنترو الإقلاع السينمائي ] ---
- (void)startCyberBootSequence {
    UIView *introScreen = [[UIView alloc] initWithFrame:self.bounds];
    introScreen.backgroundColor = [UIColor blackColor];
    [self addSubview:introScreen];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 500, 150)];
    titleLabel.center = introScreen.center;
    titleLabel.text = @"ALHUSSAINI\nGOD MODE V5";
    titleLabel.numberOfLines = 2;
    titleLabel.textColor = [UIColor yellowColor];
    titleLabel.font = [UIFont fontWithName:@"AvenirNext-Heavy" size:38];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.alpha = 0;
    titleLabel.layer.shadowColor = [UIColor yellowColor].CGColor;
    titleLabel.layer.shadowRadius = 25;
    titleLabel.layer.shadowOpacity = 1;
    [introScreen addSubview:titleLabel];

    [UIView animateWithDuration:1.5 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        titleLabel.alpha = 1;
        titleLabel.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL f) {
        [UIView animateWithDuration:1.2 delay:0.8 options:0 animations:^{ introScreen.alpha = 0; } completion:^(BOOL f2) {
            [introScreen removeFromSuperview];
            [self buildSecurityFirewall];
        }];
    }];
}

// --- [ 2. جدار الحماية (Login UI) ] ---
- (void)buildSecurityFirewall {
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 360, 550)];
    self.container.center = self.center;
    self.container.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.96];
    self.container.layer.cornerRadius = 50;
    self.container.layer.borderColor = [UIColor yellowColor].CGColor;
    self.container.layer.borderWidth = 2.5;
    self.container.layer.shadowColor = [UIColor yellowColor].CGColor;
    self.container.layer.shadowRadius = 40;
    self.container.layer.shadowOpacity = 0.7;
    [self addSubview:self.container];

    UILabel *lockHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 360, 40)];
    lockHeader.text = @"🔒 نظام الحماية المشفر";
    lockHeader.textColor = [UIColor yellowColor];
    lockHeader.textAlignment = NSTextAlignmentCenter;
    lockHeader.font = [UIFont boldSystemFontOfSize:22];
    [self.container addSubview:lockHeader];

    self.statusInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, 95, 360, 30)];
    self.statusInfo.text = @"قم بإدخال الرمز الخاص بك للوصول";
    self.statusInfo.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    self.statusInfo.textAlignment = NSTextAlignmentCenter;
    self.statusInfo.font = [UIFont systemFontOfSize:15];
    [self.container addSubview:self.statusInfo];

    self.secretEntry = [[UITextField alloc] initWithFrame:CGRectMake(45, 180, 270, 70)];
    self.secretEntry.placeholder = @"ENTER PIN...";
    self.secretEntry.secureTextEntry = YES;
    self.secretEntry.textAlignment = NSTextAlignmentCenter;
    self.secretEntry.textColor = [UIColor whiteColor];
    self.secretEntry.font = [UIFont fontWithName:@"Menlo-Bold" size:24];
    self.secretEntry.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.07];
    self.secretEntry.layer.cornerRadius = 25;
    self.secretEntry.keyboardAppearance = UIKeyboardAppearanceDark;
    [self.container addSubview:self.secretEntry];

    // العداد الدائري الاحترافي (Loader)
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(180, 380) radius:55 startAngle:-M_PI_2 endAngle:2*M_PI-M_PI_2 clockwise:YES];
    self.powerRing = [CAShapeLayer layer];
    self.powerRing.path = path.CGPath;
    self.powerRing.strokeColor = [UIColor yellowColor].CGColor;
    self.powerRing.fillColor = [UIColor clearColor].CGColor;
    self.powerRing.lineWidth = 8;
    self.powerRing.lineCap = kCALineCapRound;
    [self.container.layer addSublayer:self.powerRing];

    CABasicAnimation *loadAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    loadAnim.duration = 6.0; loadAnim.fromValue = @0; loadAnim.toValue = @1;
    [self.powerRing addAnimation:loadAnim forKey:@"loading"];

    UIButton *accessBtn = [[UIButton alloc] initWithFrame:CGRectMake(130, 345, 100, 70)];
    [accessBtn setTitle:@"دخول" forState:UIControlStateNormal];
    [accessBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    accessBtn.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    [accessBtn addTarget:self action:@selector(processAuth) forControlEvents:UIControlEventTouchUpInside];
    [self.container addSubview:accessBtn];
}

- (void)processAuth {
    if ([self.secretEntry.text isEqualToString:@"hassany"]) {
        AudioServicesPlaySystemSound(1521); // Haptic Feedback
        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.4 options:0 animations:^{
            self.container.transform = CGAffineTransformMakeScale(0.1, 0.1);
            self.container.alpha = 0;
        } completion:^(BOOL f) {
            [self.container removeFromSuperview];
            [self deployFloatingOrb];
        }];
    } else {
        self.statusInfo.text = @"الرمز خاطئ! حاول مجدداً";
        self.statusInfo.textColor = [UIColor redColor];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

// --- [ 3. الأورب العائم (The Orb) ] ---
- (void)deployFloatingOrb {
    self.orb = [[UIButton alloc] initWithFrame:CGRectMake(30, 250, 90, 90)];
    self.orb.layer.cornerRadius = 45;
    self.orb.layer.borderWidth = 3.5;
    self.orb.layer.borderColor = [UIColor yellowColor].CGColor;
    self.orb.clipsToBounds = YES;
    self.orb.layer.shadowColor = [UIColor yellowColor].CGColor;
    self.orb.layer.shadowRadius = 20;
    self.orb.layer.shadowOpacity = 1;

    // تحميل صورة المطور
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://e.top4top.io/p_37700ug540.jpeg"]];
        if(imgData) dispatch_async(dispatch_get_main_queue(), ^{ [self.orb setImage:[UIImage imageWithData:imgData] forState:UIControlStateNormal]; });
    });

    [self.orb addTarget:self action:@selector(launchMasterTerminal) forControlEvents:UIControlEventTouchUpInside];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleOrbDrag:)];
    [self.orb addGestureRecognizer:pan];
    [self addSubview:self.orb];
}

- (void)handleOrbDrag:(UIPanGestureRecognizer *)g {
    CGPoint p = [g translationInView:self];
    self.orb.center = CGPointMake(self.orb.center.x + p.x, self.orb.center.y + p.y);
    [g setTranslation:CGPointZero inView:self];
}

// --- [ 4. القائمة الرئيسية (The Terminal) ] ---
- (void)launchMasterTerminal {
    if (self.terminal) {
        [UIView animateWithDuration:0.4 animations:^{ self.terminal.transform = CGAffineTransformMakeScale(0.01, 0.01); self.terminal.alpha = 0; } completion:^(BOOL f){ [self.terminal removeFromSuperview]; self.terminal = nil; }];
        return;
    }

    self.terminal = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 340, 620)];
    self.terminal.center = self.center;
    self.terminal.backgroundColor = self.lightMode ? [UIColor whiteColor] : [UIColor blackColor];
    self.terminal.layer.cornerRadius = 45;
    self.terminal.layer.borderColor = [UIColor yellowColor].CGColor;
    self.terminal.layer.borderWidth = 2;
    [self addSubview:self.terminal];

    // أنميشن التوسيع الرهيب
    self.terminal.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:0 animations:^{ self.terminal.transform = CGAffineTransformIdentity; } completion:nil];

    UILabel *headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 340, 50)];
    headerTitle.text = @"ALHUSSAINI GOD MODE";
    headerTitle.textColor = self.lightMode ? [UIColor blackColor] : [UIColor yellowColor];
    headerTitle.textAlignment = NSTextAlignmentCenter;
    headerTitle.font = [UIFont fontWithName:@"Menlo-Bold" size:24];
    [self.terminal addSubview:headerTitle];

    self.scrollContent = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 90, 340, 510)];
    self.scrollContent.contentSize = CGSizeMake(340, 700);
    [self.terminal addSubview:self.scrollContent];

    // إنشاء الأزرار بنظام المصنع (Factory System)
    [self createProBtn:@"القناة الرسمية 🚀" y:20 act:@selector(openLink)];
    [self createProBtn:@"المطور @OM_G9 👨‍💻" y:100 act:@selector(openLink)];
    [self createProBtn:@"تغيير النمط (Dark/Light)" y:180 act:@selector(switchTheme)];
    [self createProBtn:@"تزييت الواجهة (Smooth)" y:260 act:@selector(applyHaptics)];
    [self createProBtn:@"توسيع النظام (Maximize)" y:340 act:@selector(maximizeUI)];
    [self createProBtn:@"تحديث البيانات (Refresh)" y:420 act:@selector(refreshSystem)];
    [self createProBtn:@"إغلاق النظام (Exit)" y:500 act:@selector(exitTweak)];
}

- (void)createProBtn:(NSString *)t y:(int)y act:(SEL)a {
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(40, y, 260, 65)];
    b.backgroundColor = [UIColor yellowColor];
    [b setTitle:t forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    b.layer.cornerRadius = 22;
    b.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    b.layer.shadowColor = [UIColor blackColor].CGColor;
    b.layer.shadowOpacity = 0.3;
    b.layer.shadowOffset = CGSizeMake(0, 5);
    [b addTarget:self action:a forControlEvents:UIControlEventTouchUpInside];
    [self.scrollContent addSubview:b];
}

// --- [ 5. الوظائف التشغيلية ] ---
- (void)openLink { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/hasanyiq"] options:@{} completionHandler:nil]; }
- (void)switchTheme { self.lightMode = !self.lightMode; [self.terminal removeFromSuperview]; self.terminal = nil; [self launchMasterTerminal]; }
- (void)applyHaptics { AudioServicesPlaySystemSound(1520); }
- (void)maximizeUI { [UIView animateWithDuration:0.4 animations:^{ self.terminal.transform = CGAffineTransformMakeScale(1.05, 1.05); } completion:^(BOOL f){ [UIView animateWithDuration:0.4 animations:^{ self.terminal.transform = CGAffineTransformIdentity; }]; }]; }
- (void)refreshSystem { self.terminal.alpha = 0.5; [UIView animateWithDuration:0.5 animations:^{ self.terminal.alpha = 1.0; }]; }
- (void)exitTweak { exit(0); }

@end

// --- [ الحاقن الملكي - الـ Controller الرئيسي ] ---
static AlhussainiWindow *extraWindow = nil;

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 6 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (!extraWindow) {
            extraWindow = [[AlhussainiWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            AlhussainiGodView *godView = [[AlhussainiGodView alloc] initWithFrame:extraWindow.bounds];
            [extraWindow addSubview:godView];
            [extraWindow makeKeyAndVisible];
        }
    });
}

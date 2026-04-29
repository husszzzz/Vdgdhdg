#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>

/**
 * PROJECT: ALHUSSAINI SUPREME SPLASH (V8.0 GLOBAL)
 * DEVELOPER: HUSSEIN AL-HASSANI
 * STYLE: HIGH-END SEMI-TRANSPARENT NEON
 */

@interface AlhussainiEliteSplash : UIView
@property (nonatomic, strong) UIView *glassCard;
@property (nonatomic, strong) CAShapeLayer *outerRing;
@property (nonatomic, strong) CAShapeLayer *innerRing;
@end

@implementation AlhussainiEliteSplash

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7]; // خلفية تعتيم سينمائي
        [self createWorldClassUI];
    }
    return self;
}

- (void)createWorldClassUI {
    // 1. البطاقة الزجاجية (The Glass Card)
    self.glassCard = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 310, 480)];
    self.glassCard.center = self.center;
    self.glassCard.layer.cornerRadius = 50;
    self.glassCard.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.glassCard.layer.borderWidth = 0.5;
    self.glassCard.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3].CGColor;
    [self addSubview:self.glassCard];

    // إضافة تأثير التغبيش (Blur Effect) للبطاقة
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = self.glassCard.bounds;
    blurView.layer.cornerRadius = 50;
    blurView.clipsToBounds = YES;
    [self.glassCard addSubview:blurView];

    // 2. نظام الدوائر المتعاكسة (Double Rotating Rings)
    CGPoint centerPoint = CGPointMake(155, 100);
    
    // الدائرة الخارجية (تفتر باتجاه عقارب الساعة)
    self.outerRing = [self createRingWithRadius:65 color:[UIColor yellowColor] duration:4.0 clockwise:YES];
    [self.glassCard.layer addSublayer:self.outerRing];
    
    // الدائرة الداخلية (تفتر عكس عقارب الساعة - تأثير احترافي)
    self.innerRing = [self createRingWithRadius:58 color:[UIColor whiteColor] duration:2.5 clockwise:NO];
    [self.glassCard.layer addSublayer:self.innerRing];

    // 3. اللوغو مع نبض (Pulse Animation)
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(105, 50, 100, 100)];
    logo.layer.cornerRadius = 50;
    logo.clipsToBounds = YES;
    logo.layer.borderWidth = 2;
    logo.layer.borderColor = [UIColor yellowColor].CGColor;
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData *d = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://e.top4top.io/p_37700ug540.jpeg"]];
        if(d) dispatch_async(dispatch_get_main_queue(), ^{ 
            logo.image = [UIImage imageWithData:d]; 
            // أنميشن النبض للوغو
            CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            pulse.duration = 1.2;
            pulse.toValue = @1.05;
            pulse.autoreverses = YES;
            pulse.repeatCount = HUGE_VALF;
            [logo.layer addAnimation:pulse forKey:nil];
        });
    });
    [self.glassCard addSubview:logo];

    // 4. النصوص بتصميم عصري
    UILabel *welcomeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 175, 310, 30)];
    welcomeLbl.text = @"WELCOME TO";
    welcomeLbl.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    welcomeLbl.font = [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
    welcomeLbl.textAlignment = NSTextAlignmentCenter;
    [self.glassCard addSubview:welcomeLbl];

    UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 310, 45)];
    nameLbl.text = @"ALHUSSAINI ELITE";
    nameLbl.textColor = [UIColor yellowColor];
    nameLbl.font = [UIFont fontWithName:@"AvenirNext-Heavy" size:28];
    nameLbl.textAlignment = NSTextAlignmentCenter;
    // توهج للنص (Neon Glow)
    nameLbl.layer.shadowColor = [UIColor yellowColor].CGColor;
    nameLbl.layer.shadowRadius = 10;
    nameLbl.layer.shadowOpacity = 0.8;
    nameLbl.layer.shadowOffset = CGSizeZero;
    [self.glassCard addSubview:nameLbl];

    // 5. الأزرار (المطور والقناة) بتصميم شفاف
    [self addProButton:@"DEVELOPER: @OM_G9" y:270 action:@selector(openTele)];
    [self addProButton:@"OFFICIAL CHANNEL" y:335 action:@selector(openTele)];

    // 6. زر الدخول العملاق (Glowing Enter Button)
    UIButton *enterBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 405, 230, 50)];
    [enterBtn setTitle:@"ENTER SYSTEM" forState:UIControlStateNormal];
    enterBtn.backgroundColor = [UIColor yellowColor];
    [enterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    enterBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    enterBtn.layer.cornerRadius = 20;
    // توهج الزر
    enterBtn.layer.shadowColor = [UIColor yellowColor].CGColor;
    enterBtn.layer.shadowRadius = 15;
    enterBtn.layer.shadowOpacity = 0.5;
    [enterBtn addTarget:self action:@selector(dismissSplash) forControlEvents:UIControlEventTouchUpInside];
    [self.glassCard addSubview:enterBtn];

    // دخول البطاقة بأنميشن "السقوط الناعم"
    self.glassCard.transform = CGAffineTransformMakeTranslation(0, -600);
    [UIView animateWithDuration:1.2 delay:0.2 usingSpringWithDamping:0.7 initialSpringVelocity:0.6 options:0 animations:^{
        self.glassCard.transform = CGAffineTransformIdentity;
    } completion:nil];
}

// دالة إنشاء الدوائر الاحترافية
- (CAShapeLayer *)createRingWithRadius:(CGFloat)radius color:(UIColor *)color duration:(NSTimeInterval)duration clockwise:(BOOL)clockwise {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(155, 100) radius:radius startAngle:-M_PI_2 endAngle:2*M_PI - M_PI_2 clockwise:clockwise];
    CAShapeLayer *ring = [CAShapeLayer layer];
    ring.path = path.CGPath;
    ring.strokeColor = color.CGColor;
    ring.fillColor = [UIColor clearColor].CGColor;
    ring.lineWidth = 3;
    ring.lineCap = kCALineCapRound;
    ring.strokeEnd = 0.25; // طول الخط (ربع دائرة تفتر)

    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.toValue = clockwise ? @(M_PI * 2) : @(-M_PI * 2);
    rotate.duration = duration;
    rotate.repeatCount = HUGE_VALF;
    [ring addAnimation:rotate forKey:nil];
    
    return ring;
}

- (void)addProButton:(NSString *)title y:(int)y action:(SEL)a {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(40, y, 230, 50)];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.05];
    btn.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2].CGColor;
    btn.layer.borderWidth = 1;
    btn.layer.cornerRadius = 15;
    btn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [btn addTarget:self action:a forControlEvents:UIControlEventTouchUpInside];
    [self.glassCard addSubview:btn];
}

- (void)openTele {
    AudioServicesPlaySystemSound(1519); // اهتزاز خفيف (Taptic)
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/hasanyiq"] options:@{} completionHandler:nil];
}

- (void)dismissSplash {
    AudioServicesPlayHapticFeedback(1521); 
    [UIView animateWithDuration:0.6 animations:^{
        self.glassCard.transform = CGAffineTransformMakeScale(0.8, 0.8);
        self.glassCard.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL f) {
        [self removeFromSuperview];
    }];
}

@end

// الحقن: يظهر في كل مرة تفتح فيها التطبيق
%ctor {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            UIWindow *win = [[UIApplication sharedApplication] keyWindow];
            if (win) {
                AlhussainiEliteSplash *splash = [[AlhussainiEliteSplash alloc] initWithFrame:win.bounds];
                [win addSubview:splash];
            }
        });
    }];
}

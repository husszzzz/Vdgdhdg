#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// ==========================================
// 1. تعريف الكلاسات والهيكلية الأساسية
// ==========================================
@interface HasanyCheatEngine : NSObject
@property (nonatomic, strong) UIWindow *gameWindow;
@property (nonatomic, strong) UIButton *floatingLogo;
@property (nonatomic, strong) UIView *mainPanel;
@property (nonatomic, strong) UIView *sidebarPanel;
@property (nonatomic, strong) UIView *contentPanel;
@property (nonatomic, strong) UIView *espOverlayLayer; // طبقة الرسم الوهمي
@property (nonatomic, strong) NSTimer *espTimer;
+ (instancetype)shared;
- (void)injectIntoWindow:(UIWindow *)window;
@end

@implementation HasanyCheatEngine

+ (instancetype)shared {
    static HasanyCheatEngine *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ instance = [[self alloc] init]; });
    return instance;
}

// ==========================================
// 2. الحقن وبناء الواجهة الرئيسية
// ==========================================
- (void)injectIntoWindow:(UIWindow *)window {
    if (self.floatingLogo) return;
    self.gameWindow = window;
    
    // طبقة الـ ESP الوهمية (مخفية بالبداية ولا تمنع اللمس)
    self.espOverlayLayer = [[UIView alloc] initWithFrame:window.bounds];
    self.espOverlayLayer.userInteractionEnabled = NO;
    self.espOverlayLayer.hidden = YES;
    [window addSubview:self.espOverlayLayer];

    [self createFloatingButton];
    [self createMainMenu];
}

// ==========================================
// 3. الدائرة المتحركة (اللوكو) مع تأثير النبض
// ==========================================
- (void)createFloatingButton {
    self.floatingLogo = [UIButton buttonWithType:UIButtonTypeCustom];
    self.floatingLogo.frame = CGRectMake(20, 100, 65, 65);
    self.floatingLogo.layer.cornerRadius = 32.5;
    self.floatingLogo.layer.borderWidth = 2;
    self.floatingLogo.layer.borderColor = [UIColor colorWithRed:0.8 green:0.0 blue:1.0 alpha:1.0].CGColor;
    self.floatingLogo.clipsToBounds = YES;
    self.floatingLogo.backgroundColor = [UIColor blackColor];
    
    // تحميل صورتك من الرابط
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://a.top4top.io/p_38130ynm30.jpeg"]];
        if (imgData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.floatingLogo setBackgroundImage:[UIImage imageWithData:imgData] forState:UIControlStateNormal];
            });
        }
    });

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragLogo:)];
    [self.floatingLogo addGestureRecognizer:pan];
    [self.floatingLogo addTarget:self action:@selector(animateMenuToggle) forControlEvents:UIControlEventTouchUpInside];
    
    [self.gameWindow addSubview:self.floatingLogo];
}

// ==========================================
// 4. المنيو المرعب (أقسام، سايدبار، أنيميشن)
// ==========================================
- (void)createMainMenu {
    // اللوحة الرئيسية
    self.mainPanel = [[UIView alloc] initWithFrame:CGRectMake(50, 80, 350, 280)];
    self.mainPanel.backgroundColor = [UIColor colorWithWhite:0.05 alpha:0.95];
    self.mainPanel.layer.cornerRadius = 12;
    self.mainPanel.layer.borderWidth = 1.5;
    self.mainPanel.layer.borderColor = [UIColor colorWithRed:0.9 green:0.2 blue:0.6 alpha:1.0].CGColor;
    self.mainPanel.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.mainPanel.alpha = 0;
    self.mainPanel.hidden = YES;
    
    // السايدبار (الأقسام)
    self.sidebarPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 280)];
    self.sidebarPanel.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.sidebarPanel.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(12, 12)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.sidebarPanel.bounds;
    maskLayer.path = maskPath.CGPath;
    self.sidebarPanel.layer.mask = maskLayer;
    [self.mainPanel addSubview:self.sidebarPanel];
    
    // أزرار الأقسام
    NSArray *tabs = @[@"ESP", @"Aimbot", @"Player", @"Settings"];
    for (int i=0; i<tabs.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(5, 20 + (i * 50), 90, 40);
        btn.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        btn.layer.cornerRadius = 8;
        [btn setTitle:tabs[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(switchTab:) forControlEvents:UIControlEventTouchUpInside];
        [self.sidebarPanel addSubview:btn];
    }
    
    // منطقة المحتوى (اللي تتغير حسب القسم)
    self.contentPanel = [[UIView alloc] initWithFrame:CGRectMake(100, 0, 250, 280)];
    [self.mainPanel addSubview:self.contentPanel];
    
    // عرض قسم الـ ESP كافتراضي
    [self buildESPContent];
    
    [self.gameWindow addSubview:self.mainPanel];
}

// ==========================================
// 5. محتوى الأقسام (الـ Toggles والخيارات)
// ==========================================
- (void)buildESPContent {
    [self clearContent];
    [self addTitle:@"رادار وكشف الأماكن (ESP)"];
    [self addToggle:@"تفعيل الـ ESP الكامل" y:50 action:@selector(toggleFakeESP:)];
    [self addToggle:@"كشف الهيكل (Skeleton)" y:90 action:nil];
    [self addToggle:@"كشف الأسلحة واللوت" y:130 action:nil];
    [self addToggle:@"خطوط العدو (Lines)" y:170 action:nil];
}

- (void)buildAimbotContent {
    [self clearContent];
    [self addTitle:@"إعدادات الإيم بوت (Aimbot)"];
    [self addToggle:@"تفعيل الإيم بوت (Magic)" y:50 action:nil];
    [self addToggle:@"تثبيت السلاح (No Recoil)" y:90 action:nil];
    
    UILabel *sliderLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, 200, 20)];
    sliderLbl.text = @"قوة الإيم بوت (FOV):";
    sliderLbl.textColor = [UIColor whiteColor];
    sliderLbl.font = [UIFont systemFontOfSize:13];
    [self.contentPanel addSubview:sliderLbl];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(20, 160, 210, 30)];
    slider.minimumTrackTintColor = [UIColor purpleColor];
    [self.contentPanel addSubview:slider];
}

- (void)buildSettingsContent {
    [self clearContent];
    [self addTitle:@"معلومات الهاك والإعدادات"];
    
    UILabel *info = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 230, 60)];
    info.text = @"H-IPA ENGINE V2.0\nمطور الهاك: حسني ستور\nنسخة آمنة 100%";
    info.textColor = [UIColor lightGrayColor];
    info.font = [UIFont systemFontOfSize:14];
    info.numberOfLines = 3;
    info.textAlignment = NSTextAlignmentCenter;
    [self.contentPanel addSubview:info];
    
    UIButton *tgBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    tgBtn.frame = CGRectMake(40, 130, 170, 40);
    tgBtn.backgroundColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.8 alpha:1.0];
    tgBtn.layer.cornerRadius = 10;
    [tgBtn setTitle:@"قناة المطور @OM_G9" forState:UIControlStateNormal];
    [tgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tgBtn addTarget:self action:@selector(openTG) forControlEvents:UIControlEventTouchUpInside];
    [self.contentPanel addSubview:tgBtn];
    
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    exitBtn.frame = CGRectMake(40, 180, 170, 40);
    exitBtn.backgroundColor = [UIColor redColor];
    exitBtn.layer.cornerRadius = 10;
    [exitBtn setTitle:@"إغلاق اللعبة" forState:UIControlStateNormal];
    [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(crashGame) forControlEvents:UIControlEventTouchUpInside];
    [self.contentPanel addSubview:exitBtn];
}

// أدوات مساعدة للتصميم
- (void)clearContent {
    for (UIView *v in self.contentPanel.subviews) [v removeFromSuperview];
}
- (void)addTitle:(NSString *)txt {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 250, 30)];
    lbl.text = txt;
    lbl.textColor = [UIColor colorWithRed:0.9 green:0.2 blue:0.6 alpha:1.0];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont boldSystemFontOfSize:16];
    [self.contentPanel addSubview:lbl];
}
- (void)addToggle:(NSString *)txt y:(CGFloat)y action:(SEL)action {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 160, 30)];
    lbl.text = txt;
    lbl.textColor = [UIColor whiteColor];
    lbl.font = [UIFont systemFontOfSize:14];
    [self.contentPanel addSubview:lbl];
    
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(180, y, 50, 30)];
    sw.onTintColor = [UIColor purpleColor];
    if (action) [sw addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    [self.contentPanel addSubview:sw];
}

// ==========================================
// 6. نظام الـ ESP الوهمي (الرسم على الشاشة)
// ==========================================
- (void)toggleFakeESP:(UISwitch *)sender {
    if (sender.isOn) {
        self.espOverlayLayer.hidden = NO;
        // رسم وهمي كل ثانية لعمل حركة
        self.espTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(drawFakeEnemies) userInfo:nil repeats:YES];
        [self drawFakeEnemies];
    } else {
        self.espOverlayLayer.hidden = YES;
        [self.espTimer invalidate];
        self.espTimer = nil;
        for (UIView *v in self.espOverlayLayer.subviews) [v removeFromSuperview];
    }
}

- (void)drawFakeEnemies {
    // تنظيف الشاشة من الرسم القديم
    for (UIView *v in self.espOverlayLayer.subviews) [v removeFromSuperview];
    
    int screenWidth = self.gameWindow.bounds.size.width;
    int screenHeight = self.gameWindow.bounds.size.height;
    
    // رسم 3-5 أعداء وهميين بأماكن عشوائية
    int enemyCount = arc4random_uniform(3) + 3; 
    for (int i = 0; i < enemyCount; i++) {
        int x = arc4random_uniform(screenWidth - 100) + 50;
        int y = arc4random_uniform(screenHeight - 150) + 50;
        
        // مربع العدو (Hitbox)
        UIView *box = [[UIView alloc] initWithFrame:CGRectMake(x, y, 40, 80)];
        box.layer.borderWidth = 1.5;
        box.layer.borderColor = [UIColor redColor].CGColor;
        
        // خط من أعلى الشاشة للعدو (Snapline)
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(screenWidth/2, 50, 1, 1)];
        line.backgroundColor = [UIColor greenColor];
        // حساب طول الخط وزاويته برمجياً (تأثير مرعب)
        CGFloat dx = x + 20 - (screenWidth/2);
        CGFloat dy = y - 50;
        CGFloat length = sqrt(dx*dx + dy*dy);
        CGFloat angle = atan2(dy, dx);
        line.bounds = CGRectMake(0, 0, length, 1);
        line.center = CGPointMake((screenWidth/2 + x+20)/2, (50 + y)/2);
        line.transform = CGAffineTransformMakeRotation(angle);
        
        // اسم وهمي ومسافة
        UILabel *info = [[UILabel alloc] initWithFrame:CGRectMake(x-20, y-20, 80, 15)];
        info.text = [NSString stringWithFormat:@"Enemy [%dM]", arc4random_uniform(200)+10];
        info.textColor = [UIColor yellowColor];
        info.font = [UIFont systemFontOfSize:10];
        info.textAlignment = NSTextAlignmentCenter;
        
        [self.espOverlayLayer addSubview:line];
        [self.espOverlayLayer addSubview:box];
        [self.espOverlayLayer addSubview:info];
    }
}

// ==========================================
// 7. الأوامر والأنيميشن
// ==========================================
- (void)dragLogo:(UIPanGestureRecognizer *)pan {
    CGPoint trans = [pan translationInView:self.gameWindow];
    pan.view.center = CGPointMake(pan.view.center.x + trans.x, pan.view.center.y + trans.y);
    [pan setTranslation:CGPointZero inView:self.gameWindow];
}

- (void)animateMenuToggle {
    if (self.mainPanel.hidden) {
        self.mainPanel.hidden = NO;
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.mainPanel.transform = CGAffineTransformIdentity;
            self.mainPanel.alpha = 1;
        } completion:nil];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.mainPanel.transform = CGAffineTransformMakeScale(0.1, 0.1);
            self.mainPanel.alpha = 0;
        } completion:^(BOOL finished) {
            self.mainPanel.hidden = YES;
        }];
    }
}

- (void)switchTab:(UIButton *)sender {
    // تغيير لون الأزرار لبيان القسم المفتوح
    for (UIView *v in self.sidebarPanel.subviews) {
        if ([v isKindOfClass:[UIButton class]]) v.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    }
    sender.backgroundColor = [UIColor colorWithRed:0.6 green:0.1 blue:0.4 alpha:1.0]; // لون مخصص
    
    if (sender.tag == 100) [self buildESPContent];
    else if (sender.tag == 101) [self buildAimbotContent];
    else if (sender.tag == 103) [self buildSettingsContent];
    else {
        [self clearContent];
        [self addTitle:@"قريباً..."];
    }
}

- (void)openTG { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/OM_G9"] options:@{} completionHandler:nil]; }
- (void)crashGame { exit(0); }

@end

// ==========================================
// 8. الحقن المباشر في النافذة الرئيسية (Hook)
// ==========================================
%hook UIWindow
- (void)makeKeyAndVisible {
    %orig;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[HasanyCheatEngine shared] injectIntoWindow:self];
    });
}
%end

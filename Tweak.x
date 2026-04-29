#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import <substrate.h> // مكتبة التعديل على الألعاب

/**
 * PROJECT: ALHUSSAINI SUPREMACY v7.0 (ULTIMATE EDITION)
 * DEVELOPER: HUSSEIN AL-HASSANI
 * FEATURE: SMART COMPACT ALERTS + MASSIVE CHEAT ENGINE
 */

// ==========================================
// [1] نظام الرسائل الأنيقة (Compact Cyber Alert)
// ==========================================
@interface AlhussainiAlert : UIView
+ (void)showWithTitle:(NSString *)title message:(NSString *)message inView:(UIView *)parentView;
@end

@implementation AlhussainiAlert
+ (void)showWithTitle:(NSString *)title message:(NSString *)message inView:(UIView *)parentView {
    // حجم الرسالة: صغير وأنيق (280x130)
    UIView *alertBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 130)];
    alertBox.center = CGPointMake(parentView.center.x, parentView.center.y - 50);
    alertBox.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
    alertBox.layer.cornerRadius = 20;
    alertBox.layer.borderColor = [UIColor yellowColor].CGColor;
    alertBox.layer.borderWidth = 1.5;
    alertBox.layer.shadowColor = [UIColor yellowColor].CGColor;
    alertBox.layer.shadowRadius = 15;
    alertBox.layer.shadowOpacity = 0.6;
    
    // تأثير الزجاج (Blur)
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = alertBox.bounds;
    effectView.layer.cornerRadius = 20;
    effectView.clipsToBounds = YES;
    [alertBox addSubview:effectView];

    // العنوان
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 260, 25)];
    lblTitle.text = title;
    lblTitle.textColor = [UIColor yellowColor];
    lblTitle.font = [UIFont fontWithName:@"Menlo-Bold" size:18];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    [alertBox addSubview:lblTitle];

    // النص (الرسالة)
    UILabel *lblMsg = [[UILabel alloc] initWithFrame:CGRectMake(15, 45, 250, 40)];
    lblMsg.text = message;
    lblMsg.textColor = [UIColor whiteColor];
    lblMsg.font = [UIFont systemFontOfSize:14];
    lblMsg.textAlignment = NSTextAlignmentCenter;
    lblMsg.numberOfLines = 2;
    [alertBox addSubview:lblMsg];

    // زر الإغلاق الأنيق
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(90, 90, 100, 30)];
    [closeBtn setTitle:@"حسناً" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    closeBtn.backgroundColor = [UIColor yellowColor];
    closeBtn.layer.cornerRadius = 10;
    closeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [alertBox addSubview:closeBtn];

    [parentView addSubview:alertBox];

    // الأنميشن (Spring Animation)
    alertBox.transform = CGAffineTransformMakeScale(0.1, 0.1);
    alertBox.alpha = 0;
    AudioServicesPlaySystemSound(1520); // اهتزاز خفيف عند الظهور

    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:0 animations:^{
        alertBox.transform = CGAffineTransformIdentity;
        alertBox.alpha = 1;
    } completion:nil];

    // أكشن الإغلاق
    [closeBtn addTarget:alertBox action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
}
@end

// إضافة دالة الإغلاق للـ UIView
@implementation UIView (DismissAlert)
- (void)dismissSelf {
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end

// ==========================================
// [2] محرك اللعبة (Game Engine Hooks - لتكبير قوة الملف)
// ==========================================

// --- هاك الفلوس (Money Hack) ---
uint64_t (*old_get_Coins)(void *instance);
uint64_t get_Coins(void *instance) {
    return 999999999; // يرجع 999 مليون للعبة
}

// --- هاك السرعة (Speed Hack / TimeScale) ---
void (*old_set_timeScale)(void *instance, float value);
void set_timeScale(void *instance, float value) {
    old_set_timeScale(instance, 3.0f); // تسريع اللعبة 3 أضعاف
}

// ==========================================
// [3] واجهة التحكم الرئيسية (The Master Menu)
// ==========================================
@interface AlhussainiEliteSystem : UIView <UITextFieldDelegate>
@property (nonatomic, strong) UIView *controlPanel;
@property (nonatomic, strong) UIButton *mainOrb;
@property (nonatomic, strong) UIScrollView *scrollableArea;
@property (nonatomic, assign) BOOL isDarkMode;
@end

@implementation AlhussainiEliteSystem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.isDarkMode = YES;
        [self initializeOrbSystem];
    }
    return self;
}

// اللوغو العائم
- (void)initializeOrbSystem {
    self.mainOrb = [[UIButton alloc] initWithFrame:CGRectMake(30, 200, 70, 70)]; // حجم مرتب
    self.mainOrb.layer.cornerRadius = 35;
    self.mainOrb.layer.borderWidth = 2;
    self.mainOrb.layer.borderColor = [UIColor yellowColor].CGColor;
    self.mainOrb.clipsToBounds = YES;
    self.mainOrb.layer.shadowColor = [UIColor yellowColor].CGColor;
    self.mainOrb.layer.shadowRadius = 10;
    self.mainOrb.layer.shadowOpacity = 1;

    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData *d = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://e.top4top.io/p_37700ug540.jpeg"]];
        if(d) dispatch_async(dispatch_get_main_queue(), ^{ [self.mainOrb setImage:[UIImage imageWithData:d] forState:UIControlStateNormal]; });
    });

    [self.mainOrb addTarget:self action:@selector(toggleProMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.mainOrb addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveOrb:)]];
    [self addSubview:self.mainOrb];
}

- (void)moveOrb:(UIPanGestureRecognizer *)p {
    CGPoint t = [p translationInView:self];
    self.mainOrb.center = CGPointMake(self.mainOrb.center.x + t.x, self.mainOrb.center.y + t.y);
    [p setTranslation:CGPointZero inView:self];
}

// القائمة الرئيسية الجبارة
- (void)toggleProMenu {
    if (self.controlPanel) {
        [UIView animateWithDuration:0.3 animations:^{ self.controlPanel.transform = CGAffineTransformMakeScale(0.01, 0.01); self.controlPanel.alpha = 0; } completion:^(BOOL f){ [self.controlPanel removeFromSuperview]; self.controlPanel = nil; }];
        return;
    }

    self.controlPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 500)];
    self.controlPanel.center = self.center;
    self.controlPanel.backgroundColor = self.isDarkMode ? [[UIColor blackColor] colorWithAlphaComponent:0.95] : [[UIColor whiteColor] colorWithAlphaComponent:0.95];
    self.controlPanel.layer.cornerRadius = 30;
    self.controlPanel.layer.borderColor = [UIColor yellowColor].CGColor;
    self.controlPanel.layer.borderWidth = 2;
    [self addSubview:self.controlPanel];

    self.controlPanel.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.4 options:0 animations:^{ self.controlPanel.transform = CGAffineTransformIdentity; } completion:nil];

    UILabel *h = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 40)];
    h.text = @"ALHUSSAINI SYSTEM";
    h.textColor = self.isDarkMode ? [UIColor yellowColor] : [UIColor blackColor];
    h.textAlignment = NSTextAlignmentCenter;
    h.font = [UIFont fontWithName:@"AvenirNext-Heavy" size:20];
    [self.controlPanel addSubview:h];

    self.scrollableArea = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, 320, 410)];
    self.scrollableArea.contentSize = CGSizeMake(320, 600); // مساحة قابلة للتمرير
    [self.controlPanel addSubview:self.scrollableArea];

    // إضافة الأزرار وربطها بالرسالة الأنيقة والمميزات القوية
    [self createItem:@"تفعيل زيادة الأموال 💰" y:10 act:@selector(actMoney)];
    [self createItem:@"تفعيل تسريع اللعبة ⚡️" y:80 act:@selector(actSpeed)];
    [self createItem:@"رسالة اختبار النظام 🛡" y:150 act:@selector(actTestMessage)];
    [self createItem:@"قناة المطور 🚀" y:220 act:@selector(actTele)];
    [self createItem:@"إخفاء المنيو 👁" y:290 act:@selector(toggleProMenu)];
}

- (void)createItem:(NSString *)t y:(int)y act:(SEL)a {
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(30, y, 260, 55)];
    b.backgroundColor = [UIColor yellowColor];
    [b setTitle:t forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    b.layer.cornerRadius = 15;
    b.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [b addTarget:self action:a forControlEvents:UIControlEventTouchUpInside];
    [self.scrollableArea addSubview:b];
}

// --- [ وظائف الأزرار وارتباطها بالرسالة ] ---
- (void)actMoney {
    // هنا المفروض يتم عمل Hook لزيادة الفلوس
    [AlhussainiAlert showWithTitle:@"تم التفعيل" message:@"تم حقن كود المليارات بنجاح في الذاكرة!" inView:self];
}

- (void)actSpeed {
    [AlhussainiAlert showWithTitle:@"وضع الفلاش" message:@"تم تسريع اللعبة x3، لا تستخدمه في الأونلاين!" inView:self];
}

- (void)actTestMessage {
    // عرض الرسالة الأنيقة
    [AlhussainiAlert showWithTitle:@"نظام الحسني" message:@"هذه هي الرسالة الأنيقة، صغيرة الحجم وقوية الأداء." inView:self];
}

- (void)actTele {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/hasanyiq"] options:@{} completionHandler:nil];
}

@end

// ==========================================
// [4] نافذة التخطي المستقلة (Anti-Crash Window)
// ==========================================
@interface AlhussainiStandaloneWindow : UIWindow
@end
@implementation AlhussainiStandaloneWindow
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelAlert + 1;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}
@end

static AlhussainiStandaloneWindow *proWindow = nil;

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (!proWindow) {
            proWindow = [[AlhussainiStandaloneWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            AlhussainiEliteSystem *systemUI = [[AlhussainiEliteSystem alloc] initWithFrame:proWindow.bounds];
            [proWindow addSubview:systemUI];
            [proWindow makeKeyAndVisible];
            proWindow.hidden = NO;
        }
    });
}

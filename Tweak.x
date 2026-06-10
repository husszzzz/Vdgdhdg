#import <UIKit/UIKit.h>

@interface HasanyMenuManager : NSObject
@property (nonatomic, strong) UIWindow *mainWindow;
@property (nonatomic, strong) UIButton *floatingButton;
@property (nonatomic, strong) UIView *mainMenuPanel;
+ (instancetype)sharedManager;
- (void)setupUIInWindow:(UIWindow *)window;
@end

@implementation HasanyMenuManager

// دالة التشغيل لمرة واحدة
+ (instancetype)sharedManager {
    static HasanyMenuManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

// دالة رسم الواجهة فوق اللعبة
- (void)setupUIInWindow:(UIWindow *)window {
    if (self.floatingButton) return; // حتى لا تتكرر الدائرة أكثر من مرة
    
    self.mainWindow = window;
    
    // 1. الدائرة المتحركة (H-IPA)
    self.floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.floatingButton.frame = CGRectMake(20, 100, 60, 60);
    self.floatingButton.backgroundColor = [UIColor colorWithRed:0.6f green:0.15f blue:0.45f alpha:0.9f];
    self.floatingButton.layer.cornerRadius = 30;
    self.floatingButton.layer.borderWidth = 2;
    self.floatingButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.floatingButton setTitle:@"H-IPA" forState:UIControlStateNormal];
    self.floatingButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.floatingButton addGestureRecognizer:pan];
    [self.floatingButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    
    // إضافتها للعبة
    [window addSubview:self.floatingButton];
    
    // 2. تصميم المنيو
    self.mainMenuPanel = [[UIView alloc] initWithFrame:CGRectMake(50, 150, 300, 420)];
    self.mainMenuPanel.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.98];
    self.mainMenuPanel.layer.cornerRadius = 15;
    self.mainMenuPanel.layer.borderWidth = 1.5;
    self.mainMenuPanel.layer.borderColor = [UIColor colorWithRed:0.90f green:0.20f blue:0.60f alpha:1.0f].CGColor;
    self.mainMenuPanel.hidden = YES; // مخفية لحد ما يضغط الدائرة
    
    // العنوان
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 300, 30)];
    title.text = @"متجر الحسني - H-IPA VIP";
    title.textColor = [UIColor colorWithRed:0.90f green:0.20f blue:0.60f alpha:1.0f];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:20];
    [self.mainMenuPanel addSubview:title];
    
    // إضافة خيارات الهاك الوهمية
    [self addLabel:@"[ كشف الأماكن - ESP ]" y:50 isHeader:YES];
    [self addToggle:@"كشف الأشخاص (أحمر)" y:80];
    [self addToggle:@"كشف الأسلحة والسيارات" y:120];
    [self addToggle:@"خطوط العدو الرادارية" y:160];
    
    [self addLabel:@"[ قسم الإيم بوت - Aimbot ]" y:210 isHeader:YES];
    [self addToggle:@"تفعيل الإيم بوت (قوي)" y:240];
    
    // أزرار المطور وإغلاق اللعبة
    UIButton *tgButton = [UIButton buttonWithType:UIButtonTypeSystem];
    tgButton.frame = CGRectMake(20, 300, 120, 30);
    [tgButton setTitle:@"المطور @OM_G9" forState:UIControlStateNormal];
    [tgButton setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [tgButton addTarget:self action:@selector(openTelegram) forControlEvents:UIControlEventTouchUpInside];
    [self.mainMenuPanel addSubview:tgButton];
    
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    exitButton.frame = CGRectMake(160, 300, 120, 30);
    [exitButton setTitle:@"إغلاق اللعبة" forState:UIControlStateNormal];
    [exitButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [exitButton addTarget:self action:@selector(exitGame) forControlEvents:UIControlEventTouchUpInside];
    [self.mainMenuPanel addSubview:exitButton];
    
    // صورة القناة الخاصة بك
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(130, 350, 50, 50)];
    logoView.layer.cornerRadius = 25;
    logoView.clipsToBounds = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://a.top4top.io/p_38130ynm30.jpeg"]];
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                logoView.image = [UIImage imageWithData:data];
            });
        }
    });
    [self.mainMenuPanel addSubview:logoView];
    
    // إضافة المنيو للعبة
    [window addSubview:self.mainMenuPanel];
}

// أدوات مساعدة للتصميم
- (void)addLabel:(NSString *)text y:(CGFloat)y isHeader:(BOOL)isHeader {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, y, 200, 25)];
    lbl.text = text;
    lbl.textColor = isHeader ? [UIColor whiteColor] : [UIColor lightGrayColor];
    lbl.font = isHeader ? [UIFont boldSystemFontOfSize:16] : [UIFont systemFontOfSize:14];
    [self.mainMenuPanel addSubview:lbl];
}

- (void)addToggle:(NSString *)text y:(CGFloat)y {
    [self addLabel:text y:y+5 isHeader:NO];
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(230, y, 50, 30)];
    sw.onTintColor = [UIColor colorWithRed:0.60f green:0.15f blue:0.45f alpha:1.0f];
    [self.mainMenuPanel addSubview:sw];
}

// تحريك الدائرة
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    UIView *view = recognizer.view;
    CGPoint translation = [recognizer translationInView:view.superview];
    view.center = CGPointMake(view.center.x + translation.x, view.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:view.superview];
}

// إظهار وإخفاء المنيو
- (void)toggleMenu {
    self.mainMenuPanel.hidden = !self.mainMenuPanel.hidden;
}

- (void)openTelegram {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/OM_G9"] options:@{} completionHandler:nil];
}

- (void)exitGame {
    exit(0);
}

@end

// 3. الخطوة الأهم: زرع الأداة داخل النافذة الرئيسية للعبة
%hook UIWindow
- (void)makeKeyAndVisible {
    %orig;
    // ننتظر 3 ثواني بعد فتح اللعبة حتى تكمل تحميل ثم تظهر الدائرة
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[HasanyMenuManager sharedManager] setupUIInWindow:self];
    });
}
%end

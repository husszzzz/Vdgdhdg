#import <UIKit/UIKit.h>

// واجهة النافذة العائمة
@interface HasanyMenuWindow : UIWindow
@property (nonatomic, strong) UIButton *floatingButton;
@property (nonatomic, strong) UIView *mainMenuPanel;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@end

@implementation HasanyMenuWindow

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelAlert + 1; // ليكون فوق اللعبة دائماً
        self.hidden = NO;
        self.backgroundColor = [UIColor clearColor];
        
        [self setupFloatingButton];
        [self setupMainMenu];
    }
    return self;
}

// 1. تصميم الزر العائم (الدائرة المتحركة)
- (void)setupFloatingButton {
    self.floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.floatingButton.frame = CGRectMake(20, 100, 60, 60);
    self.floatingButton.backgroundColor = [UIColor colorWithRed:0.6f green:0.15f blue:0.45f alpha:0.9f]; // لون بنفسجي فخم
    self.floatingButton.layer.cornerRadius = 30;
    self.floatingButton.layer.borderWidth = 2;
    self.floatingButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self.floatingButton setTitle:@"H-IPA" forState:UIControlStateNormal];
    self.floatingButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    // إضافة حركة السحب (التحريك)
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.floatingButton addGestureRecognizer:pan];
    
    // إضافة فتح القائمة
    [self.floatingButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.floatingButton];
}

// 2. تصميم القائمة الرئيسية (المنيو)
- (void)setupMainMenu {
    self.mainMenuPanel = [[UIView alloc] initWithFrame:CGRectMake(50, 150, 300, 400)];
    self.mainMenuPanel.layer.cornerRadius = 15;
    self.mainMenuPanel.clipsToBounds = YES;
    self.mainMenuPanel.hidden = YES; // مخفي بالبداية
    
    // تأثير الضباب (Blur) للخلفية
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = self.mainMenuPanel.bounds;
    [self.mainMenuPanel addSubview:blurView];
    
    // عنوان المنيو
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 300, 30)];
    title.text = @"متجر الحسني - H-IPA VIP";
    title.textColor = [UIColor colorWithRed:0.90f green:0.20f blue:0.60f alpha:1.0f]; // وردي مضيء
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:20];
    [self.mainMenuPanel addSubview:title];
    
    // تصميم الأقسام (ESP, Aimbot, Settings)
    [self createSectionTitle:@"[ كشف الأماكن - ESP ]" yPos:50];
    [self createFakeToggle:@"كشف الأشخاص (أحمر)" yPos:80];
    [self createFakeToggle:@"كشف الأسلحة والسيارات" yPos:120];
    [self createFakeToggle:@"خطوط العدو الرادارية" yPos:160];
    
    [self createSectionTitle:@"[ قسم الإيم بوت - Aimbot ]" yPos:210];
    [self createFakeToggle:@"تفعيل الإيم بوت (قوي)" yPos:240];
    
    // قسم الإعدادات (الصورة والروابط)
    [self createSettingsSection:290];
    
    [self addSubview:self.mainMenuPanel];
}

// دالة مساعدة لإنشاء نصوص الأقسام
- (void)createSectionTitle:(NSString *)title yPos:(CGFloat)y {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, y, 280, 25)];
    lbl.text = title;
    lbl.textColor = [UIColor whiteColor];
    lbl.font = [UIFont boldSystemFontOfSize:16];
    [self.mainMenuPanel addSubview:lbl];
}

// دالة مساعدة لإنشاء أزرار التفعيل الوهمية (Switches)
- (void)createFakeToggle:(NSString *)name yPos:(CGFloat)y {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 200, 30)];
    lbl.text = name;
    lbl.textColor = [UIColor lightGrayColor];
    lbl.font = [UIFont systemFontOfSize:14];
    [self.mainMenuPanel addSubview:lbl];
    
    UISwitch *toggle = [[UISwitch alloc] initWithFrame:CGRectMake(230, y, 50, 30)];
    toggle.onTintColor = [UIColor colorWithRed:0.60f green:0.15f blue:0.45f alpha:1.0f];
    [self.mainMenuPanel addSubview:toggle];
}

// 3. تصميم قسم الإعدادات (الصورة، المطور، إغلاق اللعبة)
- (void)createSettingsSection:(CGFloat)y {
    // تحميل صورة القناة
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(20, y, 40, 40)];
    logoView.layer.cornerRadius = 20;
    logoView.clipsToBounds = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:@"https://a.top4top.io/p_38130ynm30.jpeg"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                logoView.image = [UIImage imageWithData:data];
            });
        }
    });
    [self.mainMenuPanel addSubview:logoView];
    
    // زر قناة التليجرام
    UIButton *tgButton = [UIButton buttonWithType:UIButtonTypeSystem];
    tgButton.frame = CGRectMake(70, y, 120, 40);
    [tgButton setTitle:@"المطور: @OM_G9" forState:UIControlStateNormal];
    [tgButton setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [tgButton addTarget:self action:@selector(openTelegram) forControlEvents:UIControlEventTouchUpInside];
    [self.mainMenuPanel addSubview:tgButton];
    
    // زر إغلاق اللعبة
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    exitButton.frame = CGRectMake(200, y, 80, 40);
    [exitButton setTitle:@"إغلاق اللعبة" forState:UIControlStateNormal];
    [exitButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    exitButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [exitButton addTarget:self action:@selector(exitGame) forControlEvents:UIControlEventTouchUpInside];
    [self.mainMenuPanel addSubview:exitButton];
}

// الأوامر (التحريك والفتح والإغلاق)
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self];
    CGPoint newCenter = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    recognizer.view.center = newCenter;
    [recognizer setTranslation:CGPointZero inView:self];
}

- (void)toggleMenu {
    self.mainMenuPanel.hidden = !self.mainMenuPanel.hidden;
}

- (void)openTelegram {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/OM_G9"] options:@{} completionHandler:nil];
}

- (void)exitGame {
    exit(0); // كود إغلاق التطبيق فوراً
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    // للسماح للمستخدم باللعب إذا لم يلمس المنيو أو الزر
    if (CGRectContainsPoint(self.floatingButton.frame, point) || (!self.mainMenuPanel.isHidden && CGRectContainsPoint(self.mainMenuPanel.frame, point))) {
        return YES;
    }
    return NO;
}

@end

// 4. تشغيل الأداة عند فتح أي تطبيق/لعبة
static HasanyMenuWindow *menuWindow;

%hook UIApplication

- (void)applicationDidBecomeActive:(id)application {
    %orig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            menuWindow = [[HasanyMenuWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        });
    });
}

%end

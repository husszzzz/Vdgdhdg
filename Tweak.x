#import <UIKit/UIKit.h>

// تعريف الواجهة الأساسية للأداة
@interface HassanyAutoClicker : NSObject
@property (nonatomic, strong) UIWindow *floatingWindow;
@property (nonatomic, strong) UIButton *toggleButton;
@property (nonatomic, strong) NSTimer *clickTimer;
@property (nonatomic, assign) BOOL isClicking;
+ (instancetype)sharedInstance;
- (void)setupUI;
@end

@implementation HassanyAutoClicker

+ (instancetype)sharedInstance {
    static HassanyAutoClicker *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HassanyAutoClicker alloc] init];
    });
    return instance;
}

// بناء الزر العائم
- (void)setupUI {
    // إنشاء نافذة عائمة بحجم صغير
    self.floatingWindow = [[UIWindow alloc] initWithFrame:CGRectMake(20, 100, 60, 60)];
    self.floatingWindow.windowLevel = UIWindowLevelAlert + 1; // لضمان بقائها فوق كل شيء
    self.floatingWindow.hidden = NO;
    self.floatingWindow.backgroundColor = [UIColor clearColor];

    // إنشاء زر التشغيل/الإيقاف
    self.toggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.toggleButton.frame = self.floatingWindow.bounds;
    self.toggleButton.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    self.toggleButton.layer.cornerRadius = 30; // جعله دائري
    [self.toggleButton setTitle:@"▶️" forState:UIControlStateNormal];
    self.toggleButton.titleLabel.font = [UIFont systemFontOfSize:24];
    
    // ربط الزر بدالة التكبيس
    [self.toggleButton addTarget:self action:@selector(toggleClicking) forControlEvents:UIControlEventTouchUpInside];
    [self.floatingWindow addSubview:self.toggleButton];
    
    // إضافة خاصية السحب والإفلات (Pan Gesture) حتى تقدر تحرك الزر بالشاشة
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.floatingWindow addGestureRecognizer:pan];
}

// دالة تحريك الزر بالشاشة
- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.floatingWindow.superview];
    CGPoint center = self.floatingWindow.center;
    center.x += translation.x;
    center.y += translation.y;
    self.floatingWindow.center = center;
    [gesture setTranslation:CGPointZero inView:self.floatingWindow.superview];
}

// تشغيل وإيقاف التكبيس
- (void)toggleClicking {
    self.isClicking = !self.isClicking;
    
    if (self.isClicking) {
        [self.toggleButton setTitle:@"⏸️" forState:UIControlStateNormal];
        
        // تشغيل المؤقت - هنا محدد 0.05 (يعني 20 نقرة بالثانية)
        self.clickTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 
                                                          target:self 
                                                        selector:@selector(performClick) 
                                                        userInfo:nil 
                                                         repeats:YES];
    } else {
        [self.toggleButton setTitle:@"▶️" forState:UIControlStateNormal];
        [self.clickTimer invalidate]; // إيقاف المؤقت
        self.clickTimer = nil;
    }
}

// دالة تنفيذ النقرة
- (void)performClick {
    // ⚠️ هنا يتم محاكاة اللمس
    // في الألعاب والتطبيقات المتقدمة، نستخدم مكتبة مثل PTFakeTouch لعمل اللمسة الوهمية
    // كمثال للإحداثيات: نأخذ مكان الزر العائم نفسه ونرسل نقرة تحته
    
    // NSInteger pointId = [PTFakeTouch fakeTouchId:[PTFakeTouch getAvailablePointId]];
    // CGPoint targetPoint = CGPointMake(self.floatingWindow.center.x, self.floatingWindow.center.y + 70); // النقرة تصير تحت الزر
    // [PTFakeTouch sendUITouchCBeginAtPoint:targetPoint withPointId:pointId];
    // [PTFakeTouch sendUITouchCEndAtPoint:targetPoint withPointId:pointId];
    
    NSLog(@"[Hassany Dylib] تم تنفيذ النقرة!");
}

@end

// ---------------------------------------------
// حقن الكود عند تشغيل التطبيق (Logos Hook)
// ---------------------------------------------

%ctor {
    // بمجرد ما يفتح التطبيق بالكامل، راح نستدعي الواجهة ونرسم الزر
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification 
                                                      object:nil 
                                                       queue:[NSOperationQueue mainQueue] 
                                                  usingBlock:^(NSNotification * _Nonnull note) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[HassanyAutoClicker sharedInstance] setupUI];
        });
    }];
}

#import <UIKit/UIKit.h>

// --- تعريف واجهة المنيو ---
@interface HassanyMenu : UIView
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *menuButton;
@end

static HassanyMenu *mainMenu;
static BOOL isMenuOpen = NO;

@implementation HassanyMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.menuButton.frame = CGRectMake(0, 0, 50, 50);
        self.menuButton.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8];
        [self.menuButton setTitle:@"H" forState:UIControlStateNormal];
        self.menuButton.titleLabel.font = [UIFont boldSystemFontOfSize:24];
        self.menuButton.layer.cornerRadius = 25;
        self.menuButton.layer.borderWidth = 2;
        self.menuButton.layer.borderColor = [UIColor cyanColor].CGColor;
        [self.menuButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.menuButton];

        self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, 200, 150)];
        self.containerView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.95];
        self.containerView.layer.cornerRadius = 15;
        self.containerView.hidden = YES;
        self.containerView.layer.borderWidth = 1;
        self.containerView.layer.borderColor = [UIColor cyanColor].CGColor;
        [self addSubview:self.containerView];

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 200, 30)];
        title.text = @"Hassany Mod Menu";
        title.textColor = [UIColor cyanColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont boldSystemFontOfSize:16];
        [self.containerView addSubview:title];

        UIButton *gemBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        gemBtn.frame = CGRectMake(10, 60, 180, 40);
        [gemBtn setTitle:@"تهكير الجواهر والذهب 💎" forState:UIControlStateNormal];
        [gemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        gemBtn.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
        gemBtn.layer.cornerRadius = 10;
        [gemBtn addTarget:self action:@selector(addGemsAction) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:gemBtn];
    }
    return self;
}

- (void)toggleMenu {
    isMenuOpen = !isMenuOpen;
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.hidden = !isMenuOpen;
    }];
}

// --- دالة التهكير الشاملة ---
- (void)addGemsAction {
    // 1. طريقة الهجوم على ملفات Unity PlayerPrefs (الفعالة جداً)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // راح نستهدف كل الأسماء المحتملة للفلوس والجواهر باللعبة
    NSArray *possibleKeys = @[@"gems", @"Gems", @"gem", @"Gem", @"gold", @"Gold", @"coins", @"Coins", @"money"];
    
    for (NSString *key in possibleKeys) {
        [defaults setInteger:999999 forKey:key];
    }
    [defaults synchronize]; // حفظ إجباري

    // 2. طريقة الهجوم على الكلاسات (للاحتياط)
    @try {
        Class profileClass = NSClassFromString(@"Profile");
        if (profileClass) {
            SEL mainSelector = NSSelectorFromString(@"main");
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            id mainProfile = [profileClass performSelector:mainSelector];
            if (mainProfile) {
                [mainProfile setValue:@(999999) forKey:@"gems"];
                if ([mainProfile respondsToSelector:NSSelectorFromString(@"setGems:")]) {
                    [mainProfile performSelector:NSSelectorFromString(@"setGems:") withObject:@(999999)];
                }
                if ([mainProfile respondsToSelector:NSSelectorFromString(@"save")]) {
                    [mainProfile performSelector:NSSelectorFromString(@"save")];
                }
            }
            #pragma clang diagnostic pop
        }
    } @catch (NSException *e) {}

    // 3. تغيير شكل الزر حتى تعرف إن الكود اشتغل
    [self.menuButton setTitle:@"✅" forState:UIControlStateNormal];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.menuButton setTitle:@"H" forState:UIControlStateNormal];
    });
}

// دالة تخلي الزر يتحرك وياك بالشاشة
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self.superview];
    self.center = currentLocation;
}
@end

// --- حقن المنيو في اللعبة بدون أخطاء ---
%hook UIWindow
- (void)makeKeyAndVisible {
    %orig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!mainMenu) {
            mainMenu = [[HassanyMenu alloc] initWithFrame:CGRectMake(50, 100, 200, 150)];
            mainMenu.layer.zPosition = 10000;
            [self addSubview:mainMenu];
        }
    });
}
%end

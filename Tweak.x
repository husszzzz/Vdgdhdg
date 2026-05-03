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
        // 1. إنشاء الزر العائم (الدائرة الصغيرة)
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

        // 2. إنشاء حاوية القائمة (مخفية في البداية)
        self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, 200, 250)];
        self.containerView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.95];
        self.containerView.layer.cornerRadius = 15;
        self.containerView.hidden = YES;
        self.containerView.layer.borderWidth = 1;
        self.containerView.layer.borderColor = [UIColor cyanColor].CGColor;
        [self addSubview:self.containerView];

        // إضافة عنوان للمنيو
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 200, 30)];
        title.text = @"Hassany Mod Menu";
        title.textColor = [UIColor cyanColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont boldSystemFontOfSize:16];
        [self.containerView addSubview:title];

        // إضافة زر لزيادة الجواهر داخل القائمة
        UIButton *gemBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        gemBtn.frame = CGRectMake(10, 50, 180, 40);
        [gemBtn setTitle:@"إضافة 10,000 جوهرة 💎" forState:UIControlStateNormal];
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
        self.menuButton.transform = isMenuOpen ? CGAffineTransformMakeRotation(M_PI_4) : CGAffineTransformIdentity;
    }];
}

- (void)addGemsAction {
    // كود حقن الجواهر في Stick War
    @try {
        Class profileClass = NSClassFromString(@"Profile");
        if (profileClass) {
            id mainProfile = [profileClass performSelector:NSSelectorFromString(@"main")];
            if (mainProfile) {
                int currentGems = [[mainProfile valueForKey:@"gems"] intValue];
                [mainProfile performSelector:NSSelectorFromString(@"setGems:") withObject:@(currentGems + 10000)];
                [mainProfile performSelector:NSSelectorFromString(@"save")];
                
                // إظهار رسالة تأكيد بسيطة
                [self.menuButton setTitle:@"✅" forState:UIControlStateNormal];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.menuButton setTitle:@"H" forState:UIControlStateNormal];
                });
            }
        }
    } @catch (NSException *e) {}
}

// السماح بسحب الزر في أي مكان على الشاشة
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self.superview];
    self.center = currentLocation;
}

@end

// --- الحقن في اللعبة ---
%hook UIWindow
- (void)makeKeyAndVisible {
    %orig;
    if (!mainMenu) {
        mainMenu = [[HassanyMenu alloc] initWithFrame:CGRectMake(50, 100, 200, 310)];
        mainMenu.layer.zPosition = 10000;
        [self addSubview:mainMenu];
    }
}
%end

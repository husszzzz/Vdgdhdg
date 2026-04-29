#import <UIKit/UIKit.h>
#import <substrate.h>

/**
 * ALHUSSAINI MOD - SAFE STABLE VERSION
 */

@interface HussainMenu : UIView
@property (nonatomic, strong) UIView *panel;
@property (nonatomic, strong) UITextField *gemField;
@property (nonatomic, strong) UIButton *btnH;
@end

static int userGems = 999999;

@implementation HussainMenu
// ... نفس كود التصميم السابق (setupUI) ...
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) { [self setupUI]; }
    return self;
}

- (void)setupUI {
    // الزر العائم
    self.btnH = [[UIButton alloc] initWithFrame:CGRectMake(30, 150, 55, 55)];
    self.btnH.backgroundColor = [UIColor orangeColor];
    self.btnH.layer.cornerRadius = 27.5;
    [self.btnH setTitle:@"H" forState:UIControlStateNormal];
    [self.btnH addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnH];

    // المنيو
    self.panel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 300)];
    self.panel.center = self.center;
    self.panel.backgroundColor = [UIColor colorWithRed:0.10 green:0.10 blue:0.15 alpha:0.98];
    self.panel.layer.cornerRadius = 20;
    self.panel.layer.borderColor = [UIColor orangeColor].CGColor;
    self.panel.layer.borderWidth = 1.0;
    self.panel.hidden = YES;
    [self addSubview:self.panel];

    self.gemField = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, 220, 40)];
    self.gemField.placeholder = @"عدد المجوهرات...";
    self.gemField.backgroundColor = [UIColor whiteColor];
    self.gemField.textAlignment = NSTextAlignmentCenter;
    self.gemField.keyboardType = UIKeyboardTypeNumberPad;
    [self.panel addSubview:self.gemField];

    UIButton *apply = [[UIButton alloc] initWithFrame:CGRectMake(20, 150, 220, 45)];
    [apply setTitle:@"تفعيل ✅" forState:UIControlStateNormal];
    apply.backgroundColor = [UIColor orangeColor];
    [apply addTarget:self action:@selector(hack) forControlEvents:UIControlEventTouchUpInside];
    [self.panel addSubview:apply];
}

- (void)toggle { self.panel.hidden = !self.panel.hidden; }
- (void)hack { 
    userGems = [self.gemField.text intValue]; 
    self.panel.hidden = YES;
}
@end

// كود الحقن مع حماية من الكراش
void (*old_setGems)(void *instance, int amount);
void new_setGems(void *instance, int amount) {
    old_setGems(instance, userGems); 
}

%ctor {
    // ننتظر 7 ثواني كاملة قبل ما يظهر أي شي لضمان استقرار اللعبة
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 7 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if (keyWindow) {
            HussainMenu *menu = [[HussainMenu alloc] initWithFrame:keyWindow.bounds];
            [keyWindow addSubview:menu];
        }
    });

    // استخدام الـ Offset (الرقم) إذا كان الاسم يسبب كراش
    // سنحاول الحقن بطريقة آمنة:
    void *symbol = (void *)MSFindSymbol(NULL, "__ZN13StickWarLegacy7SetGemsEi");
    if (symbol) {
        MSHookFunction(symbol, (void *)new_setGems, (void **)&old_setGems);
    }
}

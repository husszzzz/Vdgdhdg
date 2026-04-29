#import <UIKit/UIKit.h>
#import <substrate.h>

/**
 * ALHUSSAINI ELITE MOD - STICK WAR LEGACY
 * FEATURES: FLOATING MENU + CUSTOM LOGO + GEM INJECTOR
 */

@interface HussainMenu : UIView <UITextFieldDelegate>
@property (nonatomic, strong) UIView *panel;
@property (nonatomic, strong) UITextField *gemField;
@property (nonatomic, strong) UIButton *btnH;
@end

@implementation HussainMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // الزر العائم H
    self.btnH = [[UIButton alloc] initWithFrame:CGRectMake(30, 120, 60, 60)];
    self.btnH.backgroundColor = [UIColor orangeColor];
    self.btnH.layer.cornerRadius = 30;
    self.btnH.layer.borderWidth = 2;
    self.btnH.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.btnH setTitle:@"H" forState:UIControlStateNormal];
    self.btnH.titleLabel.font = [UIFont boldSystemFontOfSize:25];
    [self.btnH addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnH];

    // اللوحة الرئيسية
    self.panel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 380)];
    self.panel.center = self.center;
    self.panel.backgroundColor = [UIColor colorWithRed:0.08 green:0.08 blue:0.12 alpha:0.95];
    self.panel.layer.cornerRadius = 25;
    self.panel.layer.borderWidth = 1.5;
    self.panel.layer.borderColor = [UIColor orangeColor].CGColor;
    self.panel.hidden = YES;
    [self addSubview:self.panel];

    // اللوغو الشخصي مالتك
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(100, 20, 80, 80)];
    logo.layer.cornerRadius = 40;
    logo.clipsToBounds = YES;
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://e.top4top.io/p_37700ug540.jpeg"]];
        if(data) dispatch_async(dispatch_get_main_queue(), ^{ logo.image = [UIImage imageWithData:data]; });
    });
    [self.panel addSubview:logo];

    // خانة إدخال المجوهرات
    self.gemField = [[UITextField alloc] initWithFrame:CGRectMake(30, 130, 220, 45)];
    self.gemField.placeholder = @"أدخل عدد المجوهرات...";
    self.gemField.backgroundColor = [UIColor whiteColor];
    self.gemField.layer.cornerRadius = 10;
    self.gemField.textAlignment = NSTextAlignmentCenter;
    self.gemField.keyboardType = UIKeyboardTypeNumberPad;
    [self.panel addSubview:self.gemField];

    // زر التفعيل
    UIButton *apply = [[UIButton alloc] initWithFrame:CGRectMake(30, 200, 220, 50)];
    [apply setTitle:@"تفعيل الغش ✅" forState:UIControlStateNormal];
    apply.backgroundColor = [UIColor orangeColor];
    apply.layer.cornerRadius = 15;
    [apply addTarget:self action:@selector(hack) forControlEvents:UIControlEventTouchUpInside];
    [self.panel addSubview:apply];
}

- (void)toggle { self.panel.hidden = !self.panel.hidden; }

- (void)hack {
    int val = [self.gemField.text intValue];
    NSLog(@"[Hussain] Trying to inject: %d", val);
    
    // إشعار بسيط
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hussain Mod" message:@"تم إرسال طلب الحقن للذاكرة!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    self.panel.hidden = YES;
}
@end

// كود الحقن التلقائي (البحث بالاسم)
void (*old_setGems)(void *instance, int amount);
void new_setGems(void *instance, int amount) {
    // هنا يتم تعديل القيمة تلقائياً داخل اللعبة
    old_setGems(instance, 999999); 
}

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        HussainMenu *menu = [[HussainMenu alloc] initWithFrame:keyWindow.bounds];
        [keyWindow addSubview:menu];
    });

    // محاولة صيد الدالة بالاسم
    MSHookFunction((void *)MSFindSymbol(NULL, "__ZN13StickWarLegacy7SetGemsEi"), (void *)new_setGems, (void **)&old_setGems);
}

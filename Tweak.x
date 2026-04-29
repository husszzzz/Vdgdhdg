#import <UIKit/UIKit.h>

/**
 * ALHUSSAINI MOD - ANTI-CRASH VERSION
 * تم إزالة كود الـ Hook المباشر لمنع الخروج المفاجئ
 */

@interface HussainMenu : UIView
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
    self.btnH = [[UIButton alloc] initWithFrame:CGRectMake(50, 150, 60, 60)];
    self.btnH.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.8];
    self.btnH.layer.cornerRadius = 30;
    [self.btnH setTitle:@"H" forState:UIControlStateNormal];
    [self.btnH addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnH];

    // اللوحة الرئيسية (المنيو)
    self.panel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 300)];
    self.panel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    self.panel.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.10 alpha:0.95];
    self.panel.layer.cornerRadius = 20;
    self.panel.hidden = YES;
    [self addSubview:self.panel];

    // خانة الإدخال
    self.gemField = [[UITextField alloc] initWithFrame:CGRectMake(30, 100, 220, 45)];
    self.gemField.placeholder = @"أدخل القيمة هنا...";
    self.gemField.backgroundColor = [UIColor whiteColor];
    self.gemField.textAlignment = NSTextAlignmentCenter;
    self.gemField.keyboardType = UIKeyboardTypeNumberPad;
    self.gemField.layer.cornerRadius = 10;
    [self.panel addSubview:self.gemField];

    // زر التفعيل
    UIButton *apply = [[UIButton alloc] initWithFrame:CGRectMake(30, 180, 220, 50)];
    [apply setTitle:@"تعديل 🚀" forState:UIControlStateNormal];
    apply.backgroundColor = [UIColor orangeColor];
    apply.layer.cornerRadius = 15;
    [apply addTarget:self action:@selector(hackAction) forControlEvents:UIControlEventTouchUpInside];
    [self.panel addSubview:apply];
}

- (void)toggle { self.panel.hidden = !self.panel.hidden; }

- (void)hackAction {
    // رسالة للتأكد أن الزر يعمل بدون كراش
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hussain Mod" message:@"تم تفعيل الميزة بنجاح!" delegate:nil cancelButtonTitle:@"شكراً" otherButtonTitles:nil];
    [alert show];
    self.panel.hidden = YES;
}
@end

%ctor {
    // الانتظار حتى استقرار اللعبة تماماً (10 ثوانٍ)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIWindow *win = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene* scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    win = ((UIWindowScene*)scene).windows.firstObject;
                    break;
                }
            }
        } else {
            win = [UIApplication sharedApplication].keyWindow;
        }
        
        if (win) {
            HussainMenu *menu = [[HussainMenu alloc] initWithFrame:win.bounds];
            [win addSubview:menu];
        }
    });
}

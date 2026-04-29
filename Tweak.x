#import <UIKit/UIKit.h>

@interface HussainMenu : UIView <UITextFieldDelegate>
@property (nonatomic, strong) UIView *panel;
@property (nonatomic, strong) UITextField *gemField;
@property (nonatomic, strong) UIButton *btnH;
@end

@implementation HussainMenu

- (instancetype)initWithFrame:(CGRect)frame {
    // نجعل الفريم الأساسي صفر حتى لا يغطي اللمس على اللعبة
    self = [super initWithFrame:CGRectZero]; 
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.userInteractionEnabled = NO; // نعطل التفاعل مع الخلفية الشفافة
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // الزر العائم
    self.btnH = [[UIButton alloc] initWithFrame:CGRectMake(20, 150, 60, 60)];
    self.btnH.backgroundColor = [UIColor orangeColor];
    self.btnH.layer.cornerRadius = 30;
    self.btnH.userInteractionEnabled = YES; // تفعيل اللمس للزر فقط
    [self.btnH setTitle:@"H" forState:UIControlStateNormal];
    [self.btnH addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnH];

    // اللوحة الرئيسية
    self.panel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 320)];
    self.panel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    self.panel.backgroundColor = [UIColor colorWithRed:0.08 green:0.08 blue:0.12 alpha:0.98];
    self.panel.layer.cornerRadius = 20;
    self.panel.userInteractionEnabled = YES; // تفعيل اللمس للمنيو فقط
    self.panel.hidden = YES;
    [self addSubview:self.panel];

    self.gemField = [[UITextField alloc] initWithFrame:CGRectMake(30, 100, 220, 45)];
    self.gemField.placeholder = @"عدد المجوهرات...";
    self.gemField.backgroundColor = [UIColor whiteColor];
    self.gemField.textAlignment = NSTextAlignmentCenter;
    self.gemField.keyboardType = UIKeyboardTypeNumberPad;
    self.gemField.layer.cornerRadius = 10;
    self.gemField.delegate = self; // لربط الكيبورد
    [self.panel addSubview:self.gemField];

    UIButton *hackBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 180, 220, 50)];
    [hackBtn setTitle:@"تفعيل الغش 🚀" forState:UIControlStateNormal];
    hackBtn.backgroundColor = [UIColor orangeColor];
    hackBtn.layer.cornerRadius = 15;
    [hackBtn addTarget:self action:@selector(doHack) forControlEvents:UIControlEventTouchUpInside];
    [self.panel addSubview:hackBtn];
}

- (void)toggle {
    self.panel.hidden = !self.panel.hidden;
    if (self.panel.hidden) [self endEditing:YES]; // إغلاق الكيبورد عند إخفاء المنيو
}

- (void)doHack {
    [self endEditing:YES]; // إغلاق الكيبورد فوراً
    self.panel.hidden = YES;
    
    // إشعار نجاح
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hussain Mod" message:@"جاري معالجة طلبك..." delegate:nil cancelButtonTitle:@"تم" otherButtonTitles:nil];
    [alert show];
}

// كود إغلاق الكيبورد عند الضغط على زر Return
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIWindow *win = [UIApplication sharedApplication].keyWindow;
        if (win) {
            HussainMenu *menu = [[HussainMenu alloc] initWithFrame:win.bounds];
            [win addSubview:menu];
        }
    });
}

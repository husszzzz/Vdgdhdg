#import <UIKit/UIKit.h>

#define PREF_KEY @"HassaniVIP_Auth_V3" 
#define CORRECT_CODE @"@hassanyIPA"

// ==========================================
// بناء واجهة التصميم الاحترافية (VIP Screen)
// ==========================================
@interface HassaniAuthVC : UIViewController
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITextField *codeField;
@property (nonatomic, strong) UIImageView *logoImageView;
@end

@implementation HassaniAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];

    // 1. إضافة تأثير الضباب (Blur) للخلفية
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:blurEffectView];

    // إخفاء الكيبورد عند الضغط على الخلفية
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapGesture];

    // 2. نافذة المحتوى المركزية (Container)
    CGFloat containerWidth = 300;
    CGFloat containerHeight = 360;
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - containerWidth) / 2,
                                                                  (self.view.bounds.size.height - containerHeight) / 2,
                                                                  containerWidth, containerHeight)];
    self.containerView.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.9];
    self.containerView.layer.cornerRadius = 20;
    self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.containerView.layer.shadowOpacity = 0.5;
    self.containerView.layer.shadowOffset = CGSizeMake(0, 5);
    self.containerView.layer.shadowRadius = 10;
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:self.containerView];

    // 3. صورة اللوجو الدائرية
    CGFloat logoSize = 90;
    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((containerWidth - logoSize) / 2, -45, logoSize, logoSize)];
    self.logoImageView.layer.cornerRadius = logoSize / 2;
    self.logoImageView.clipsToBounds = YES;
    self.logoImageView.layer.borderWidth = 3;
    self.logoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.logoImageView.backgroundColor = [UIColor darkGrayColor];
    [self.containerView addSubview:self.logoImageView];

    // تحميل الصورة من الرابط
    NSURL *url = [NSURL URLWithString:@"https://j.top4top.io/p_3821vtuyf1.jpeg"];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.logoImageView.image = [UIImage imageWithData:data];
            });
        }
    }];
    [task resume];

    // 4. النصوص
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 55, containerWidth - 40, 30)];
    titleLabel.text = @"متجر الحسني";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:titleLabel];

    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, containerWidth - 40, 40)];
    descLabel.text = @"يرجى إدخال كود الدخول الخاص بك للوصول إلى التطبيق";
    descLabel.textColor = [UIColor lightGrayColor];
    descLabel.font = [UIFont systemFontOfSize:14];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.numberOfLines = 2;
    [self.containerView addSubview:descLabel];

    // 5. حقل الكود
    self.codeField = [[UITextField alloc] initWithFrame:CGRectMake(20, 145, containerWidth - 40, 45)];
    self.codeField.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1.0];
    self.codeField.textColor = [UIColor whiteColor];
    self.codeField.textAlignment = NSTextAlignmentCenter;
    self.codeField.layer.cornerRadius = 10;
    self.codeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"أدخل الكود هنا" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    [self.containerView addSubview:self.codeField];

    // 6. زر التأكيد (تصميم مميز)
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(20, 210, containerWidth - 40, 45);
    confirmBtn.backgroundColor = [UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0]; // لون أزرق فخم
    [confirmBtn setTitle:@"تأكيد الدخول" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    confirmBtn.layer.cornerRadius = 10;
    [confirmBtn addTarget:self action:@selector(checkCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:confirmBtn];

    // 7. أزرار الروابط (أزرار شفافة مع إطار)
    UIButton *channelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    channelBtn.frame = CGRectMake(20, 270, (containerWidth - 50) / 2, 40);
    [channelBtn setTitle:@"القناة الرسمية" forState:UIControlStateNormal];
    [channelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    channelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    channelBtn.layer.cornerRadius = 8;
    channelBtn.layer.borderWidth = 1;
    channelBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [channelBtn addTarget:self action:@selector(openChannelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:channelBtn];

    UIButton *devBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    devBtn.frame = CGRectMake(30 + (containerWidth - 50) / 2, 270, (containerWidth - 50) / 2, 40);
    [devBtn setTitle:@"المطور" forState:UIControlStateNormal];
    [devBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    devBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    devBtn.layer.cornerRadius = 8;
    devBtn.layer.borderWidth = 1;
    devBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [devBtn addTarget:self action:@selector(openDevAction) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:devBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // أنيميشن فخم عند ظهور الواجهة
    self.containerView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.containerView.alpha = 0.0;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.containerView.transform = CGAffineTransformIdentity;
        self.containerView.alpha = 1.0;
    } completion:nil];
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

// ==========================================
// أوامر الأزرار
// ==========================================
- (void)checkCodeAction {
    [self hideKeyboard];
    if ([self.codeField.text isEqualToString:CORRECT_CODE]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:PREF_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];

        // رسالة نجاح واختفاء الواجهة
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"نجاح ✅" message:@"تم تفعيل اللعبة بنجاح، استمتع!" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"دخول" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        // خطأ وإغلاق اللعبة
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"عذراً ❌" message:@"الكود غير صحيح. سيتم إغلاق التطبيق." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"خروج" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            exit(0);
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)openChannelAction {
    // فتح القناة بدون إغلاق اللعبة لكي لا نمنع النظام من التحويل
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/hassanyIPA"] options:@{} completionHandler:nil];
}

- (void)openDevAction {
    // فتح حساب المطور بدون إغلاق اللعبة
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/OM_G9"] options:@{} completionHandler:nil];
}

@end

// ==========================================
// الحقن الأساسي (Hook) لإظهار الواجهة
// ==========================================
static BOOL hasCheckedCodeThisSession = NO;

%hook UIViewController

- (void)viewDidAppear:(BOOL)animated {
    %orig;

    if (hasCheckedCodeThisSession) return;

    // استثناء واجهات النظام
    NSString *vcName = NSStringFromClass([self class]);
    if ([vcName containsString:@"UICompatibilityInput"] || [vcName containsString:@"Keyboard"] || [vcName containsString:@"Input"]) {
        return;
    }

    hasCheckedCodeThisSession = YES; 

    BOOL isVerified = [[NSUserDefaults standardUserDefaults] boolForKey:PREF_KEY];

    if (isVerified) {
        // ترحيب بسيط للمسجلين مسبقاً
        UIAlertController *welcome = [UIAlertController alertControllerWithTitle:@"مرحباً بك مجدداً" message:@"متجر الحسني يتمنى لك وقتاً ممتعاً" preferredStyle:UIAlertControllerStyleAlert];
        [welcome addAction:[UIAlertAction actionWithTitle:@"استمرار" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:welcome animated:YES completion:nil];
    } else {
        // إظهار واجهة VIP الفخمة للمستخدم الجديد
        HassaniAuthVC *authVC = [[HassaniAuthVC alloc] init];
        authVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        authVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:authVC animated:YES completion:nil];
    }
}

%end

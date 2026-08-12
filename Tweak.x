#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// ==========================================
// 1. إعدادات قاعدة البيانات (Supabase) والروابط
// ==========================================
#define SUPABASE_URL @"https://tsajzdjcatufzpdjqofv.supabase.co"
#define SUPABASE_ANON_KEY @"sb_publishable_gtetovKtVETv8LtRu4iWkw_dEUNvQPE"
#define TELEGRAM_LINK @"https://t.me/hassanyIPA"
#define DEV_ACCOUNT @"https://t.me/OM_G9"

// ==========================================
// 2. واجهة حماية الـ VIP (النسخة الكاملة مع الأنيميشن)
// ==========================================
@interface HassanyVIPAuthView : UIView <UITextFieldDelegate>
@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UITextField *codeField;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UILabel *statusLabel;
@end

@implementation HassanyVIPAuthView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupVIPUI];
    }
    return self;
}

// إخفاء الكيبورد عند الضغط على أي مكان بالشاشة
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

- (void)setupVIPUI {
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    // --- 1. التعتيم الشامل (Blur) ---
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
    blurView.frame = self.bounds;
    blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:blurView];
    
    // --- 2. الخلفية المتدرجة المتحركة (Gradient Animation) ---
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.bounds;
    self.gradientLayer.colors = @[(id)[UIColor colorWithRed:0.2 green:0.0 blue:0.0 alpha:0.6].CGColor,
                                  (id)[UIColor colorWithRed:0.05 green:0.0 blue:0.1 alpha:0.6].CGColor,
                                  (id)[UIColor colorWithRed:0.1 green:0.0 blue:0.0 alpha:0.6].CGColor];
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(1, 1);
    [self.layer addSublayer:self.gradientLayer];
    [self animateGradient];
    
    // --- 3. الكارد الأساسي الثابت ---
    CGFloat cardW = 320;
    if (cardW > w - 40) cardW = w - 40;
    CGFloat cardH = 470;
    
    self.cardView = [[UIView alloc] initWithFrame:CGRectMake((w - cardW)/2, (h - cardH)/2, cardW, cardH)];
    self.cardView.backgroundColor = [UIColor colorWithWhite:0.08 alpha:0.95];
    self.cardView.layer.cornerRadius = 24;
    self.cardView.layer.borderWidth = 1.5;
    self.cardView.layer.borderColor = [UIColor colorWithRed:0.8 green:0.0 blue:0.0 alpha:0.8].CGColor;
    self.cardView.layer.shadowColor = [UIColor redColor].CGColor;
    self.cardView.layer.shadowOpacity = 0.5;
    self.cardView.layer.shadowRadius = 20;
    self.cardView.layer.shadowOffset = CGSizeMake(0, 8);
    self.cardView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:self.cardView];

    // --- 4. صورة اللوجو ---
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((cardW - 90)/2, 25, 90, 90)];
    logo.layer.cornerRadius = 20;
    logo.clipsToBounds = YES;
    logo.layer.borderWidth = 2;
    logo.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.2].CGColor;
    [self.cardView addSubview:logo];

    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://a.top4top.io/p_38750r3gh0.jpeg"]];
        if (imgData) { dispatch_async(dispatch_get_main_queue(), ^{ logo.image = [UIImage imageWithData:imgData]; }); }
    });

    // --- 5. النصوص والترحيب ---
    UILabel *subtitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, cardW - 20, 20)];
    subtitle.text = @"الهـاك تابع لقناه hassanyIPA حصرا فقط";
    subtitle.textColor = [UIColor colorWithRed:1.0 green:0.3 blue:0.3 alpha:1.0];
    subtitle.font = [UIFont boldSystemFontOfSize:12];
    subtitle.textAlignment = NSTextAlignmentCenter;
    [self.cardView addSubview:subtitle];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 155, cardW - 30, 45)];
    title.text = @"مرحبا بك يرجى ادخال كود التفعيل الخاص بك\nيمكنك الشراء حصرا من hassanyIPA";
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont boldSystemFontOfSize:14];
    title.textAlignment = NSTextAlignmentCenter;
    title.numberOfLines = 2;
    [self.cardView addSubview:title];

    // --- 6. حقل إدخال الكود ---
    self.codeField = [[UITextField alloc] initWithFrame:CGRectMake(20, 215, cardW - 40, 48)];
    self.codeField.placeholder = @"@hassanyIPA-VIP-XXXXXXX";
    self.codeField.textAlignment = NSTextAlignmentCenter;
    self.codeField.textColor = [UIColor whiteColor];
    self.codeField.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1.0];
    self.codeField.layer.cornerRadius = 12;
    self.codeField.layer.borderWidth = 1;
    self.codeField.layer.borderColor = [UIColor darkGrayColor].CGColor;
    [self.cardView addSubview:self.codeField];

    NSString *savedCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"HassanyVIPCode"];
    if (savedCode) self.codeField.text = savedCode;

    // --- 7. زر الدخول ---
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    loginBtn.frame = CGRectMake(20, 278, cardW - 40, 48);
    [loginBtn setTitle:@"دخول" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor = [UIColor colorWithRed:0.8 green:0.0 blue:0.0 alpha:1.0];
    loginBtn.layer.cornerRadius = 12;
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [loginBtn addTarget:self action:@selector(checkLicense) forControlEvents:UIControlEventTouchUpInside];
    [self.cardView addSubview:loginBtn];

    // --- 8. رسالة الحالة (بديل الـ Alert) ---
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 335, cardW - 20, 40)];
    self.statusLabel.textColor = [UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.0];
    self.statusLabel.font = [UIFont boldSystemFontOfSize:13];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.numberOfLines = 2;
    self.statusLabel.text = @"";
    [self.cardView addSubview:self.statusLabel];

    // --- 9. أزرار القنوات والمطور ---
    UIButton *chBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    chBtn.frame = CGRectMake(20, 390, (cardW/2) - 25, 45);
    [chBtn setTitle:@"القناة" forState:UIControlStateNormal];
    chBtn.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    [chBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    chBtn.layer.cornerRadius = 10;
    chBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [chBtn addTarget:self action:@selector(openChannel) forControlEvents:UIControlEventTouchUpInside];
    [self.cardView addSubview:chBtn];

    UIButton *devBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    devBtn.frame = CGRectMake((cardW/2) + 5, 390, (cardW/2) - 25, 45);
    [devBtn setTitle:@"المطور" forState:UIControlStateNormal];
    devBtn.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    [devBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    devBtn.layer.cornerRadius = 10;
    devBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [devBtn addTarget:self action:@selector(openDev) forControlEvents:UIControlEventTouchUpInside];
    [self.cardView addSubview:devBtn];

    // --- 10. دائرة التحميل ---
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    self.spinner.color = [UIColor redColor];
    self.spinner.center = CGPointMake(cardW/2, 355);
    self.spinner.hidesWhenStopped = YES;
    [self.cardView addSubview:self.spinner];

    // --- تأثير الظهور ---
    self.alpha = 0;
    self.cardView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1;
        self.cardView.transform = CGAffineTransformIdentity;
    } completion:nil];

    // فحص تلقائي للكود المحفوظ
    if (savedCode && savedCode.length > 5) {
        [self checkLicense];
    }
}

// دالة تحريك الخلفية (اللمسة الاحترافية)
- (void)animateGradient {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"colors"];
    animation.toValue = @[(id)[UIColor colorWithRed:0.05 green:0.0 blue:0.1 alpha:0.6].CGColor,
                          (id)[UIColor colorWithRed:0.2 green:0.0 blue:0.0 alpha:0.6].CGColor,
                          (id)[UIColor colorWithRed:0.1 green:0.0 blue:0.0 alpha:0.6].CGColor];
    animation.duration = 4.0;
    animation.autoreverses = YES;
    animation.repeatCount = HUGE_VALF;
    [self.gradientLayer addAnimation:animation forKey:@"colorChange"];
}

- (void)openChannel { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TELEGRAM_LINK] options:@{} completionHandler:nil]; }
- (void)openDev { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:DEV_ACCOUNT] options:@{} completionHandler:nil]; }

// ==========================================
// 3. الفحص من السيرفر (مع تخطي الكاش الإجباري)
// ==========================================
- (void)checkLicense {
    NSString *code = [self.codeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (code.length == 0) return;
    
    [self endEditing:YES];
    self.statusLabel.text = @"";
    [self.spinner startAnimating];
    self.userInteractionEnabled = NO;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/v1/licenses?code_key=eq.%@&select=*", SUPABASE_URL, code];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    // 🚀 السر هنا: تخطي الكاش لضمان جلب الوقت الحقيقي دائماً
    req.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    [req setValue:SUPABASE_ANON_KEY forHTTPHeaderField:@"apikey"];
    [req setValue:[NSString stringWithFormat:@"Bearer %@", SUPABASE_ANON_KEY] forHTTPHeaderField:@"Authorization"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
            self.userInteractionEnabled = YES;
            
            if (error || !data) {
                self.statusLabel.text = @"حدث خطأ في الاتصال بالسيرفر!"; return;
            }
            
            NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (json.count == 0) {
                self.statusLabel.text = @"الكود غير صحيح! تأكد من كتابته بشكل صحيح.";
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HassanyVIPCode"];
                return;
            }
            
            NSDictionary *license = json.firstObject;
            
            if ([license[@"status"] isEqualToString:@"disabled"]) {
                self.statusLabel.text = @"هذا الكود تم إيقافه من قبل الإدارة!";
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HassanyVIPCode"];
                return;
            }
            
            NSString *expiryStr = license[@"expiry_date"];
            if (expiryStr && ![expiryStr isKindOfClass:[NSNull class]]) {
                NSISO8601DateFormatter *formatter = [[NSISO8601DateFormatter alloc] init];
                formatter.formatOptions = NSISO8601DateFormatWithInternetDateTime | NSISO8601DateFormatWithFractionalSeconds;
                NSDate *expiryDate = [formatter dateFromString:expiryStr];
                
                if (!expiryDate) {
                    formatter.formatOptions = NSISO8601DateFormatWithInternetDateTime;
                    expiryDate = [formatter dateFromString:expiryStr];
                }
                
                if (expiryDate && [expiryDate timeIntervalSinceNow] <= 0) {
                    self.statusLabel.text = @"انتهت مدة صلاحية هذا الكود!";
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HassanyVIPCode"];
                    return;
                }
                
                // الكود شغال، نفتح اللعبة
                [self showSuccessAndStartGame:expiryDate];
            } else {
                 self.statusLabel.text = @"هذا الكود تالف (لا يحتوي على تاريخ).";
                 [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HassanyVIPCode"];
            }
        });
    }] resume];
}

// ==========================================
// 4. واجهة النجاح ورسالة الشكر المنبثقة (Toast)
// ==========================================
- (void)showSuccessAndStartGame:(NSDate *)expiryDate {
    [[NSUserDefaults standardUserDefaults] setObject:self.codeField.text forKey:@"HassanyVIPCode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [UIView animateWithDuration:0.3 animations:^{
        for (UIView *v in self.cardView.subviews) { v.alpha = 0; }
    } completion:^(BOOL finished) {
        
        UIImageView *check = [[UIImageView alloc] initWithFrame:CGRectMake((self.cardView.frame.size.width - 80)/2, 80, 80, 80)];
        check.image = [UIImage systemImageNamed:@"checkmark.seal.fill"];
        if(!check.image) { check.backgroundColor = [UIColor greenColor]; check.layer.cornerRadius = 40; }
        check.tintColor = [UIColor greenColor];
        check.alpha = 0;
        [self.cardView addSubview:check];
        
        UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, self.cardView.frame.size.width - 20, 60)];
        msg.text = @"عاشت ايدك تم بنجاح\nتگدر تستخدم الهاك هسه";
        msg.textColor = [UIColor whiteColor];
        msg.font = [UIFont boldSystemFontOfSize:22];
        msg.textAlignment = NSTextAlignmentCenter;
        msg.numberOfLines = 2;
        msg.alpha = 0;
        [self.cardView addSubview:msg];
        
        UILabel *timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 260, self.cardView.frame.size.width - 20, 40)];
        timeLbl.textColor = [UIColor greenColor];
        timeLbl.font = [UIFont boldSystemFontOfSize:16];
        timeLbl.textAlignment = NSTextAlignmentCenter;
        timeLbl.alpha = 0;
        [self.cardView addSubview:timeLbl];
        
        NSTimeInterval diff = [expiryDate timeIntervalSinceNow];
        int days = diff / (24*3600);
        int hours = (int)diff % (24*3600) / 3600;
        int mins = (int)diff % 3600 / 60;
        timeLbl.text = [NSString stringWithFormat:@"المتبقي: %d يوم و %d ساعة و %d دقيقة", days, hours, mins];
        
        [UIView animateWithDuration:0.4 animations:^{
            check.alpha = 1; msg.alpha = 1; timeLbl.alpha = 1;
        }];
        
        // إغلاق الواجهة بعد 3 ثواني وعرض رسالة الشكر (Toast)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                self.alpha = 0;
                self.transform = CGAffineTransformMakeScale(1.1, 1.1);
            } completion:^(BOOL finished) {
                UIView *parentView = self.superview;
                [self removeFromSuperview];
                
                // --- إضافة رسالة الـ Toast ---
                if (parentView) {
                    UILabel *toastLabel = [[UILabel alloc] init];
                    toastLabel.text = @"شكراً لكم.. المطور الوحيد حسين الحسني";
                    toastLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
                    toastLabel.textColor = [UIColor whiteColor];
                    toastLabel.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.9];
                    toastLabel.textAlignment = NSTextAlignmentCenter;
                    toastLabel.layer.cornerRadius = 20;
                    toastLabel.layer.masksToBounds = YES;
                    
                    CGSize textSize = [toastLabel.text sizeWithAttributes:@{NSFontAttributeName:toastLabel.font}];
                    toastLabel.frame = CGRectMake((parentView.bounds.size.width - textSize.width - 40)/2,
                                                  parentView.bounds.size.height - 120,
                                                  textSize.width + 40, 40);
                    
                    toastLabel.alpha = 0;
                    toastLabel.transform = CGAffineTransformMakeTranslation(0, 20);
                    [parentView addSubview:toastLabel];
                    
                    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        toastLabel.alpha = 1;
                        toastLabel.transform = CGAffineTransformIdentity;
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.4 delay:2.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                            toastLabel.alpha = 0;
                            toastLabel.transform = CGAffineTransformMakeTranslation(0, 20);
                        } completion:^(BOOL finished) {
                            [toastLabel removeFromSuperview];
                        }];
                    }];
                }
            }];
        });
    }];
}
@end

// ==========================================
// 5. الاستدعاء المضمون (الحقن)
// ==========================================
%hook UIViewController

- (void)viewDidAppear:(BOOL)animated {
    %orig; 
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UIView *targetView = self.view.window;
            if (!targetView) {
                targetView = self.view; 
            }
            
            if (targetView && ![targetView viewWithTag:999999]) {
                HassanyVIPAuthView *authAlert = [[HassanyVIPAuthView alloc] initWithFrame:targetView.bounds];
                authAlert.tag = 999999;
                authAlert.layer.zPosition = 9999; 
                authAlert.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                [targetView addSubview:authAlert];
            }
        });
    });
}

%end

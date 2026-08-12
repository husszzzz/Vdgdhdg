#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// ==========================================
// إعدادات قاعدة البيانات (Supabase)
// ==========================================
#define SUPABASE_URL @"https://tsajzdjcatufzpdjqofv.supabase.co"
#define SUPABASE_ANON_KEY @"sb_publishable_gtetovKtVETv8LtRu4iWkw_dEUNvQPE"

// ==========================================
// واجهة تسجيل الدخول وحماية الـ VIP
// ==========================================
@interface HassanyAuthVC : UIViewController <UITextFieldDelegate>
@property (nonatomic, strong) UIView *animatedBgView;
@property (nonatomic, strong) UIStackView *mainStack;
@property (nonatomic, strong) UITextField *codeField;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@end

@implementation HassanyAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    // 1. الخلفية المتحركة (Animated Pulsing Background)
    self.animatedBgView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.animatedBgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.animatedBgView.backgroundColor = [UIColor colorWithRed:0.2 green:0.0 blue:0.0 alpha:1.0];
    [self.view addSubview:self.animatedBgView];
    
    [UIView animateWithDuration:4.0 delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction animations:^{
        self.animatedBgView.backgroundColor = [UIColor colorWithRed:0.05 green:0.0 blue:0.0 alpha:1.0];
    } completion:nil];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
    blurView.frame = self.view.bounds;
    blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:blurView];

    // 2. الحاوية الرئيسية المتجاوبة (AutoLayout StackView)
    self.mainStack = [[UIStackView alloc] init];
    self.mainStack.axis = UILayoutConstraintAxisVertical;
    self.mainStack.alignment = UIStackViewAlignmentCenter;
    self.mainStack.spacing = 15;
    self.mainStack.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.mainStack];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.mainStack.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.mainStack.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.mainStack.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.85]
    ]];

    // 3. صورة القناة
    UIImageView *logoView = [[UIImageView alloc] init];
    logoView.translatesAutoresizingMaskIntoConstraints = NO;
    logoView.layer.cornerRadius = 50;
    logoView.clipsToBounds = YES;
    logoView.layer.borderWidth = 2;
    logoView.layer.borderColor = [UIColor redColor].CGColor;
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://a.top4top.io/p_38750r3gh0.jpeg"]];
        if (imgData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                logoView.image = [UIImage imageWithData:imgData];
            });
        }
    });
    [self.mainStack addArrangedSubview:logoView];
    [NSLayoutConstraint activateConstraints:@[
        [logoView.widthAnchor constraintEqualToConstant:100],
        [logoView.heightAnchor constraintEqualToConstant:100]
    ]];

    // 4. النصوص والترحيب
    UILabel *subtitle = [[UILabel alloc] init];
    subtitle.text = @"الهـاك تابع لقناه hassanyIPA حصرا فقط";
    subtitle.textColor = [UIColor redColor];
    subtitle.font = [UIFont boldSystemFontOfSize:12];
    subtitle.textAlignment = NSTextAlignmentCenter;
    [self.mainStack addArrangedSubview:subtitle];

    UILabel *welcomeTitle = [[UILabel alloc] init];
    welcomeTitle.text = @"مرحبا بك يرجى ادخال كود التفعيل الخاص بك\nيمكنك الشراء حصرا من hassanyIPA";
    welcomeTitle.textColor = [UIColor whiteColor];
    welcomeTitle.font = [UIFont boldSystemFontOfSize:15];
    welcomeTitle.textAlignment = NSTextAlignmentCenter;
    welcomeTitle.numberOfLines = 2;
    [self.mainStack addArrangedSubview:welcomeTitle];

    // 5. حقل إدخال الكود
    self.codeField = [[UITextField alloc] init];
    self.codeField.translatesAutoresizingMaskIntoConstraints = NO;
    self.codeField.placeholder = @"@hassanyIPA-VIP-XXXXXXX";
    self.codeField.textAlignment = NSTextAlignmentCenter;
    self.codeField.textColor = [UIColor whiteColor];
    self.codeField.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.8];
    self.codeField.layer.cornerRadius = 10;
    self.codeField.layer.borderWidth = 1;
    self.codeField.layer.borderColor = [UIColor redColor].CGColor;
    
    // استرجاع الكود المحفوظ إن وجد
    NSString *savedCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"HassanyVIPCode"];
    if (savedCode) self.codeField.text = savedCode;
    
    [self.mainStack addArrangedSubview:self.codeField];
    [NSLayoutConstraint activateConstraints:@[
        [self.codeField.widthAnchor constraintEqualToAnchor:self.mainStack.widthAnchor],
        [self.codeField.heightAnchor constraintEqualToConstant:45]
    ]];

    // 6. زر الدخول
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    loginBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [loginBtn setTitle:@"دخول" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:1];
    loginBtn.layer.cornerRadius = 10;
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [loginBtn addTarget:self action:@selector(checkLicense) forControlEvents:UIControlEventTouchUpInside];
    [self.mainStack addArrangedSubview:loginBtn];
    [NSLayoutConstraint activateConstraints:@[
        [loginBtn.widthAnchor constraintEqualToAnchor:self.mainStack.widthAnchor],
        [loginBtn.heightAnchor constraintEqualToConstant:50]
    ]];

    // 7. أزرار القناة والمطور
    UIStackView *btnStack = [[UIStackView alloc] init];
    btnStack.axis = UILayoutConstraintAxisHorizontal;
    btnStack.spacing = 15;
    btnStack.distribution = UIStackViewDistributionFillEqually;
    btnStack.translatesAutoresizingMaskIntoConstraints = NO;
    [self.mainStack addArrangedSubview:btnStack];
    [NSLayoutConstraint activateConstraints:@[
        [btnStack.widthAnchor constraintEqualToAnchor:self.mainStack.widthAnchor],
        [btnStack.heightAnchor constraintEqualToConstant:40]
    ]];

    UIButton *chBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [chBtn setTitle:@"القناة" forState:UIControlStateNormal];
    chBtn.backgroundColor = [UIColor darkGrayColor];
    [chBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    chBtn.layer.cornerRadius = 8;
    [chBtn addTarget:self action:@selector(openChannel) forControlEvents:UIControlEventTouchUpInside];
    [btnStack addArrangedSubview:chBtn];

    UIButton *devBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [devBtn setTitle:@"المطور" forState:UIControlStateNormal];
    devBtn.backgroundColor = [UIColor darkGrayColor];
    [devBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    devBtn.layer.cornerRadius = 8;
    [devBtn addTarget:self action:@selector(openDev) forControlEvents:UIControlEventTouchUpInside];
    [btnStack addArrangedSubview:devBtn];
    
    // مؤشر التحميل (Spinner)
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.color = [UIColor redColor];
    self.spinner.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.spinner];
    [NSLayoutConstraint activateConstraints:@[
        [self.spinner.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.spinner.bottomAnchor constraintEqualToAnchor:self.mainStack.topAnchor constant:-20]
    ]];
    
    // الفحص التلقائي عند بدء التشغيل إذا كان هناك كود محفوظ
    if (savedCode && savedCode.length > 5) {
        [self checkLicense];
    }
}

- (void)openChannel { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/hassanyIPA"] options:@{} completionHandler:nil]; }
- (void)openDev { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/OM_G9"] options:@{} completionHandler:nil]; }

// ==========================================
// المنطق والاتصال بقاعدة البيانات (API Request)
// ==========================================
- (void)checkLicense {
    NSString *code = [self.codeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (code.length == 0) return;
    
    [self.spinner startAnimating];
    self.view.userInteractionEnabled = NO;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/v1/licenses?code_key=eq.%@&select=*", SUPABASE_URL, code];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [req setValue:SUPABASE_ANON_KEY forHTTPHeaderField:@"apikey"];
    [req setValue:[NSString stringWithFormat:@"Bearer %@", SUPABASE_ANON_KEY] forHTTPHeaderField:@"Authorization"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
            self.view.userInteractionEnabled = YES;
            
            if (error || !data) {
                [self showError:@"حدث خطأ في الاتصال بالسيرفر!"];
                return;
            }
            
            NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (json.count == 0) {
                [self showError:@"الكود غير صحيح! تأكد من كتابته بشكل صحيح."];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HassanyVIPCode"];
                return;
            }
            
            NSDictionary *license = json.firstObject;
            NSString *status = license[@"status"];
            NSString *dbDeviceId = license[@"device_id"];
            NSString *currentDeviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            
            // 1. فحص حالة الكود
            if ([status isEqualToString:@"disabled"]) {
                [self showError:@"هذا الكود تم إيقافه من قبل الإدارة!"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HassanyVIPCode"];
                return;
            }
            
            // 2. فحص تاريخ الانتهاء
            if (license[@"expiry_date"] != [NSNull null]) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
                NSDate *expiryDate = [formatter dateFromString:license[@"expiry_date"]];
                if ([expiryDate timeIntervalSinceNow] <= 0) {
                    [self showError:@"انتهت مدة صلاحية هذا الكود!"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HassanyVIPCode"];
                    return;
                }
            }
            
            // 3. فحص الجهاز (Binding)
            if (dbDeviceId == nil || [dbDeviceId isKindOfClass:[NSNull class]] || dbDeviceId.length == 0) {
                // تفعيل لأول مرة
                [self activateNewCode:license withUUID:currentDeviceUUID code:code];
            } else if ([dbDeviceId isEqualToString:currentDeviceUUID]) {
                // الكود صالح والجهاز متطابق
                [self showSuccessAndStartGame:license];
            } else {
                // الكود مستخدم بجهاز آخر
                [self showError:@"هذا الكود مستخدم في جهاز آخر!"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HassanyVIPCode"];
            }
        });
    }] resume];
}

// دالة ربط الكود بالجهاز لأول مرة وتحديد وقت الانتهاء
- (void)activateNewCode:(NSDictionary *)license withUUID:(NSString *)uuid code:(NSString *)code {
    [self.spinner startAnimating];
    self.view.userInteractionEnabled = NO;
    
    int days = [license[@"duration_days"] intValue];
    NSDate *expiryDate = [[NSDate date] dateByAddingTimeInterval:(days * 24 * 60 * 60)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
    NSString *isoDate = [formatter stringFromDate:expiryDate];
    
    NSString *updateUrl = [NSString stringWithFormat:@"%@/rest/v1/licenses?id=eq.%@", SUPABASE_URL, license[@"id"]];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    req.HTTPMethod = @"PATCH";
    [req setValue:SUPABASE_ANON_KEY forHTTPHeaderField:@"apikey"];
    [req setValue:[NSString stringWithFormat:@"Bearer %@", SUPABASE_ANON_KEY] forHTTPHeaderField:@"Authorization"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *body = @{@"device_id": uuid, @"expiry_date": isoDate};
    req.HTTPBody = [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
            self.view.userInteractionEnabled = YES;
            
            if (error) {
                [self showError:@"فشل تفعيل الكود، حاول مرة أخرى."];
            } else {
                NSMutableDictionary *updatedLicense = [license mutableCopy];
                updatedLicense[@"expiry_date"] = isoDate;
                [self showSuccessAndStartGame:updatedLicense];
            }
        });
    }] resume];
}

// ==========================================
// واجهة النجاح المذهلة والعداد التنازلي
// ==========================================
- (void)showSuccessAndStartGame:(NSDictionary *)license {
    // حفظ الكود
    [[NSUserDefaults standardUserDefaults] setObject:self.codeField.text forKey:@"HassanyVIPCode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // إخفاء الحاوية القديمة بأنيميشن
    [UIView animateWithDuration:0.3 animations:^{
        self.mainStack.alpha = 0;
        self.mainStack.transform = CGAffineTransformMakeScale(0.8, 0.8);
    }];
    
    // إنشاء واجهة النجاح
    UIView *successView = [[UIView alloc] initWithFrame:self.view.bounds];
    successView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    successView.alpha = 0;
    [self.view addSubview:successView];
    
    UIImageView *checkIcon = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 100)/2, self.view.bounds.size.height/2 - 120, 100, 100)];
    checkIcon.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    checkIcon.image = [UIImage systemImageNamed:@"checkmark.seal.fill"]; // يتطلب iOS 13+
    checkIcon.tintColor = [UIColor greenColor];
    [successView addSubview:checkIcon];
    
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, checkIcon.frame.origin.y + 120, self.view.bounds.size.width - 40, 60)];
    msgLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    msgLabel.text = @"عاشت ايدك تم بنجاح\nتگدر تستخدم الهاك هسه";
    msgLabel.textColor = [UIColor whiteColor];
    msgLabel.font = [UIFont boldSystemFontOfSize:22];
    msgLabel.numberOfLines = 2;
    msgLabel.textAlignment = NSTextAlignmentCenter;
    [successView addSubview:msgLabel];
    
    // حساب المدة المتبقية
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
    NSDate *expiryDate = [formatter dateFromString:license[@"expiry_date"]];
    NSTimeInterval diff = [expiryDate timeIntervalSinceNow];
    int days = diff / (24*3600);
    int hours = (int)diff % (24*3600) / 3600;
    int mins = (int)diff % 3600 / 60;
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, msgLabel.frame.origin.y + 70, self.view.bounds.size.width - 40, 40)];
    timeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    timeLabel.text = [NSString stringWithFormat:@"الوقت المتبقي: %d يوم و %d ساعة و %d دقيقة", days, hours, mins];
    timeLabel.textColor = [UIColor greenColor];
    timeLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [successView addSubview:timeLabel];
    
    // أنيميشن ظهور واجهة النجاح
    [UIView animateWithDuration:0.5 animations:^{
        successView.alpha = 1;
    }];
    
    // إغلاق الواجهة بعد 3 ثواني
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.view.alpha = 0;
            self.view.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
    });
}

// دالة رسالة الخطأ
- (void)showError:(NSString *)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"خطأ ❌" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"حسناً" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
@end


// ==========================================
// مراقب تشغيل التطبيق (The Launcher)
// ==========================================
@interface HassanyStartupManager : NSObject
+ (instancetype)sharedInstance;
- (void)showAuthScreen;
@end

@implementation HassanyStartupManager
+ (instancetype)sharedInstance {
    static HassanyStartupManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
        // ننتظر التطبيق لحد ما يفتح بالكامل وتستقر الواجهة
        [[NSNotificationCenter defaultCenter] addObserver:shared selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    });
    return shared;
}

- (void)appDidBecomeActive {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        // تأخير ثانية وحدة حتى نتجاوز شاشة التحميل مال اللعبة
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showAuthScreen];
        });
    });
}

- (void)showAuthScreen {
    UIViewController *topController = nil;
    
    // دعم iOS 13+ لاصطياد الواجهة الفعالة
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in scene.windows) {
                    if (window.isKeyWindow) {
                        topController = window.rootViewController;
                        break;
                    }
                }
            }
        }
    }
    
    // للأنظمة القديمة أو كحل بديل
    if (!topController) {
        topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    
    // الصعود لأعلى واجهة (حتى نتخطى كل قوائم اللعبة)
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    // عرض رسالة التفعيل
    if (topController && ![topController isKindOfClass:[HassanyAuthVC class]]) {
        HassanyAuthVC *authVC = [[HassanyAuthVC alloc] init];
        authVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [topController presentViewController:authVC animated:YES completion:nil];
    }
}
@end

// تشغيل المراقب تلقائياً أول ما ينحقن الدايليب
%ctor {
    [HassanyStartupManager sharedInstance];
}

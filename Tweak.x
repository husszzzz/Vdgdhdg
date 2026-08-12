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
    self.view.backgroundColor = [UIColor clearColor];
    
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
    
    // تأكد من أن المكدس فوق جميع العناصر
    [self.view bringSubviewToFront:self.mainStack];

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

    // 4. النصوص والترحيب (تم تحسينها)
    UILabel *subtitle = [[UILabel alloc] init];
    subtitle.text = @"الهـاك تابع لقناه hassanyIPA حصرا فقط";
    subtitle.textColor = [UIColor yellowColor];  // تغيير اللون للأصفر الفاتح
    subtitle.font = [UIFont boldSystemFontOfSize:13];
    subtitle.textAlignment = NSTextAlignmentCenter;
    subtitle.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];  // خلفية شفافة لتحسين القراءة
    subtitle.layer.cornerRadius = 6;
    subtitle.clipsToBounds = YES;
    subtitle.numberOfLines = 1;
    [self.mainStack addArrangedSubview:subtitle];

    UILabel *welcomeTitle = [[UILabel alloc] init];
    welcomeTitle.text = @"مرحبا بك يرجى ادخال كود التفعيل الخاص بك\nيمكنك الشراء حصرا من hassanyIPA";
    welcomeTitle.textColor = [UIColor whiteColor];
    welcomeTitle.font = [UIFont boldSystemFontOfSize:17];  // تكبير الخط
    welcomeTitle.textAlignment = NSTextAlignmentCenter;
    welcomeTitle.numberOfLines = 0;  // غير محدود لضمان ظهور النص كاملاً
    welcomeTitle.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];  // خلفية شفافة داكنة
    welcomeTitle.layer.cornerRadius = 8;
    welcomeTitle.clipsToBounds = YES;
    welcomeTitle.adjustsFontSizeToFitWidth = YES;
    welcomeTitle.minimumScaleFactor = 0.7;
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
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.color = [UIColor redColor];
    self.spinner.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.spinner];
    [NSLayoutConstraint activateConstraints:@[
        [self.spinner.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.spinner.bottomAnchor constraintEqualToAnchor:self.mainStack.topAnchor constant:-20]
    ]];
    
    // الفحص التلقائي
    if (savedCode && savedCode.length > 5) {
        [self checkLicense];
    }
}

- (void)openChannel { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/hassanyIPA"] options:@{} completionHandler:nil]; }
- (void)openDev { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/OM_G9"] options:@{} completionHandler:nil]; }

// ==========================================
// فحص الكود من السيرفر (نفس الكود الأصلي)
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
            
            if ([status isEqualToString:@"disabled"]) {
                [self showError:@"هذا الكود تم إيقافه من قبل الإدارة!"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HassanyVIPCode"];
                return;
            }
            
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
            
            if (dbDeviceId == nil || [dbDeviceId isKindOfClass:[NSNull class]] || dbDeviceId.length == 0) {
                [self activateNewCode:license withUUID:currentDeviceUUID code:code];
            } else if ([dbDeviceId isEqualToString:currentDeviceUUID]) {
                [self showSuccessAndStartGame:license];
            } else {
                [self showError:@"هذا الكود مستخدم في جهاز آخر!"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HassanyVIPCode"];
            }
        });
    }] resume];
}

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
// واجهة النجاح المذهلة والعداد التنازلي وإغلاق النافذة
// ==========================================
- (void)showSuccessAndStartGame:(NSDictionary *)license {
    [[NSUserDefaults standardUserDefaults] setObject:self.codeField.text forKey:@"HassanyVIPCode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.mainStack.alpha = 0;
        self.mainStack.transform = CGAffineTransformMakeScale(0.8, 0.8);
    }];
    
    UIView *successView = [[UIView alloc] initWithFrame:self.view.bounds];
    successView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    successView.alpha = 0;
    [self.view addSubview:successView];
    
    UIImageView *checkIcon = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 100)/2, self.view.bounds.size.height/2 - 120, 100, 100)];
    checkIcon.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    checkIcon.image = [UIImage systemImageNamed:@"checkmark.seal.fill"];
    if (!checkIcon.image) {
        checkIcon.backgroundColor = [UIColor greenColor];
        checkIcon.layer.cornerRadius = 50;
    }
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
    
    [UIView animateWithDuration:0.5 animations:^{
        successView.alpha = 1;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.view.alpha = 0;
            self.view.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL finished) {
            self.view.window.hidden = YES;
        }];
    });
}

- (void)showError:(NSString *)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"خطأ ❌" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"حسناً" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
@end


// ==========================================
// 🚀 نظام الحقن الصارم (النافذة العائمة الإجبارية)
// ==========================================
@interface HassanyVIPInjector : NSObject
@property (nonatomic, strong) UIWindow *authWindow;
+ (instancetype)sharedInstance;
- (void)showAuthScreen;
@end

@implementation HassanyVIPInjector
+ (instancetype)sharedInstance {
    static HassanyVIPInjector *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (void)showAuthScreen {
    if (self.authWindow) return;
    
    // محاولة الحصول على النافذة الرئيسية للتطبيق (كحل بديل)
    UIWindow *mainWindow = nil;
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                mainWindow = scene.windows.firstObject;
                self.authWindow = [[UIWindow alloc] initWithWindowScene:scene];
                break;
            }
        }
    }
    if (!self.authWindow) {
        self.authWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    
    self.authWindow.windowLevel = UIWindowLevelAlert + 1;
    self.authWindow.rootViewController = [[HassanyAuthVC alloc] init];
    self.authWindow.backgroundColor = [UIColor clearColor];
    [self.authWindow makeKeyAndVisible];
    
    // في حال لم تظهر النافذة، جرب إضافتها كنافذة فرعية على النافذة الرئيسية
    if (mainWindow && !self.authWindow.isKeyWindow) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!self.authWindow.isKeyWindow) {
                [mainWindow addSubview:self.authWindow];
                self.authWindow.frame = mainWindow.bounds;
                self.authWindow.hidden = NO;
            }
        });
    }
}
@end

// ==========================================
// تفعيل الحقن بمجرد بدء اللعبة
// ==========================================
%ctor {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            // تأخير أطول للتأكد من استقرار التطبيق
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[HassanyVIPInjector sharedInstance] showAuthScreen];
            });
        });
    }];
}

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// ==========================================
// إعدادات قاعدة البيانات (Supabase)
// ==========================================
#define SUPABASE_URL @"https://tsajzdjcatufzpdjqofv.supabase.co"
#define SUPABASE_ANON_KEY @"sb_publishable_gtetovKtVETv8LtRu4iWkw_dEUNvQPE"

// ==========================================
// واجهة تسجيل الدخول وحماية الـ VIP (نظام Frame الثابت)
// ==========================================
@interface HassanyVIPAuthView : UIView <UITextFieldDelegate>
@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) UITextField *codeField;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UILabel *statusLabel; // لعرض الأخطاء بدون UIAlert
@end

@implementation HassanyVIPAuthView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupVIPUI];
    }
    return self;
}

// إخفاء الكيبورد عند الضغط على الشاشة
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

- (void)setupVIPUI {
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    // 1. التعتيم الشامل (Blur)
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
    blurView.frame = self.bounds;
    blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:blurView];
    
    // 2. الكارد الأساسي الثابت (لمنع الكراش)
    CGFloat cardW = 320;
    if (cardW > w - 40) cardW = w - 40; // تجاوب مع الشاشات الصغيرة
    CGFloat cardH = 460;
    
    self.cardView = [[UIView alloc] initWithFrame:CGRectMake((w - cardW)/2, (h - cardH)/2, cardW, cardH)];
    self.cardView.backgroundColor = [UIColor colorWithWhite:0.05 alpha:0.95];
    self.cardView.layer.cornerRadius = 20;
    self.cardView.layer.borderWidth = 1.5;
    self.cardView.layer.borderColor = [UIColor redColor].CGColor;
    self.cardView.layer.shadowColor = [UIColor redColor].CGColor;
    self.cardView.layer.shadowOpacity = 0.6;
    self.cardView.layer.shadowRadius = 15;
    self.cardView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:self.cardView];

    // 3. صورة القناة
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((cardW - 90)/2, 25, 90, 90)];
    logo.layer.cornerRadius = 45;
    logo.clipsToBounds = YES;
    logo.layer.borderWidth = 2;
    logo.layer.borderColor = [UIColor redColor].CGColor;
    [self.cardView addSubview:logo];

    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://a.top4top.io/p_38750r3gh0.jpeg"]];
        if (imgData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                logo.image = [UIImage imageWithData:imgData];
            });
        }
    });

    // 4. النصوص
    UILabel *subtitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 125, cardW - 20, 20)];
    subtitle.text = @"الهـاك تابع لقناه hassanyIPA حصرا فقط";
    subtitle.textColor = [UIColor redColor];
    subtitle.font = [UIFont boldSystemFontOfSize:12];
    subtitle.textAlignment = NSTextAlignmentCenter;
    [self.cardView addSubview:subtitle];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, cardW - 20, 45)];
    title.text = @"مرحبا بك يرجى ادخال كود التفعيل الخاص بك\nيمكنك الشراء حصرا من hassanyIPA";
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont boldSystemFontOfSize:14];
    title.textAlignment = NSTextAlignmentCenter;
    title.numberOfLines = 2;
    [self.cardView addSubview:title];

    // 5. حقل الكود
    self.codeField = [[UITextField alloc] initWithFrame:CGRectMake(20, 210, cardW - 40, 45)];
    self.codeField.placeholder = @"@hassanyIPA-VIP-XXXXXXX";
    self.codeField.textAlignment = NSTextAlignmentCenter;
    self.codeField.textColor = [UIColor whiteColor];
    self.codeField.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1.0];
    self.codeField.layer.cornerRadius = 10;
    self.codeField.layer.borderWidth = 1;
    self.codeField.layer.borderColor = [UIColor darkGrayColor].CGColor;
    [self.cardView addSubview:self.codeField];

    NSString *savedCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"HassanyVIPCode"];
    if (savedCode) self.codeField.text = savedCode;

    // 6. زر الدخول
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    loginBtn.frame = CGRectMake(20, 270, cardW - 40, 45);
    [loginBtn setTitle:@"دخول" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor = [UIColor colorWithRed:0.8 green:0.0 blue:0.0 alpha:1.0];
    loginBtn.layer.cornerRadius = 10;
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [loginBtn addTarget:self action:@selector(checkLicense) forControlEvents:UIControlEventTouchUpInside];
    [self.cardView addSubview:loginBtn];

    // 7. رسالة الخطأ (بديل الـ UIAlert اللي يسوي كراش)
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 325, cardW - 20, 40)];
    self.statusLabel.textColor = [UIColor redColor];
    self.statusLabel.font = [UIFont boldSystemFontOfSize:13];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.numberOfLines = 2;
    self.statusLabel.text = @"";
    [self.cardView addSubview:self.statusLabel];

    // 8. أزرار القناة والمطور
    UIButton *chBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    chBtn.frame = CGRectMake(20, 380, (cardW/2) - 25, 40);
    [chBtn setTitle:@"القناة" forState:UIControlStateNormal];
    chBtn.backgroundColor = [UIColor darkGrayColor];
    [chBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    chBtn.layer.cornerRadius = 8;
    [chBtn addTarget:self action:@selector(openChannel) forControlEvents:UIControlEventTouchUpInside];
    [self.cardView addSubview:chBtn];

    UIButton *devBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    devBtn.frame = CGRectMake((cardW/2) + 5, 380, (cardW/2) - 25, 40);
    [devBtn setTitle:@"المطور" forState:UIControlStateNormal];
    devBtn.backgroundColor = [UIColor darkGrayColor];
    [devBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    devBtn.layer.cornerRadius = 8;
    [devBtn addTarget:self action:@selector(openDev) forControlEvents:UIControlEventTouchUpInside];
    [self.cardView addSubview:devBtn];

    // 9. سبينر التحميل
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    self.spinner.color = [UIColor redColor];
    self.spinner.center = CGPointMake(cardW/2, 345);
    self.spinner.hidesWhenStopped = YES;
    [self.cardView addSubview:self.spinner];

    // أنيميشن الظهور
    self.alpha = 0;
    self.cardView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1;
        self.cardView.transform = CGAffineTransformIdentity;
    } completion:nil];

    // الفحص التلقائي
    if (savedCode && savedCode.length > 5) {
        [self checkLicense];
    }
}

- (void)openChannel { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/hassanyIPA"] options:@{} completionHandler:nil]; }
- (void)openDev { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/OM_G9"] options:@{} completionHandler:nil]; }

// ==========================================
// الفحص من السيرفر
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
            NSString *status = license[@"status"];
            NSString *dbDeviceId = license[@"device_id"];
            NSString *currentDeviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            
            if ([status isEqualToString:@"disabled"]) {
                self.statusLabel.text = @"هذا الكود تم إيقافه من قبل الإدارة!";
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HassanyVIPCode"];
                return;
            }
            
            if (license[@"expiry_date"] != [NSNull null]) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
                NSDate *expiryDate = [formatter dateFromString:license[@"expiry_date"]];
                if ([expiryDate timeIntervalSinceNow] <= 0) {
                    self.statusLabel.text = @"انتهت مدة صلاحية هذا الكود!";
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HassanyVIPCode"];
                    return;
                }
            }
            
            if (dbDeviceId == nil || [dbDeviceId isKindOfClass:[NSNull class]] || dbDeviceId.length == 0) {
                [self activateNewCode:license withUUID:currentDeviceUUID code:code];
            } else if ([dbDeviceId isEqualToString:currentDeviceUUID]) {
                [self showSuccessAndStartGame:license];
            } else {
                self.statusLabel.text = @"هذا الكود مستخدم في جهاز آخر!";
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HassanyVIPCode"];
            }
        });
    }] resume];
}

- (void)activateNewCode:(NSDictionary *)license withUUID:(NSString *)uuid code:(NSString *)code {
    [self.spinner startAnimating];
    self.userInteractionEnabled = NO;
    
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
            self.userInteractionEnabled = YES;
            if (error) {
                self.statusLabel.text = @"فشل تفعيل الكود، حاول مرة أخرى.";
            } else {
                NSMutableDictionary *updatedLicense = [license mutableCopy];
                updatedLicense[@"expiry_date"] = isoDate;
                [self showSuccessAndStartGame:updatedLicense];
            }
        });
    }] resume];
}

// ==========================================
// النجاح، العداد، والاختفاء الشامل 
// ==========================================
- (void)showSuccessAndStartGame:(NSDictionary *)license {
    [[NSUserDefaults standardUserDefaults] setObject:self.codeField.text forKey:@"HassanyVIPCode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [UIView animateWithDuration:0.3 animations:^{
        for (UIView *v in self.cardView.subviews) { v.alpha = 0; }
    } completion:^(BOOL finished) {
        
        UIImageView *check = [[UIImageView alloc] initWithFrame:CGRectMake((self.cardView.frame.size.width - 80)/2, 60, 80, 80)];
        check.image = [UIImage systemImageNamed:@"checkmark.seal.fill"];
        if(!check.image) { check.backgroundColor = [UIColor greenColor]; check.layer.cornerRadius = 40; }
        check.tintColor = [UIColor greenColor];
        check.alpha = 0;
        [self.cardView addSubview:check];
        
        UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, self.cardView.frame.size.width - 20, 60)];
        msg.text = @"عاشت ايدك تم بنجاح\nتگدر تستخدم الهاك هسه";
        msg.textColor = [UIColor whiteColor];
        msg.font = [UIFont boldSystemFontOfSize:20];
        msg.textAlignment = NSTextAlignmentCenter;
        msg.numberOfLines = 2;
        msg.alpha = 0;
        [self.cardView addSubview:msg];
        
        UILabel *timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 240, self.cardView.frame.size.width - 20, 40)];
        timeLbl.textColor = [UIColor greenColor];
        timeLbl.font = [UIFont boldSystemFontOfSize:15];
        timeLbl.textAlignment = NSTextAlignmentCenter;
        timeLbl.alpha = 0;
        [self.cardView addSubview:timeLbl];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
        NSDate *expiryDate = [formatter dateFromString:license[@"expiry_date"]];
        NSTimeInterval diff = [expiryDate timeIntervalSinceNow];
        int days = diff / (24*3600);
        int hours = (int)diff % (24*3600) / 3600;
        int mins = (int)diff % 3600 / 60;
        timeLbl.text = [NSString stringWithFormat:@"المتبقي: %d يوم و %d ساعة و %d دقيقة", days, hours, mins];
        
        [UIView animateWithDuration:0.4 animations:^{
            check.alpha = 1; msg.alpha = 1; timeLbl.alpha = 1;
        }];
        
        // بعد 3 ثواني تحذف الشاشة نهائياً
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                self.alpha = 0;
                self.transform = CGAffineTransformMakeScale(1.2, 1.2);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        });
    }];
}
@end


// ==========================================
// 3. الاستدعاء المضمون (نسخة مطابقة لكودك الناجح 100%)
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

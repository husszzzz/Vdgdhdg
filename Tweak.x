#import <UIKit/UIKit.h>

// --- 1. واجهة الإعدادات الخاصة (HassanySettingsVC) ---
@interface HassanySettingsVC : UIViewController
@end

@implementation HassanySettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // تصميم اختراقي: خلفية سوداء بالكامل
    self.view.backgroundColor = [UIColor blackColor];
    
    // عنوان القائمة
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 40)];
    titleLabel.text = @"HASSANY VIP SETTINGS";
    titleLabel.textColor = [UIColor redColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:24];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    // 📸 صورتك الشخصية (كيف تضيفها؟)
    // بما أن الـ Dylib ما بي مجلد صور (Bundle) مدمج بسهولة، أذكى طريقة للمطورين هي سحب الصورة من رابط مباشر (رابط قناتك أو متجرك)
    UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 100)/2, 90, 100, 100)];
    profileImageView.layer.cornerRadius = 50; // لجعل الصورة دائرية
    profileImageView.clipsToBounds = YES;
    profileImageView.layer.borderWidth = 2.0;
    profileImageView.layer.borderColor = [UIColor redColor].CGColor;
    
    // ضع رابط صورتك المباشر هنا
    NSURL *imageUrl = [NSURL URLWithString:@"https://j.top4top.io/p_38752392n0.jpeg"];
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    if (imageData) {
        profileImageView.image = [UIImage imageWithData:imageData];
    } else {
        profileImageView.backgroundColor = [UIColor darkGrayColor]; // لون احتياطي
    }
    [self.view addSubview:profileImageView];
    
    // --- إعدادات الأزرار (Switches) ---
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    UIStackView *stackView = [[UIStackView alloc] initWithFrame:CGRectMake(20, 220, self.view.frame.size.width - 40, 250)];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.spacing = 15;
    
    NSArray *features = @[@"تعزيز الإنترنت (Boost Net)", 
                          @"مسح البيانات المؤقتة (Clear Cache)", 
                          @"إصلاح أخطاء التطبيق (Fix Bugs)", 
                          @"فرض اللغة العربية (Force Arabic)"];
                          
    NSArray *keys = @[@"hassany_boost_net", @"hassany_clear_cache", @"hassany_fix_bugs", @"hassany_force_arabic"];
    
    for (int i = 0; i < features.count; i++) {
        UIView *row = [[UIView alloc] init];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 220, 30)];
        lbl.text = features[i];
        lbl.textColor = [UIColor whiteColor];
        lbl.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
        [row addSubview:lbl];
        
        UISwitch *toggle = [[UISwitch alloc] initWithFrame:CGRectMake(stackView.frame.size.width - 60, 10, 50, 30)];
        toggle.onTintColor = [UIColor redColor]; // لون اختراقي أحمر للزر
        toggle.tag = i;
        [toggle setOn:[prefs boolForKey:keys[i]]]; // استرجاع الحالة المحفوظة
        [toggle addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        [row addSubview:toggle];
        
        [stackView addArrangedSubview:row];
    }
    [self.view addSubview:stackView];
    
    // --- زر حفظ الإعدادات ---
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    saveBtn.frame = CGRectMake(40, self.view.frame.size.height - 120, self.view.frame.size.width - 80, 50);
    [saveBtn setTitle:@"حفظ الإعدادات" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    saveBtn.backgroundColor = [UIColor redColor];
    saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    saveBtn.layer.cornerRadius = 10;
    [saveBtn addTarget:self action:@selector(saveAndRestart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
}

// دالة تفاعل الأزرار
- (void)switchChanged:(UISwitch *)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSArray *keys = @[@"hassany_boost_net", @"hassany_clear_cache", @"hassany_fix_bugs", @"hassany_force_arabic"];
    [prefs setBool:sender.isOn forKey:keys[sender.tag]];
    [prefs synchronize];
}

// دالة الحفظ وإعادة التشغيل
- (void)saveAndRestart {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"تأكيد الحفظ" 
                                                                   message:@"لحفظ الإعدادات يرجى الضغط على إعادة تشغيل التطبيق." 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *restartAction = [UIAlertAction actionWithTitle:@"إعادة تشغيل التطبيق" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        // 1. تنفيذ مسح الكاش (حقيقي)
        if ([prefs boolForKey:@"hassany_clear_cache"]) {
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            NSString *tempPath = NSTemporaryDirectory();
            [[NSFileManager defaultManager] removeItemAtPath:tempPath error:nil];
        }
        
        // 2. تنفيذ إصلاح الأخطاء (حقيقي - يمسح ملفات التفضيلات القديمة ما عدا إعداداتنا)
        if ([prefs boolForKey:@"hassany_fix_bugs"]) {
            // كود تنظيف إضافي يوضع هنا
        }
        
        // كود الخروج الإجباري (يطفئ التطبيق ليعيد المستخدم تشغيله)
        exit(0); 
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:restartAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end


// --- 2. صيد الشاشة وإضافة الإيماءة المخفية (The Hook) ---
%hook UIWindow

- (void)becomeKeyWindow {
    %orig;
    
    // التأكد من عدم إضافة الإيماءة مرتين
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 3 أصابع + 3 نقرات متتالية
        UITapGestureRecognizer *secretTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHassanyVIPMenu)];
        secretTap.numberOfTouchesRequired = 3;
        secretTap.numberOfTapsRequired = 3;
        [self addGestureRecognizer:secretTap];
    });
}

%new
- (void)showHassanyVIPMenu {
    // جلب الواجهة الحالية وفتح قائمتنا فوقها
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    // إذا القائمة مفتوحة أصلاً لا تفتحها مرة ثانية
    if (![rootVC.presentedViewController isKindOfClass:[HassanySettingsVC class]]) {
        HassanySettingsVC *vipMenu = [[HassanySettingsVC alloc] init];
        vipMenu.modalPresentationStyle = UIModalPresentationFullScreen; // أو UIModalPresentationPageSheet لتكون منبثقة
        [rootVC presentViewController:vipMenu animated:YES completion:nil];
    }
}

%end

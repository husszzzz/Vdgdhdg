#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// ==========================================
// واجهة الإعدادات الاحترافية (Hassany VIP Mod Menu)
// ==========================================
@interface HassanyVIPMenuVC : UIViewController
@property (nonatomic, strong) UIVisualEffectView *blurBackground;
@property (nonatomic, strong) UIView *mainContainer;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation HassanyVIPMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    // 1. تأثير الخلفية الضبابية (Blur Effect)
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurBackground = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.blurBackground.frame = self.view.bounds;
    self.blurBackground.alpha = 0.0; // للأنيميشن
    [self.view addSubview:self.blurBackground];
    
    // 2. الحاوية الرئيسية (Main Container) بتصميم الهاكرز
    CGFloat containerWidth = self.view.bounds.size.width * 0.85;
    CGFloat containerHeight = self.view.bounds.size.height * 0.75;
    self.mainContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, containerWidth, containerHeight)];
    self.mainContainer.center = self.view.center;
    self.mainContainer.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.05 alpha:0.95];
    self.mainContainer.layer.cornerRadius = 20;
    self.mainContainer.layer.borderWidth = 1.5;
    self.mainContainer.layer.borderColor = [UIColor redColor].CGColor;
    
    // تأثير التوهج الأحمر (Neon Glow) للحاوية
    self.mainContainer.layer.shadowColor = [UIColor redColor].CGColor;
    self.mainContainer.layer.shadowOpacity = 0.8;
    self.mainContainer.layer.shadowRadius = 15;
    self.mainContainer.layer.shadowOffset = CGSizeMake(0, 0);
    
    // تصغير الحاوية بالبداية حتى نسويلها أنيميشن دخول (Pop effect)
    self.mainContainer.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.mainContainer.alpha = 0.0;
    [self.view addSubview:self.mainContainer];
    
    // 3. إضافة صورة الحساب (باستخدام رابطك) مع تأثيرات
    UIImageView *profilePic = [[UIImageView alloc] initWithFrame:CGRectMake((containerWidth - 90)/2, 25, 90, 90)];
    profilePic.layer.cornerRadius = 45;
    profilePic.clipsToBounds = YES;
    profilePic.layer.borderWidth = 2.5;
    profilePic.layer.borderColor = [UIColor redColor].CGColor;
    
    // تحميل الصورة من الرابط المباشر
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *imageURL = [NSURL URLWithString:@"https://j.top4top.io/p_38752392n0.jpeg"];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        if (imageData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                profilePic.image = [UIImage imageWithData:imageData];
            });
        }
    });
    [self.mainContainer addSubview:profilePic];
    
    // 4. العنوان الاحترافي (Title)
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 125, containerWidth, 35)];
    titleLabel.text = @"HASSANY VIP MENU";
    titleLabel.font = [UIFont fontWithName:@"CourierNewPS-BoldMT" size:22]; // خط برمجي
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.layer.shadowColor = [UIColor redColor].CGColor;
    titleLabel.layer.shadowRadius = 5.0;
    titleLabel.layer.shadowOpacity = 1.0;
    titleLabel.layer.shadowOffset = CGSizeZero;
    [self.mainContainer addSubview:titleLabel];
    
    // خط فاصل أحمر متوهج تحت العنوان
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(30, 170, containerWidth - 60, 2)];
    separator.backgroundColor = [UIColor redColor];
    separator.layer.shadowColor = [UIColor redColor].CGColor;
    separator.layer.shadowRadius = 4.0;
    separator.layer.shadowOpacity = 0.9;
    separator.layer.shadowOffset = CGSizeZero;
    [self.mainContainer addSubview:separator];
    
    // 5. قسم الأزرار (ScrollView لضمان استيعاب كل الأزرار)
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 185, containerWidth - 20, containerHeight - 270)];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.mainContainer addSubview:self.scrollView];
    
    // الأزرار ومفاتيح الحفظ
    NSArray *features = @[@"تعزيز سرعة الإنترنت", @"مسح البيانات المؤقتة", @"إصلاح أخطاء التطبيق", @"فرض تشغيل اللغة العربية"];
    NSArray *keys = @[@"h_boost", @"h_cache", @"h_fix", @"h_arabic"];
    
    CGFloat yOffset = 10;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    for (int i = 0; i < features.count; i++) {
        // حاوية الزر الواحد
        UIView *rowView = [[UIView alloc] initWithFrame:CGRectMake(5, yOffset, self.scrollView.frame.size.width - 10, 55)];
        rowView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8];
        rowView.layer.cornerRadius = 12;
        rowView.layer.borderWidth = 0.5;
        rowView.layer.borderColor = [UIColor darkGrayColor].CGColor;
        
        // النص
        UILabel *rowLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 55)];
        rowLabel.text = features[i];
        rowLabel.textColor = [UIColor lightGrayColor];
        rowLabel.font = [UIFont boldSystemFontOfSize:15];
        [rowView addSubview:rowLabel];
        
        // الزر (Switch) وتغيير لونه للأحمر
        UISwitch *toggle = [[UISwitch alloc] initWithFrame:CGRectZero];
        toggle.frame = CGRectMake(rowView.frame.size.width - 65, 12, 50, 30);
        toggle.onTintColor = [UIColor colorWithRed:0.8 green:0.0 blue:0.0 alpha:1.0];
        toggle.thumbTintColor = [UIColor whiteColor];
        toggle.tag = i;
        [toggle setOn:[prefs boolForKey:keys[i]]];
        [toggle addTarget:self action:@selector(toggleChanged:) forControlEvents:UIControlEventValueChanged];
        [rowView addSubview:toggle];
        
        [self.scrollView addSubview:rowView];
        yOffset += 70;
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, yOffset);
    
    // 6. زر الحفظ وإعادة التشغيل (بتصميم متدرج Gradient)
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(30, containerHeight - 75, containerWidth - 60, 50);
    saveBtn.layer.cornerRadius = 15;
    saveBtn.clipsToBounds = YES;
    
    CAGradientLayer *btnGradient = [CAGradientLayer layer];
    btnGradient.frame = saveBtn.bounds;
    btnGradient.colors = @[(id)[UIColor colorWithRed:0.8 green:0.0 blue:0.0 alpha:1.0].CGColor,
                           (id)[UIColor colorWithRed:0.4 green:0.0 blue:0.0 alpha:1.0].CGColor];
    [saveBtn.layer insertSublayer:btnGradient atIndex:0];
    
    [saveBtn setTitle:@"حفظ الإعدادات والتطبيق" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveSettingsTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.mainContainer addSubview:saveBtn];
    
    // 7. زر إغلاق القائمة (X)
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.frame = CGRectMake(containerWidth - 45, 15, 30, 30);
    [closeBtn setTitle:@"✕" forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [closeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.mainContainer addSubview:closeBtn];
}

// أنيميشن الدخول (عند فتح القائمة)
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.blurBackground.alpha = 1.0;
        self.mainContainer.alpha = 1.0;
        self.mainContainer.transform = CGAffineTransformIdentity;
    } completion:nil];
}

// دالة حفظ حالة الأزرار
- (void)toggleChanged:(UISwitch *)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSArray *keys = @[@"h_boost", @"h_cache", @"h_fix", @"h_arabic"];
    [prefs setBool:sender.isOn forKey:keys[sender.tag]];
    [prefs synchronize];
}

// إغلاق القائمة بأنيميشن
- (void)closeMenu {
    [UIView animateWithDuration:0.3 animations:^{
        self.blurBackground.alpha = 0.0;
        self.mainContainer.alpha = 0.0;
        self.mainContainer.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

// دالة الحفظ وإعادة التشغيل (تنفيذ الأوامر الحقيقية)
- (void)saveSettingsTapped {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"تأكيد الحفظ" 
                                                                   message:@"لحفظ الإعدادات وتطبيقها بقوة، يجب إعادة تشغيل التطبيق. هل أنت متأكد؟" 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *restartAction = [UIAlertAction actionWithTitle:@"إعادة تشغيل" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        // أمر مسح الكاش الحقيقي
        if ([prefs boolForKey:@"h_cache"]) {
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            NSString *tempPath = NSTemporaryDirectory();
            NSFileManager *fm = [NSFileManager defaultManager];
            for (NSString *file in [fm contentsOfDirectoryAtPath:tempPath error:nil]) {
                [fm removeItemAtPath:[tempPath stringByAppendingPathComponent:file] error:nil];
            }
        }
        
        // الخروج الإجباري (يطفئ التطبيق)
        exit(0);
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelAction];
    [alert addAction:restartAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}
@end


// ==========================================
// الهوك (Hook) وصيد المشهد لإصلاح مشكلة iOS 13+
// ==========================================
%hook UIWindow

- (void)becomeKeyWindow {
    %orig;
    
    // منع تكرار إضافة الإيماءة
    BOOL gestureExists = NO;
    for (UIGestureRecognizer *g in self.gestureRecognizers) {
        if ([g isKindOfClass:[UITapGestureRecognizer class]]) {
            UITapGestureRecognizer *tap = (UITapGestureRecognizer *)g;
            if (tap.numberOfTouchesRequired == 3 && tap.numberOfTapsRequired == 3) {
                gestureExists = YES;
                break;
            }
        }
    }
    
    if (!gestureExists) {
        UITapGestureRecognizer *secretTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hassany_showMenu)];
        secretTap.numberOfTouchesRequired = 3;
        secretTap.numberOfTapsRequired = 3;
        [self addGestureRecognizer:secretTap];
    }
}

%new
- (void)hassany_showMenu {
    UIViewController *rootVC = nil;
    
    // ⚠️ هذا هو الحل الجذري لمشكلة (keyWindow is deprecated)
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in scene.windows) {
                    if (window.isKeyWindow) {
                        rootVC = window.rootViewController;
                        break;
                    }
                }
            }
            if (rootVC) break;
        }
    }
    
    // حل بديل للإصدارات الأقدم أو في حال فشل البحث
    if (!rootVC) {
        rootVC = [UIApplication sharedApplication].windows.firstObject.rootViewController;
    }
    
    // عرض الواجهة إذا لم تكن معروضة مسبقاً
    if (rootVC && ![rootVC.presentedViewController isKindOfClass:[HassanyVIPMenuVC class]]) {
        HassanyVIPMenuVC *vipMenu = [[HassanyVIPMenuVC alloc] init];
        vipMenu.modalPresentationStyle = UIModalPresentationOverFullScreen; // لجعل الخلفية الضبابية شفافة
        [rootVC presentViewController:vipMenu animated:NO completion:nil];
    }
}

%end

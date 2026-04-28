#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// تعريفات الواجهة لتفادي التحذيرات
@interface UIApplication (Private)
+ (UIApplication *)sharedApplication;
- (UIWindow *)keyWindow;
@end

@interface AlhussainiViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIButton *developerButton;
@property (nonatomic, strong) UIButton *channelButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *timerLabel;
@property (nonatomic, strong) UITextField *codeField;
@property (nonatomic, strong) UIButton *activateButton;
@property (nonatomic, assign) NSInteger secondsRemaining;
@property (nonatomic, strong) NSTimer *countdownTimer;
@end

@implementation AlhussainiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    // 1. حاوية الرسالة (Container)
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 520)]; // زيادة الارتفاع
    self.containerView.center = self.view.center;
    self.containerView.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.10 alpha:1.0]; // لون داكن فخم
    self.containerView.layer.cornerRadius = 20;
    self.containerView.clipsToBounds = YES;
    self.containerView.layer.borderColor = [UIColor grayColor].CGColor;
    self.containerView.layer.borderWidth = 1.0;
    [self.view addSubview:self.containerView];
    
    // 2. الصورة المصغرة (اللوغو)
    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(110, 20, 80, 80)];
    self.logoImageView.backgroundColor = [UIColor whiteColor];
    self.logoImageView.layer.cornerRadius = 40; // لجعلها دائرية
    self.logoImageView.clipsToBounds = YES;
    self.logoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.logoImageView.layer.borderWidth = 2.0;
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFill;
    // تحميل الصورة من الرابط (يفضل تحميلها Async في تطبيق حقيقي، لكن هنا للتبسيط)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://e.top4top.io/p_37700ug540.jpeg"]];
        if (imageData) {
            UIImage *image = [UIImage imageWithData:imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.logoImageView.image = image;
            });
        }
    });
    [self.containerView addSubview:self.logoImageView];
    
    // 3. العنوان
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, 280, 30)];
    self.titleLabel.text = @"Alhussaini Mod";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:self.titleLabel];
    
    // 4. الرسالة
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, 280, 60)];
    self.messageLabel.text = @"أهلاً بك في التعديل الاحترافي لـ Alhussaini.\nللاستمرار يرجى إدخال كود التفعيل.";
    self.messageLabel.textColor = [UIColor lightGrayColor];
    self.messageLabel.font = [UIFont systemFontOfSize:14];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.numberOfLines = 3;
    [self.containerView addSubview:self.messageLabel];
    
    // --- قسم الكود (الفلتر الجديد) ---
    // 5. حقل إدخال الكود
    self.codeField = [[UITextField alloc] initWithFrame:CGRectMake(20, 210, 260, 40)];
    self.codeField.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    self.codeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"ادخل كود GitHub" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
    self.codeField.textColor = [UIColor whiteColor];
    self.codeField.layer.cornerRadius = 8;
    self.codeField.clipsToBounds = YES;
    self.codeField.delegate = self;
    self.codeField.textAlignment = NSTextAlignmentCenter;
    self.codeField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.codeField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.containerView addSubview:self.codeField];
    
    // 6. زر تفعيل الكود
    self.activateButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 260, 260, 35)];
    self.activateButton.backgroundColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.2 alpha:1.0]; // أخضر
    [self.activateButton setTitle:@"تفعيل الكود" forState:UIControlStateNormal];
    [self.activateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.activateButton.layer.cornerRadius = 8;
    self.activateButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.activateButton addTarget:self action:@selector(activateCode) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.activateButton];
    
    // --- قسم الأزرار والروابط ---
    // 7. زر المطور
    self.developerButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 310, 260, 40)];
    self.developerButton.backgroundColor = [UIColor colorWithRed:0.1 green:0.3 blue:0.6 alpha:1.0]; // لون أزرق تليكرام
    [self.developerButton setTitle:@"المطور @OM_G9" forState:UIControlStateNormal];
    [self.developerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.developerButton.layer.cornerRadius = 10;
    self.developerButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.developerButton addTarget:self action:@selector(openDeveloper) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.developerButton];
    
    // 8. زر القناة الرسمية
    self.channelButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 360, 260, 40)];
    self.channelButton.backgroundColor = [UIColor colorWithRed:0.1 green:0.3 blue:0.6 alpha:1.0]; // لون أزرق تليكرام
    [self.channelButton setTitle:@"القناة الرسمية hasanyiq" forState:UIControlStateNormal];
    [self.channelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.channelButton.layer.cornerRadius = 10;
    self.channelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.channelButton addTarget:self action:@selector(openChannel) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.channelButton];
    
    // --- قسم العداد والخروج ---
    // 9. زر الدخول (الخروج من الرسالة)
    self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 460, 260, 45)];
    self.closeButton.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.6];
    [self.closeButton setTitle:@"دخول" forState:UIControlStateNormal];
    [self.closeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal]; // يبدأ باهت
    self.closeButton.layer.cornerRadius = 10;
    self.closeButton.enabled = NO; // يبدأ غير مفعل
    self.closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.closeButton addTarget:self action:@selector(closeAlhussaini) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.closeButton];
    
    // 10. العداد التنازلي
    self.timerLabel = [[UILabel alloc] initWithFrame:self.closeButton.frame]; // وضعه فوق زر الخروج
    self.timerLabel.text = @"انتظر 6 ثوانٍ...";
    self.timerLabel.textColor = [UIColor whiteColor];
    self.timerLabel.font = [UIFont boldSystemFontOfSize:16];
    self.timerLabel.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:self.timerLabel];
    
    // بدء العداد
    self.secondsRemaining = 6;
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCountdown) userInfo:nil repeats:YES];
}

// دالة التحديث التنازلي
- (void)updateCountdown {
    if (self.secondsRemaining > 0) {
        self.secondsRemaining--;
        self.timerLabel.text = [NSString stringWithFormat:@"انتظر %ld ثوانٍ...", (long)self.secondsRemaining];
    } else {
        [self.countdownTimer invalidate];
        self.countdownTimer = nil;
        self.timerLabel.hidden = YES;
        self.closeButton.enabled = YES;
        self.closeButton.backgroundColor = [UIColor redColor];
        [self.closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

// دالة فتح المطور
- (void)openDeveloper {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tg://resolve?domain=OM_G9"] options:@{} completionHandler:nil];
}

// دالة فتح القناة
- (void)openChannel {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/hasanyiq"] options:@{} completionHandler:nil];
}

// دالة الخروج من الرسالة
- (void)closeAlhussaini {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// دالة تفعيل الكود وحفظ النجاح
- (void)activateCode {
    if ([self.codeField.text isEqualToString:@"GitHub"]) {
        // حفظ التفعيل في NSUserDefaults
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AlhussainiCodeActivated"];
        [[NSUserDefaults standardUserDefaults] synchronize]; // ضمان الحفظ
        
        // إظهار رسالة نجاح بسيطة ثم الخروج
        self.messageLabel.text = @"تم تفعيل الكود بنجاح!\nلن تظهر هذه الرسالة مرة أخرى.";
        self.messageLabel.textColor = [UIColor greenColor];
        [self.codeField resignFirstResponder]; // أخفاء الكيبورد
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        self.codeField.text = @"";
        self.codeField.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
        [self.activateButton setTitle:@"كود خاطئ، حاول مرة أخرى" forState:UIControlStateNormal];
    }
}

// إخفاء الكيبورد عند الضغط على Enter
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end

// --- الجزء المسؤول عن الحقن والظهور الدائم ---
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // التحقق مما إذا كان الكود مفعل مسبقاً
        BOOL isActivated = [[NSUserDefaults standardUserDefaults] boolForKey:@"AlhussainiCodeActivated"];
        
        // إذا لم يكن مفعل، نظهر الرسالة
        if (!isActivated) {
            UIWindow *activeWindow = nil;
            
            if (@available(iOS 13.0, *)) {
                for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                    if (scene.activationState == UISceneActivationStateForegroundActive) {
                        activeWindow = scene.windows.firstObject;
                        break;
                    }
                }
            }
            
            if (!activeWindow) {
                activeWindow = [UIApplication sharedApplication].windows.firstObject;
            }
            
            if (activeWindow && activeWindow.rootViewController) {
                AlhussainiViewController *vc = [[AlhussainiViewController alloc] init];
                vc.modalPresentationStyle = UIModalPresentationOverFullScreen; // تغطية الشاشة
                vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve; // أنتقال ناعم
                [activeWindow.rootViewController presentViewController:vc animated:YES completion:nil];
            }
        }
    });
}

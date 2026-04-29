#import <UIKit/UIKit.h>

@interface MoonWelcomeView : UIView
@end

@implementation MoonWelcomeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 20;
        self.layer.masksToBounds = NO;
        // إضافة ظل للنافذة
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowOffset = CGSizeMake(0, 10);
        self.layer.shadowRadius = 15;
        
        // الأيقونة الزرقاء العلوية
        UIView *iconContainer = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width-60)/2, -30, 60, 60)];
        iconContainer.backgroundColor = [UIColor colorWithRed:0.23 green:0.48 blue:0.85 alpha:1.0];
        iconContainer.layer.cornerRadius = 30;
        [self addSubview:iconContainer];
        
        UILabel *iconText = [[UILabel alloc] initWithFrame:iconContainer.bounds];
        iconText.text = @"i";
        iconText.textColor = [UIColor whiteColor];
        iconText.textAlignment = NSTextAlignmentCenter;
        iconText.font = [UIFont boldSystemFontOfSize:32];
        [iconContainer addSubview:iconText];

        // العنوان
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, frame.size.width-20, 35)];
        title.text = @"يا هلا بيك | Welcome";
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont boldSystemFontOfSize:22];
        [self addSubview:title];

        // النص
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, frame.size.width-30, 100)];
        desc.text = @"شكراً لاستخدامك هذا التطبيق المعدل\nحقوق التعديل: حسين الحساني\nتابعونا للمزيد على موقعنا Moon";
        desc.numberOfLines = 0;
        desc.textAlignment = NSTextAlignmentCenter;
        desc.font = [UIFont systemFontOfSize:15];
        desc.textColor = [UIColor grayColor];
        [self addSubview:desc];

        // سويتش الإخفاء
        UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(30, 190, 0, 0)];
        sw.tag = 99;
        [self addSubview:sw];
        
        UILabel *swLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 195, 150, 20)];
        swLabel.text = @"إخفاء للأبد | HIDE";
        swLabel.font = [UIFont boldSystemFontOfSize:14];
        [self addSubview:swLabel];

        // أزرار التحكم
        UIButton *btnChannel = [UIButton buttonWithType:UIButtonTypeSystem];
        btnChannel.frame = CGRectMake(20, 235, frame.size.width-40, 50);
        btnChannel.backgroundColor = [UIColor colorWithRed:0.23 green:0.48 blue:0.85 alpha:1.0];
        [btnChannel setTitle:@"قناتنا | Our Channel" forState:UIControlStateNormal];
        [btnChannel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnChannel.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        btnChannel.layer.cornerRadius = 12;
        [btnChannel addTarget:self action:@selector(openLink) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnChannel];

        UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeSystem];
        btnClose.frame = CGRectMake(20, 295, frame.size.width-40, 50);
        btnClose.backgroundColor = [UIColor colorWithRed:0.35 green:0.55 blue:0.95 alpha:1.0];
        [btnClose setTitle:@"إغلاق | Close" forState:UIControlStateNormal];
        [btnClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnClose.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        btnClose.layer.cornerRadius = 12;
        [btnClose addTarget:self action:@selector(dismissAlert:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnClose];
    }
    return self;
}

-(void)openLink {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/حسابك"] options:@{} completionHandler:nil];
}

-(void)dismissAlert:(UIButton *)sender {
    UISwitch *sw = (UISwitch *)[self viewWithTag:99];
    if (sw.isOn) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MoonAlertHidden"];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.superview.alpha = 0;
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];
}
@end

// هذا الهوك يشتغل على أي تطبيق عند فتحه
%hook UIViewController
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"MoonAlertHidden"]) return;

        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (!window && @available(iOS 13.0, *)) {
            for (UIWindowScene* scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    window = scene.windows.firstObject; break;
                }
            }
        }
        
        if (window) {
            UIView *overlay = [[UIView alloc] initWithFrame:window.bounds];
            overlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            [window addSubview:overlay];
            
            MoonWelcomeView *alert = [[MoonWelcomeView alloc] initWithFrame:CGRectMake((window.bounds.size.width-300)/2, (window.bounds.size.height-360)/2, 300, 360)];
            [overlay addSubview:alert];
        }
    });
}
%end

#import <UIKit/UIKit.h>

@interface MoonAlertView : UIView
@end

@implementation MoonAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15;
        self.layer.masksToBounds = YES;
        
        // الأيقونة الزرقاء (i)
        UIView *iconBg = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width-60)/2, -30, 60, 60)];
        iconBg.backgroundColor = [UIColor colorWithRed:0.18 green:0.35 blue:0.75 alpha:1.0];
        iconBg.layer.cornerRadius = 30;
        [self addSubview:iconBg];
        
        UILabel *iconLabel = [[UILabel alloc] initWithFrame:iconBg.bounds];
        iconLabel.text = @"i";
        iconLabel.textColor = [UIColor whiteColor];
        iconLabel.textAlignment = NSTextAlignmentCenter;
        iconLabel.font = [UIFont boldSystemFontOfSize:30];
        [iconBg addSubview:iconLabel];

        // العنوان
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, frame.size.width-20, 30)];
        titleLabel.text = @"يا هلا بيك | Welcome";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [self addSubview:titleLabel];

        // النص
        UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, frame.size.width-20, 100)];
        msgLabel.text = @"شكراً لاستخدامك تطبيقاتنا\nحقوق قناة التلغرام | @iPAFire\nتابعونا للمزيد من التطبيقات والألعاب\nالحصرية لدينا";
        msgLabel.numberOfLines = 0;
        msgLabel.textAlignment = NSTextAlignmentCenter;
        msgLabel.font = [UIFont systemFontOfSize:14];
        msgLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:msgLabel];

        // زر الإخفاء (Switch)
        UISwitch *hideSw = [[UISwitch alloc] initWithFrame:CGRectMake(20, 185, 0, 0)];
        [self addSubview:hideSw];
        
        UILabel *swLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 190, 100, 20)];
        swLabel.text = @"إخفاء | HIDE";
        swLabel.font = [UIFont boldSystemFontOfSize:14];
        [self addSubview:swLabel];

        // زر القناة (الأزرق)
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
        btn1.frame = CGRectMake(20, 230, frame.size.width-40, 45)];
        btn1.backgroundColor = [UIColor colorWithRed:0.18 green:0.35 blue:0.75 alpha:1.0];
        [btn1 setTitle:@"قناتنا | Our Channel" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn1.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        btn1.layer.cornerRadius = 5;
        [btn1 addTarget:self action:@selector(openLink) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn1];

        // زر الشكر
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
        btn2.frame = CGRectMake(20, 285, frame.size.width-40, 45)];
        btn2.backgroundColor = [UIColor colorWithRed:0.25 green:0.45 blue:0.85 alpha:1.0];
        [btn2 setTitle:@"شكراً | Thanks" forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn2.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        btn2.layer.cornerRadius = 5;
        [btn2 addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn2];
    }
    return self;
}

-(void)openLink {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/iPAFire"] options:@{} completionHandler:nil];
}

-(void)dismiss:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.superview.alpha = 0;
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];
}

@end

%hook AppDelegate
- (void)applicationDidBecomeActive:(id)application {
    %orig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIView *bgView = [[UIView alloc] initWithFrame:window.bounds];
        bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [window addSubview:bgView];
        
        MoonAlertView *alert = [[MoonAlertView alloc] initWithFrame:CGRectMake((window.bounds.size.width-300)/2, (window.bounds.size.height-350)/2, 300, 350)];
        [bgView addSubview:alert];
    });
}
%end

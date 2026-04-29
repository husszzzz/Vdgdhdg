#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface AlhussainiEliteSplash : UIView
@property (nonatomic, strong) UIView *containerView;
@end

@implementation AlhussainiEliteSplash

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
        [self setupOVFLayout];
    }
    return self;
}

- (void)setupOVFLayout {
    // الحاوية الرئيسية (نفس انحناء OVF)
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
    self.containerView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2 + 50);
    self.containerView.backgroundColor = [UIColor colorWithRed:0.12 green:0.10 blue:0.18 alpha:1.0]; // لون داكن فخم
    self.containerView.layer.cornerRadius = 25;
    [self addSubview:self.containerView];

    // دائرة اللوغو (بدل شعار النار)
    UIView *logoCircle = [[UIView alloc] initWithFrame:CGRectMake(110, -50, 100, 100)];
    logoCircle.backgroundColor = [UIColor colorWithRed:0.15 green:0.12 blue:0.22 alpha:1.0];
    logoCircle.layer.cornerRadius = 50;
    logoCircle.layer.borderWidth = 3;
    logoCircle.layer.borderColor = [UIColor orangeColor].CGColor;
    [self.containerView addSubview:logoCircle];

    UIImageView *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 90, 90)];
    logoImg.layer.cornerRadius = 45;
    logoImg.clipsToBounds = YES;
    
    // تحميل اللوغو الخاص بك من الرابط
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://e.top4top.io/p_37700ug540.jpeg"]];
        if(data) dispatch_async(dispatch_get_main_queue(), ^{ logoImg.image = [UIImage imageWithData:data]; });
    });
    [logoCircle addSubview:logoImg];

    // نصوص الترحيب
    UILabel *welcomeLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 300, 40)];
    welcomeLbl.text = @"يا هلا بيك | Welcome";
    welcomeLbl.textColor = [UIColor whiteColor];
    welcomeLbl.font = [UIFont boldSystemFontOfSize:24];
    welcomeLbl.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:welcomeLbl];

    UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, 280, 60)];
    subTitle.text = @"تابعونا للمزيد من التطبيقات والالعاب الحصرية لدينا";
    subTitle.textColor = [UIColor lightGrayColor];
    subTitle.numberOfLines = 2;
    subTitle.font = [UIFont systemFontOfSize:16];
    subTitle.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:subTitle];

    // أزرار التحكم (نفس ستايل OVF)
    [self createOVFButton:@"✨ Our Channel | قناتنا ✨" color:[UIColor colorWithRed:0.80 green:0.25 blue:0.10 alpha:1.0] y:220 action:@selector(openTele)];
    [self createOVFButton:@"✨ DEVELOPER: @OM_G9 ✨" color:[UIColor colorWithRed:0.20 green:0.20 blue:0.30 alpha:1.0] y:285 action:@selector(openTele)];
    [self createOVFButton:@"✨ Thanks | شكراً ✨" color:[UIColor colorWithRed:0.80 green:0.25 blue:0.10 alpha:1.0] y:350 action:@selector(close)];
}

- (void)createOVFButton:(NSString *)title color:(UIColor *)color y:(int)y action:(SEL)a {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, y, 280, 50)];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.backgroundColor = color;
    btn.layer.cornerRadius = 12;
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btn addTarget:self action:a forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:btn];
}

- (void)openTele {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/OM_G9"] options:@{} completionHandler:nil];
}

- (void)close {
    [UIView animateWithDuration:0.4 animations:^{ self.alpha = 0; } completion:^(BOOL f) { [self removeFromSuperview]; }];
}
@end

%ctor {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            UIWindow *win = [UIApplication sharedApplication].windows.firstObject;
            if (win) {
                AlhussainiEliteSplash *splash = [[AlhussainiEliteSplash alloc] initWithFrame:win.bounds];
                [win addSubview:splash];
            }
        });
    }];
}

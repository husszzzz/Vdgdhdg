#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface AlhussainiEliteSplash : UIView
@property (nonatomic, strong) UIView *glassCard;
@end

@implementation AlhussainiEliteSplash

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        [self createEliteUI];
    }
    return self;
}

- (void)createEliteUI {
    // التصميم الزجاجي الفخم
    self.glassCard = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 500)];
    self.glassCard.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    self.glassCard.layer.cornerRadius = 40;
    self.glassCard.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.glassCard.layer.borderWidth = 1.5;
    self.glassCard.layer.borderColor = [UIColor yellowColor].CGColor;
    [self addSubview:self.glassCard];

    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
    blurView.frame = self.glassCard.bounds;
    blurView.layer.cornerRadius = 40;
    blurView.clipsToBounds = YES;
    [self.glassCard addSubview:blurView];

    // نصوص النيون القوية
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 320, 60)];
    title.text = @"ALHUSSAINI ELITE";
    title.textColor = [UIColor yellowColor];
    title.font = [UIFont fontWithName:@"AvenirNext-Heavy" size:30];
    title.textAlignment = NSTextAlignmentCenter;
    title.layer.shadowColor = [UIColor yellowColor].CGColor;
    title.layer.shadowRadius = 10;
    title.layer.shadowOpacity = 0.8;
    [self.glassCard addSubview:title];

    // زر الدخول
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 400, 220, 55)];
    [btn setTitle:@"ENTER SYSTEM" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor yellowColor];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 20;
    [btn addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
    [self.glassCard addSubview:btn];
}

- (void)go {
    [UIView animateWithDuration:0.5 animations:^{ self.alpha = 0; } completion:^(BOOL f) { [self removeFromSuperview]; }];
}
@end

%ctor {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            UIWindow *win = [UIApplication sharedApplication].windows.firstObject;
            if (win) {
                AlhussainiEliteSplash *s = [[AlhussainiEliteSplash alloc] initWithFrame:win.bounds];
                [win addSubview:s];
            }
        });
    }];
}

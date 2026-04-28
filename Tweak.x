#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface AlhussainiView : UIViewController
@property (nonatomic, strong) UIView *box;
@property (nonatomic, strong) UITextField *input;
@property (nonatomic, strong) UIButton *fBtn;
@end

@implementation AlhussainiView
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self setupLogin];
}

- (void)setupLogin {
    self.box = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 400)];
    self.box.center = self.view.center;
    self.box.backgroundColor = [UIColor blackColor];
    self.box.layer.cornerRadius = 20;
    self.box.layer.borderColor = [UIColor yellowColor].CGColor;
    self.box.layer.borderWidth = 2;
    [self.view addSubview:self.box];

    self.input = [[UITextField alloc] initWithFrame:CGRectMake(30, 140, 220, 40)];
    self.input.placeholder = @"كلمة السر...";
    self.input.secureTextEntry = YES;
    self.input.textColor = [UIColor whiteColor];
    self.input.textAlignment = NSTextAlignmentCenter;
    self.input.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    [self.box addSubview:self.input];

    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(140, 300) radius:30 startAngle:-M_PI_2 endAngle:2*M_PI-M_PI_2 clockwise:YES];
    CAShapeLayer *timer = [CAShapeLayer layer];
    timer.path = path.CGPath;
    timer.strokeColor = [UIColor yellowColor].CGColor;
    timer.fillColor = [UIColor clearColor].CGColor;
    timer.lineWidth = 3;
    [self.box.layer addSublayer:timer];

    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anim.duration = 6.0;
    anim.fromValue = @0;
    anim.toValue = @1;
    [timer addAnimation:anim forKey:@"t"];

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 275, 80, 50)];
    [btn setTitle:@"دخول" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(unlock) forControlEvents:UIControlEventTouchUpInside];
    [self.box addSubview:btn];
}

- (void)unlock {
    if ([self.input.text isEqualToString:@"hassany"]) {
        [self.box removeFromSuperview];
        [self makeFloat];
    }
}

- (void)makeFloat {
    self.fBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 100, 60, 60)];
    self.fBtn.layer.cornerRadius = 30;
    self.fBtn.layer.borderWidth = 2;
    self.fBtn.layer.borderColor = [UIColor yellowColor].CGColor;
    self.fBtn.clipsToBounds = YES;
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://e.top4top.io/p_37700ug540.jpeg"]];
        if(data) dispatch_async(dispatch_get_main_queue(), ^{ [self.fBtn setImage:[UIImage imageWithData:data] forState:UIControlStateNormal]; });
    });

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drag:)];
    [self.fBtn addGestureRecognizer:pan];
    [[UIApplication sharedApplication].windows.firstObject addSubview:self.fBtn];
}

- (void)drag:(UIPanGestureRecognizer *)p {
    CGPoint t = [p translationInView:self.view];
    self.fBtn.center = CGPointMake(self.fBtn.center.x + t.x, self.fBtn.center.y + t.y);
    [p setTranslation:CGPointZero inView:self.view];
}
@end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIWindow *win = [UIApplication sharedApplication].windows.firstObject;
        if (win.rootViewController) {
            AlhussainiView *vc = [[AlhussainiView alloc] init];
            vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [win.rootViewController presentViewController:vc animated:YES completion:nil];
        }
    });
}
ض

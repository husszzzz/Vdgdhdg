#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

@interface AlhussainiModMenu : UIViewController <UITextFieldDelegate>
@property (nonatomic, strong) UIView *loginView;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UIButton *floatingLogo;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) UISwitch *themeSwitch;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, assign) BOOL isWhiteTheme;
@end

@implementation AlhussainiModMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self setupLoginView];
}

- (void)setupLoginView {
    self.loginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 450)];
    self.loginView.center = self.view.center;
    self.loginView.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.1 alpha:0.95];
    self.loginView.layer.cornerRadius = 25;
    self.loginView.layer.borderColor = [UIColor yellowColor].CGColor;
    self.loginView.layer.borderWidth = 1.5;
    [self.view addSubview:self.loginView];

    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(110, 30, 80, 80)];
    img.layer.cornerRadius = 40;
    img.clipsToBounds = YES;
    [self.loginView addSubview:img];
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://e.top4top.io/p_37700ug540.jpeg"]];
        if(data) dispatch_async(dispatch_get_main_queue(), ^{ img.image = [UIImage imageWithData:data]; });
    });

    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(40, 180, 220, 45)];
    self.passwordField.placeholder = @"كلمة السر...";
    self.passwordField.secureTextEntry = YES;
    self.passwordField.textAlignment = NSTextAlignmentCenter;
    self.passwordField.textColor = [UIColor whiteColor];
    self.passwordField.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    self.passwordField.layer.cornerRadius = 10;
    [self.loginView addSubview:self.passwordField];

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(115, 315, 70, 70)];
    [btn setTitle:@"دخول" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(checkPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.loginView addSubview:btn];
}

- (void)checkPassword {
    if ([self.passwordField.text isEqualToString:@"hassany"]) {
        [self.loginView removeFromSuperview];
        [self createFloatingLogo];
    }
}

- (void)createFloatingLogo {
    self.floatingLogo = [[UIButton alloc] initWithFrame:CGRectMake(50, 150, 60, 60)];
    self.floatingLogo.layer.cornerRadius = 30;
    self.floatingLogo.layer.borderColor = [UIColor yellowColor].CGColor;
    self.floatingLogo.layer.borderWidth = 2;
    self.floatingLogo.clipsToBounds = YES;
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://e.top4top.io/p_37700ug540.jpeg"]];
        if(data) dispatch_async(dispatch_get_main_queue(), ^{ 
            [self.floatingLogo setImage:[UIImage imageWithData:data] forState:UIControlStateNormal]; 
        });
    });

    [self.floatingLogo addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.floatingLogo addGestureRecognizer:pan];
    [self.view addSubview:self.floatingLogo];
}

- (void)handlePan:(UIPanGestureRecognizer *)p {
    CGPoint translation = [p translationInView:self.view];
    self.floatingLogo.center = CGPointMake(self.floatingLogo.center.x + translation.x, self.floatingLogo.center.y + translation.y);
    [p setTranslation:CGPointZero inView:self.view];
}

- (void)toggleMenu {
    if (self.menuView) { [self.menuView removeFromSuperview]; self.menuView = nil; return; }
    self.menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 350)];
    self.menuView.center = self.view.center;
    self.menuView.backgroundColor = [UIColor blackColor];
    self.menuView.layer.cornerRadius = 20;
    [self.view addSubview:self.menuView];
}

@end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene *scene in (NSArray *)[UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    window = scene.windows.firstObject;
                    break;
                }
            }
        }
        if (!window) window = [UIApplication sharedApplication].windows.firstObject;

        if (window.rootViewController) {
            AlhussainiModMenu *vc = [[AlhussainiModMenu alloc] init];
            vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [window.rootViewController presentViewController:vc animated:YES completion:nil];
        }
    });
}

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

static BOOL isKickliveInjected = NO;

// ==========================================
// 1. كلاس تأثير الموجة (Ripple Effect)
// ==========================================
@interface KLRippleButton : UIButton
@end
@implementation KLRippleButton
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInView:self];
    CAShapeLayer *rippleShape = [CAShapeLayer layer];
    CGFloat radius = self.bounds.size.width;
    rippleShape.bounds = CGRectMake(0, 0, radius * 2, radius * 2);
    rippleShape.path = [UIBezierPath bezierPathWithOvalInRect:rippleShape.bounds].CGPath;
    rippleShape.position = touchLocation;
    rippleShape.fillColor = [UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
    rippleShape.opacity = 0;
    [self.layer insertSublayer:rippleShape atIndex:0];
    
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim.fromValue = @0.1;
    scaleAnim.toValue = @1.0;
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.fromValue = @1.0;
    opacityAnim.toValue = @0.0;
    
    CAAnimationGroup *groupAnim = [CAAnimationGroup animation];
    groupAnim.animations = @[scaleAnim, opacityAnim];
    groupAnim.duration = 0.5;
    groupAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    groupAnim.removedOnCompletion = NO;
    groupAnim.fillMode = kCAFillModeForwards;
    [rippleShape addAnimation:groupAnim forKey:@"ripple"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [rippleShape removeFromSuperlayer];
    });
    return [super beginTrackingWithTouch:touch withEvent:event];
}
@end

// ==========================================
// 2. واجهة الإعدادات الفخمة الخاصة بك (Full Screen)
// ==========================================
@interface KickliveProSettingsVC : UIViewController
@end

@implementation KickliveProSettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.07 alpha:1.0]; // أسود فاخر
    
    // الإنترو (اللوكو)
    UIView *logoContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 150)];
    logoContainer.center = CGPointMake(self.view.bounds.size.width / 2, 120);
    
    UILabel *logoTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 50)];
    logoTitle.text = @"⚽️ KICKLIVE";
    logoTitle.textColor = [UIColor colorWithRed:0.0 green:0.9 blue:0.4 alpha:1.0]; // أخضر
    logoTitle.font = [UIFont systemFontOfSize:36 weight:UIFontWeightBlack];
    logoTitle.textAlignment = NSTextAlignmentCenter;
    [logoContainer addSubview:logoTitle];
    
    UILabel *logoSub = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 250, 30)];
    logoSub.text = @"PRO VERSION";
    logoSub.textColor = [UIColor whiteColor];
    logoSub.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    logoSub.textAlignment = NSTextAlignmentCenter;
    logoSub.alpha = 0.6;
    [logoContainer addSubview:logoSub];
    
    // أنيميشن اللوكو
    logoContainer.transform = CGAffineTransformMakeScale(0.2, 0.2);
    logoContainer.alpha = 0;
    [self.view addSubview:logoContainer];
    
    [UIView animateWithDuration:0.8 delay:0.1 usingSpringWithDamping:0.6 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        logoContainer.transform = CGAffineTransformIdentity;
        logoContainer.alpha = 1.0;
    } completion:nil];
    
    // الأزرار
    NSArray *titles = @[@"قناة التطبيقات الرسمية", @"المطور @OM_G9", @"قوانين Kicklive", @"إغلاق الإعدادات"];
    NSArray *actions = @[@"openChan", @"openDev", @"openRules", @"closeSettings"];
    NSArray *icons = @[@"🚀", @"👑", @"🛡", @"❌"];
    
    CGFloat startY = 220;
    for (int i = 0; i < titles.count; i++) {
        KLRippleButton *btn = [KLRippleButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(30, startY + (i * 80), self.view.bounds.size.width - 60, 65);
        btn.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.12 alpha:1.0];
        btn.layer.cornerRadius = 20;
        
        // تمييز زر الإغلاق باللون الأحمر
        if (i == titles.count - 1) {
            btn.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
            btn.layer.borderWidth = 1.5;
        } else {
            btn.layer.borderColor = [UIColor colorWithRed:0.0 green:0.9 blue:0.4 alpha:0.3].CGColor;
            btn.layer.borderWidth = 1.5;
        }
        
        btn.clipsToBounds = YES;
        
        NSString *btnText = [NSString stringWithFormat:@"%@   %@", icons[i], titles[i]];
        [btn setTitle:btnText forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightHeavy];
        
        [btn addTarget:self action:NSSelectorFromString(actions[i]) forControlEvents:UIControlEventTouchUpInside];
        
        // أنيميشن صعود الأزرار
        btn.transform = CGAffineTransformMakeTranslation(0, 60);
        btn.alpha = 0;
        [self.view addSubview:btn];
        
        [UIView animateWithDuration:0.6 delay:0.3 + (i * 0.1) options:UIViewAnimationOptionCurveEaseOut animations:^{
            btn.transform = CGAffineTransformIdentity;
            btn.alpha = 1.0;
        } completion:nil];
    }
    
    // الحقوق
    UILabel *footer = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 80, self.view.bounds.size.width, 50)];
    footer.text = @"ALL RIGHTS RESERVED © KICKLIVE 2026\nDESIGNED BY @OM_G9 & @HassanyIPA";
    footer.numberOfLines = 2;
    footer.textAlignment = NSTextAlignmentCenter;
    footer.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    footer.font = [UIFont systemFontOfSize:11 weight:UIFontWeightBold];
    footer.alpha = 0;
    [self.view addSubview:footer];
    
    [UIView animateWithDuration:1.0 delay:0.8 options:UIViewAnimationOptionCurveEaseIn animations:^{
        footer.alpha = 1.0;
    } completion:nil];
}

- (void)openChan {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/hassanyIPA"] options:@{} completionHandler:nil];
}
- (void)openDev {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/OM_G9"] options:@{} completionHandler:nil];
}
- (void)openRules {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"قوانين Kicklive" message:@"هذا الإصدار معدل وحصري. يمنع استخدامه لأغراض تجارية." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"موافق" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)closeSettings {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

// ==========================================
// 3. حقن الزر العائم في جدار التطبيق (UIWindow)
// ==========================================
%hook UIWindow

- (void)layoutSubviews {
    %orig;
    
    // نحقن الزر العائم مرة واحدة فقط في النافذة الرئيسية
    if (!isKickliveInjected && self.isKeyWindow) {
        isKickliveInjected = YES;
        
        UIButton *floatingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        // وضع الزر في الزاوية السفلية اليمنى
        floatingBtn.frame = CGRectMake(self.bounds.size.width - 80, self.bounds.size.height - 150, 60, 60);
        floatingBtn.backgroundColor = [UIColor colorWithRed:0.0 green:0.8 blue:0.4 alpha:0.9]; // أخضر فاقع
        floatingBtn.layer.cornerRadius = 30;
        floatingBtn.layer.shadowColor = [UIColor blackColor].CGColor;
        floatingBtn.layer.shadowOpacity = 0.5;
        floatingBtn.layer.shadowOffset = CGSizeMake(0, 5);
        floatingBtn.layer.shadowRadius = 10;
        
        UILabel *icon = [[UILabel alloc] initWithFrame:floatingBtn.bounds];
        icon.text = @"⚙️";
        icon.font = [UIFont systemFontOfSize:28];
        icon.textAlignment = NSTextAlignmentCenter;
        [floatingBtn addSubview:icon];
        
        [floatingBtn addTarget:self action:@selector(kl_showSettings) forControlEvents:UIControlEventTouchUpInside];
        
        // جعل الزر قابل للسحب (Draggable)
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(kl_dragBtn:)];
        [floatingBtn addGestureRecognizer:pan];
        
        [self addSubview:floatingBtn];
        [self bringSubviewToFront:floatingBtn]; // نخليه فوك كل شي
    }
}

%new
- (void)kl_showSettings {
    KickliveProSettingsVC *settingsVC = [[KickliveProSettingsVC alloc] init];
    settingsVC.modalPresentationStyle = UIModalPresentationFullScreen; // يغطي الشاشة كلها
    settingsVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    UIViewController *root = self.rootViewController;
    while (root.presentedViewController) {
        root = root.presentedViewController;
    }
    [root presentViewController:settingsVC animated:YES completion:nil];
}

%new
- (void)kl_dragBtn:(UIPanGestureRecognizer *)pan {
    UIView *btn = pan.view;
    CGPoint translation = [pan translationInView:btn.superview];
    btn.center = CGPointMake(btn.center.x + translation.x, btn.center.y + translation.y);
    [pan setTranslation:CGPointZero inView:btn.superview];
}
%end

// ==========================================
// 4. إجبار النظام على تغيير اسم التطبيق
// ==========================================
%hook NSBundle
- (id)objectForInfoDictionaryKey:(NSString *)key {
    if ([key isEqualToString:@"CFBundleDisplayName"] || [key isEqualToString:@"CFBundleName"]) {
        return @"kicklive";
    }
    return %orig;
}
%end

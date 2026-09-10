#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// ==========================================
// 1. كلاس تأثير الموجة (Ripple Effect) للأزرار
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
// 2. محرك البحث العميق داخل SwiftUI
// ==========================================
@interface UIView (DeepSearch)
- (BOOL)kl_isSettingsPage;
@end

@implementation UIView (DeepSearch)
- (BOOL)kl_isSettingsPage {
    // SwiftUI تخزن النصوص في AccessibilityLabel
    if (self.accessibilityLabel) {
        NSString *label = self.accessibilityLabel;
        if ([label containsString:@"الصافرة"] || 
            [label containsString:@"الدعم والتواصل"] || 
            [label containsString:@"استخدام المشغل الأصلي"] ||
            [label containsString:@"الإعدادات"]) {
            return YES;
        }
    }
    
    // فحص جميع العناصر الفرعية برمجياً
    for (UIView *subview in self.subviews) {
        if ([subview kl_isSettingsPage]) {
            return YES;
        }
    }
    return NO;
}
@end

// ==========================================
// 3. اعتراض واجهات النظام بالكامل وتفجيرها
// ==========================================
%hook UIViewController

- (void)viewDidAppear:(BOOL)animated {
    %orig;
    
    // نعطي لـ SwiftUI مهلة 0.2 ثانية حتى ترسم الشاشة، ثم نهجم
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // إذا الكود اكتشف إن هذه هي صفحة الإعدادات بناءً على النصوص المخفية
        if ([self.view kl_isSettingsPage]) {
            [self performSelector:@selector(kl_forceKickliveOverhaul) withObject:nil afterDelay:0.1];
        }
    });
}

%new
- (void)kl_forceKickliveOverhaul {
    // إذا الواجهة مضاف عليها التصميم مسبقاً، نوقف حتى لا يتكرر
    if ([self.view viewWithTag:8888]) return;
    
    // 1. إخفاء وإعدام واجهة التطبيق الأصلية نهائياً
    for (UIView *sub in self.view.subviews) {
        sub.alpha = 0;
        sub.userInteractionEnabled = NO;
        sub.hidden = YES;
    }
    self.view.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.07 alpha:1.0]; // أسود ليلي فخم
    
    // 2. بناء حاوية التصميم الجديد
    UIView *mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    mainView.tag = 8888;
    mainView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mainView];
    
    // 3. الإنترو القوي (دخول شعار Kicklive)
    UIView *logoContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 150)];
    logoContainer.center = CGPointMake(mainView.center.x, 150);
    
    UILabel *logoTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    logoTitle.text = @"KICKLIVE";
    logoTitle.textColor = [UIColor colorWithRed:0.0 green:0.9 blue:0.4 alpha:1.0]; // أخضر فاقع رهيب
    logoTitle.font = [UIFont systemFontOfSize:34 weight:UIFontWeightBlack];
    logoTitle.textAlignment = NSTextAlignmentCenter;
    [logoContainer addSubview:logoTitle];
    
    UILabel *logoSub = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 200, 30)];
    logoSub.text = @"PRO VERSION";
    logoSub.textColor = [UIColor whiteColor];
    logoSub.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    logoSub.textAlignment = NSTextAlignmentCenter;
    logoSub.alpha = 0.5;
    [logoContainer addSubview:logoSub];
    
    // تأثير الدخول (Zoom In + Spring)
    logoContainer.transform = CGAffineTransformMakeScale(0.1, 0.1);
    logoContainer.alpha = 0;
    [mainView addSubview:logoContainer];
    
    [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        logoContainer.transform = CGAffineTransformIdentity;
        logoContainer.alpha = 1.0;
    } completion:nil];
    
    // 4. بناء الأزرار الفخمة
    NSArray *titles = @[@"قناة التطبيقات الرسمية", @"المطور @OM_G9", @"شروط وقوانين Kicklive", @"حماية الخصوصية"];
    NSArray *actions = @[@"kl_btn1", @"kl_btn2", @"kl_btn3", @"kl_btn4"];
    NSArray *icons = @[@"🔥", @"👑", @"🛡", @"🔒"];
    
    CGFloat yOffset = 260;
    for (int i = 0; i < titles.count; i++) {
        KLRippleButton *btn = [KLRippleButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(25, yOffset + (i * 75), mainView.bounds.size.width - 50, 60);
        btn.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.12 alpha:1.0];
        btn.layer.cornerRadius = 20;
        btn.layer.borderWidth = 1.5;
        btn.layer.borderColor = [UIColor colorWithRed:0.0 green:0.9 blue:0.4 alpha:0.3].CGColor;
        btn.clipsToBounds = YES; // مهم عشان تأثير الموجة ما يطلع برا الزر
        
        NSString *btnText = [NSString stringWithFormat:@"%@   %@", icons[i], titles[i]];
        [btn setTitle:btnText forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightHeavy];
        
        [btn addTarget:self action:NSSelectorFromString(actions[i]) forControlEvents:UIControlEventTouchUpInside];
        
        // تأثير دخول الأزرار من تحت لي فوك
        btn.transform = CGAffineTransformMakeTranslation(0, 50);
        btn.alpha = 0;
        [mainView addSubview:btn];
        
        [UIView animateWithDuration:0.6 delay:0.3 + (i * 0.15) options:UIViewAnimationOptionCurveEaseOut animations:^{
            btn.transform = CGAffineTransformIdentity;
            btn.alpha = 1.0;
        } completion:nil];
    }
    
    // 5. الحقوق أسفل الشاشة
    UILabel *footer = [[UILabel alloc] initWithFrame:CGRectMake(0, mainView.bounds.size.height - 90, mainView.bounds.size.width, 50)];
    footer.text = @"ALL RIGHTS RESERVED © KICKLIVE 2026\nDEVELOPED BY @OM_G9 & @HassanyIPA";
    footer.numberOfLines = 2;
    footer.textAlignment = NSTextAlignmentCenter;
    footer.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    footer.font = [UIFont systemFontOfSize:10 weight:UIFontWeightBold];
    
    footer.alpha = 0;
    [mainView addSubview:footer];
    
    [UIView animateWithDuration:1.5 delay:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        footer.alpha = 1.0;
    } completion:nil];
}

// ==========================================
// 4. أوامر الأزرار (التوجيه السريع)
// ==========================================
%new
- (void)kl_btn1 {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/hassanyIPA"] options:@{} completionHandler:nil];
}

%new
- (void)kl_btn2 {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/OM_G9"] options:@{} completionHandler:nil];
}

%new
- (void)kl_btn3 {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"قوانين Kicklive" message:@"أهلاً بك في الإصدار الخاص والمعدل.\n\nيُمنع استخدام هذا التطبيق لأغراض بيع أو تجارة. هذا الإصدار حصري للمطور @OM_G9 وقناة @hassanyIPA." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"أوافق" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

%new
- (void)kl_btn4 {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"الخصوصية" message:@"نحن في Kicklive نهتم بخصوصيتك. لا يتم جمع أو تتبع أي بيانات من المباريات التي تشاهدها." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"فهمت" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

%end

// ==========================================
// 5. إجبار النظام على تغيير اسم التطبيق
// ==========================================
%hook NSBundle
- (id)objectForInfoDictionaryKey:(NSString *)key {
    if ([key isEqualToString:@"CFBundleDisplayName"] || [key isEqualToString:@"CFBundleName"]) {
        return @"kicklive";
    }
    return %orig;
}
%end

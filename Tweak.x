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
    
    // إنشاء طبقة الموجة
    CAShapeLayer *rippleShape = [CAShapeLayer layer];
    CGFloat radius = self.bounds.size.width;
    rippleShape.bounds = CGRectMake(0, 0, radius * 2, radius * 2);
    rippleShape.path = [UIBezierPath bezierPathWithOvalInRect:rippleShape.bounds].CGPath;
    rippleShape.position = touchLocation;
    rippleShape.fillColor = [UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
    rippleShape.opacity = 0;
    [self.layer insertSublayer:rippleShape atIndex:0];
    
    // أنيميشن التكبير والشفافية
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
    
    // إزالة الموجة بعد انتهاء التأثير
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [rippleShape removeFromSuperlayer];
    });
    
    return [super beginTrackingWithTouch:touch withEvent:event];
}
@end

// ==========================================
// 2. دالة مساعدة لجلب نافذة العرض الحالية
// ==========================================
@interface UIView (FindVC)
- (UIViewController *)kl_viewController;
@end
@implementation UIView (FindVC)
- (UIViewController *)kl_viewController {
    UIResponder *responder = self;
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}
@end

// ==========================================
// 3. تغيير اسم التطبيق في النظام جذرياً
// ==========================================
%hook NSBundle
- (id)objectForInfoDictionaryKey:(NSString *)key {
    if ([key isEqualToString:@"CFBundleDisplayName"] || [key isEqualToString:@"CFBundleName"]) {
        return @"kicklive";
    }
    return %orig;
}
%end

// ==========================================
// 4. بناء الواجهة الجديدة وتدمير الواجهة القديمة
// ==========================================
%hook UIViewController

%new
- (void)kl_applyCompleteOverhaul {
    // التأكد من عدم بناء الواجهة مرتين
    if ([self.view viewWithTag:9999]) return;
    
    // 1. إخفاء كل عناصر التطبيق الأصلي (نمسح الواجهة القديمة)
    for (UIView *sub in self.view.subviews) {
        sub.hidden = YES;
    }
    
    // 2. بناء حاوية الواجهة الجديدة (لون داكن فخم جداً)
    UIView *newSettingsView = [[UIView alloc] initWithFrame:self.view.bounds];
    newSettingsView.tag = 9999;
    newSettingsView.backgroundColor = [UIColor colorWithRed:0.07 green:0.07 blue:0.09 alpha:1.0];
    [self.view addSubview:newSettingsView];
    
    // 3. إضافة الإنترو (اللوغو المتحرك)
    UIView *logoContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    logoContainer.center = CGPointMake(newSettingsView.center.x, 160);
    logoContainer.backgroundColor = [UIColor clearColor];
    
    UILabel *logoText = [[UILabel alloc] initWithFrame:logoContainer.bounds];
    logoText.text = @"⚽️\nKICKLIVE";
    logoText.numberOfLines = 2;
    logoText.textAlignment = NSTextAlignmentCenter;
    logoText.font = [UIFont systemFontOfSize:26 weight:UIFontWeightBlack];
    logoText.textColor = [UIColor colorWithRed:0.1 green:0.8 blue:0.4 alpha:1.0]; // لون أخضر فاقع
    [logoContainer addSubview:logoText];
    
    // إعداد اللوغو للإنترو (صغير وشفاف)
    logoContainer.transform = CGAffineTransformMakeScale(0.1, 0.1);
    logoContainer.alpha = 0;
    [newSettingsView addSubview:logoContainer];
    
    // تشغيل أنيميشن الإنترو (เด้ง / Spring Effect)
    [UIView animateWithDuration:1.2 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        logoContainer.transform = CGAffineTransformIdentity;
        logoContainer.alpha = 1.0;
    } completion:nil];
    
    // 4. إنشاء الأزرار الاحترافية بتأثير الموجة
    NSArray *buttonTitles = @[@"قناة التطبيقات (@hassanyIPA)", @"مطور النسخة (@OM_G9)", @"شروط الخدمة الجديدة", @"سياسة الخصوصية"];
    NSArray *selectors = @[@"kl_openChannel", @"kl_openDev", @"kl_openTerms", @"kl_openPrivacy"];
    NSArray *icons = @[@"📢", @"👨‍💻", @"📜", @"🔒"];
    
    CGFloat startY = 280;
    for (int i = 0; i < buttonTitles.count; i++) {
        KLRippleButton *btn = [KLRippleButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(30, startY + (i * 75), newSettingsView.bounds.size.width - 60, 60);
        btn.backgroundColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.15 alpha:1.0]; // لون الأزرار
        btn.layer.cornerRadius = 18;
        btn.layer.borderWidth = 1.5;
        btn.layer.borderColor = [UIColor colorWithRed:0.1 green:0.8 blue:0.4 alpha:0.4].CGColor;
        btn.clipsToBounds = YES;
        
        // النص والأيقونة
        NSString *fullTitle = [NSString stringWithFormat:@"%@  %@", icons[i], buttonTitles[i]];
        [btn setTitle:fullTitle forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
        
        // إضافة الأكشن
        [btn addTarget:self action:NSSelectorFromString(selectors[i]) forControlEvents:UIControlEventTouchUpInside];
        
        // إعداد الأزرار للأنيميشن (تبدأ من الأسفل وشفافة)
        btn.alpha = 0;
        btn.transform = CGAffineTransformMakeTranslation(0, 40);
        [newSettingsView addSubview:btn];
        
        // أنيميشن ظهور الأزرار بالتدريج
        [UIView animateWithDuration:0.7 delay:0.4 + (i * 0.15) options:UIViewAnimationOptionCurveEaseOut animations:^{
            btn.alpha = 1;
            btn.transform = CGAffineTransformIdentity;
        } completion:nil];
    }
    
    // 5. حقوق التطبيق الجديدة كلياً
    UILabel *copyrights = [[UILabel alloc] initWithFrame:CGRectMake(0, newSettingsView.bounds.size.height - 80, newSettingsView.bounds.size.width, 40)];
    copyrights.text = @"جميع الحقوق محفوظة © kicklive 2026\nDesigned by @OM_G9";
    copyrights.numberOfLines = 2;
    copyrights.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    copyrights.textAlignment = NSTextAlignmentCenter;
    copyrights.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    copyrights.alpha = 0;
    [newSettingsView addSubview:copyrights];
    
    // أنيميشن الحقوق
    [UIView animateWithDuration:1.0 delay:1.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        copyrights.alpha = 1.0;
    } completion:nil];
}

// أفعال الأزرار (Actions)
%new
- (void)kl_openChannel {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/hassanyIPA"] options:@{} completionHandler:nil];
}

%new
- (void)kl_openDev {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/OM_G9"] options:@{} completionHandler:nil];
}

%new
- (void)kl_openTerms {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"شروط خدمة kicklive" message:@"مرحباً بك في kicklive.\n\nتم إعادة تصميم هذا التطبيق بالكامل.\nيمنع استخدام النسخة لأغراض تجارية دون إذن المطور @OM_G9." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"موافق" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

%new
- (void)kl_openPrivacy {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"سياسة الخصوصية" message:@"في kicklive، خصوصيتك هي الأهم. نحن لا نجمع بياناتك الشخصية ولا نتعقب سجل المباريات التي تشاهدها." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"حسناً" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
%end

// ==========================================
// 5. صيد صفحة الإعدادات الأصلية وتفعيل الواجهة الجديدة
// ==========================================
%hook UILabel
- (void)layoutSubviews {
    %orig;
    // إذا اكتشف النظام أننا في صفحة تحتوي على كلمة "الصافرة" أو "إصدار التطبيق"
    if ([self.text containsString:@"الصافرة"] || [self.text containsString:@"إصدار التطبيق"]) {
        UIViewController *vc = [self kl_viewController];
        if (vc && ![vc.view viewWithTag:9999]) {
            // تنفيذ الهجوم وبناء الواجهة الجديدة فوراً
            [vc performSelector:@selector(kl_applyCompleteOverhaul) withObject:nil afterDelay:0.05];
        }
    }
}
%end

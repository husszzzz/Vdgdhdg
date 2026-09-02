#import <UIKit/UIKit.h>

@interface GBModMenu : UIView
- (void)openHasanyChannel:(id)sender;
- (void)openHasanyDev:(id)sender;
@end

// ==========================================
// 1. نظام تغيير النصوص وطمس الهوية
// ==========================================
%hook UILabel

- (void)setText:(NSString *)text {
    if (!text) { %orig(text); return; }
    
    if ([text containsString:@"i3rby Store"]) {
        %orig(@"hassanyIPA");
    } else if ([text containsString:@"ايفون بالعربي"]) {
        %orig(@""); // مسح الكلمة نهائياً
    } else if ([text containsString:@"8 ball pool mod"]) {
        %orig(@"Hassany Premium Mod");
    } else if ([text containsString:@"الاتمته"] || [text containsString:@"الأتمتة"]) {
        %orig(@"التوقع (VIP)");
    } else if ([text containsString:@"المجتمع"]) {
        %orig(@"لمحة عن فريق التطوير");
    } else if ([text containsString:@"PRO"] || [text containsString:@"اشتراك"]) {
        %orig(@""); // إخفاء كلمات برو والاشتراك
    } else {
        %orig(text);
    }
}

%end

// ==========================================
// 2. محرك التصميم العميق (تغيير الألوان، التوهج، إخفاء الإنجليزي)
// ==========================================
static void applyDeepCustomDesign(UIView *view, id targetMenu) {
    
    // --- تعديل النصوص الفرعية ---
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *lbl = (UILabel *)view;
        lbl.textColor = [UIColor whiteColor];
        lbl.font = [UIFont boldSystemFontOfSize:lbl.font.pointSize]; // جعل الخط عريض وأوضح
        
        if ([lbl.text isEqualToString:@"EN"] || [lbl.text isEqualToString:@"English"]) {
            lbl.hidden = YES;
            lbl.alpha = 0;
        }
    }
    
    // --- تعديل الأزرار ---
    else if ([view isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)view;
        NSString *title = [btn titleForState:UIControlStateNormal];
        
        btn.showsTouchWhenHighlighted = YES; // تأثير وميض عند اللمس
        
        // مسح الإنجليزي بالكامل
        if ([title isEqualToString:@"EN"] || [title isEqualToString:@"English"]) {
            btn.hidden = YES;
            btn.userInteractionEnabled = NO;
        }
        // تمديد زر العربي لسد الفراغ
        else if ([title isEqualToString:@"عربي"] || [title isEqualToString:@"AR"]) {
            [btn setTitle:@"✅ نسخة حسني مفعلة" forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0];
            btn.layer.cornerRadius = 8.0;
            btn.layer.shadowColor = [UIColor redColor].CGColor;
            btn.layer.shadowRadius = 10.0;
            btn.layer.shadowOpacity = 1.0;
            
            // محاولة تمديد الزر ليغطي مساحة الإنجليزي
            CGRect f = btn.frame;
            f.size.width = 250; 
            f.origin.x = (btn.superview.frame.size.width - 250) / 2; // توسيط
            if (f.origin.x > 0) { btn.frame = f; }
        }
        // أزرار فريق التطوير
        else if ([title containsString:@"تيليجرام"]) {
            [btn setTitle:@"قناة حسني (hassanyIPA)" forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor colorWithRed:0.8 green:0.1 blue:0.1 alpha:1.0];
            btn.layer.cornerRadius = 10;
            btn.layer.shadowColor = [UIColor redColor].CGColor;
            btn.layer.shadowRadius = 15.0;
            btn.layer.shadowOpacity = 1.0;
            [btn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [btn addTarget:targetMenu action:@selector(openHasanyChannel:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if ([title containsString:@"المجتمع"] || [title containsString:@"فريق"]) {
            [btn setTitle:@"المطور حسني (@OM_G9)" forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1.0];
            btn.layer.borderColor = [UIColor redColor].CGColor;
            btn.layer.borderWidth = 1.5;
            btn.layer.cornerRadius = 10;
            [btn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [btn addTarget:targetMenu action:@selector(openHasanyDev:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    // --- سحب صورة قناتك من الرابط ووضعها بدل اللوجو ---
    else if ([view isKindOfClass:[UIImageView class]]) {
        UIImageView *imgView = (UIImageView *)view;
        // استهداف اللوجو فقط (حجمه يكون أكبر من الأيقونات الصغيرة)
        if (imgView.frame.size.width >= 35 && imgView.frame.size.height >= 35) {
            static UIImage *customLogo = nil;
            if (!customLogo) {
                // سحب الصورة بدون تجميد اللعبة
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://f.top4top.io/p_38977zbnk0.jpeg"]];
                    if (imgData) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            customLogo = [UIImage imageWithData:imgData];
                            imgView.image = customLogo;
                            imgView.layer.cornerRadius = 10.0;
                            imgView.layer.masksToBounds = YES;
                            imgView.layer.borderWidth = 1.5;
                            imgView.layer.borderColor = [UIColor redColor].CGColor;
                        });
                    }
                });
            } else {
                imgView.image = customLogo;
                imgView.layer.cornerRadius = 10.0;
                imgView.layer.masksToBounds = YES;
                imgView.layer.borderWidth = 1.5;
                imgView.layer.borderColor = [UIColor redColor].CGColor;
            }
        }
    }
    
    // --- تعديل أزرار التشغيل (السويتشات) ---
    else if ([view isKindOfClass:[UISwitch class]]) {
        ((UISwitch *)view).onTintColor = [UIColor redColor];
        ((UISwitch *)view).thumbTintColor = [UIColor blackColor];
    }
    else if ([view isKindOfClass:[UISlider class]]) {
        ((UISlider *)view).minimumTrackTintColor = [UIColor redColor];
        ((UISlider *)view).thumbTintColor = [UIColor redColor];
    }
    
    // --- صبغ الخلفيات العشوائية بالأحمر والأسود ---
    else {
        if (view.backgroundColor && CGColorGetNumberOfComponents(view.backgroundColor.CGColor) > 2) {
            const CGFloat *components = CGColorGetComponents(view.backgroundColor.CGColor);
            // إذا كان اللون برتقالي/فاتح، حوله إلى أحمر داكن
            if (components[0] > 0.6 && components[1] > 0.2 && components[1] < 0.8) {
                view.backgroundColor = [UIColor colorWithRed:0.8 green:0.0 blue:0.0 alpha:1.0];
            }
        }
    }
    
    // تكرار العملية لكل العناصر
    for (UIView *sub in view.subviews) {
        applyDeepCustomDesign(sub, targetMenu);
    }
}

// ==========================================
// 3. بناء الواجهة الرئيسية وإضافة توهج النبض
// ==========================================
%hook GBModMenu

%new
- (void)openHasanyChannel:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://t.me/hassanyIPA"];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

%new
- (void)openHasanyDev:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://t.me/OM_G9"];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

- (void)layoutSubviews {
    %orig;
    
    UIView *mainMenu = (UIView *)self;
    
    // الثيم الأسود الاحترافي
    mainMenu.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.05 alpha:0.98];
    mainMenu.layer.borderColor = [UIColor redColor].CGColor;
    mainMenu.layer.borderWidth = 2.0;
    mainMenu.layer.cornerRadius = 15.0;
    
    // إعدادات التوهج الأولي
    mainMenu.layer.shadowColor = [UIColor redColor].CGColor;
    mainMenu.layer.shadowRadius = 20.0;
    mainMenu.layer.shadowOpacity = 1.0;
    mainMenu.layer.shadowOffset = CGSizeZero;
    mainMenu.layer.masksToBounds = NO;
    
    // إضافة "أنيميشن النبض" للتوهج (Glow Pulse)
    static BOOL animated = NO;
    if (!animated) {
        CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"shadowRadius"];
        pulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pulse.fromValue = @(15.0); // التوهج الأقل
        pulse.toValue = @(35.0);   // التوهج الأقصى
        pulse.autoreverses = YES;
        pulse.duration = 1.5;      // سرعة النبض
        pulse.repeatCount = HUGE_VALF; // تكرار لا نهائي
        [mainMenu.layer addAnimation:pulse forKey:@"pulseGlow"];
        animated = YES;
    }
    
    // تشغيل محرك التصميم على كل شيء داخل المنيو
    applyDeepCustomDesign(mainMenu, self);
}

%end

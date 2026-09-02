#import <UIKit/UIKit.h>

// تعريف الكلاس والدوال لتجنب أي أخطاء بالكومبايلر
@interface GBModMenu : UIView
- (void)openHasanyChannel:(id)sender;
- (void)openHasanyDev:(id)sender;
@end

// ==========================================
// 1. تغيير اسم المنيو الرئيسي
// ==========================================
%hook UILabel

- (void)setText:(NSString *)text {
    if ([text isEqualToString:@"i3rby Store"]) {
        %orig(@"hassanyIPA");
    } else {
        %orig(text);
    }
}

%end

// ==========================================
// 2. دالة التصميم (تم فصلها هنا لحل مشكلة الـ Retain Cycle)
// ==========================================
static void applyCustomDesign(UIView *view, id targetMenu) {
    // تعديل النصوص (UILabel)
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *lbl = (UILabel *)view;
        lbl.textColor = [UIColor whiteColor]; // كل النصوص تصير بيضاء
        
        // إخفاء زر أو نص اللغة الإنجليزية
        if ([lbl.text isEqualToString:@"EN"] || [lbl.text isEqualToString:@"English"]) {
            lbl.hidden = YES;
        }
    }
    
    // تعديل الأزرار (UIButton)
    else if ([view isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)view;
        NSString *title = [btn titleForState:UIControlStateNormal];
        
        // إخفاء الأزرار غير المطلوبة
        if ([title containsString:@"فيسبوك"] || [title containsString:@"إكس"] || [title containsString:@"دعم"] || [title isEqualToString:@"EN"]) {
            btn.hidden = YES;
            btn.alpha = 0;
        }
        // تعديل زر قناتنا
        else if ([title containsString:@"تيليجرام"]) {
            [btn setTitle:@"قناتنا" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor redColor]; // أحمر
            btn.layer.shadowColor = [UIColor redColor].CGColor;
            btn.layer.shadowRadius = 8.0;
            btn.layer.shadowOpacity = 0.8;
            btn.layer.shadowOffset = CGSizeZero;
            
            [btn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [btn addTarget:targetMenu action:@selector(openHasanyChannel:) forControlEvents:UIControlEventTouchUpInside];
        }
        // تعديل زر المطور
        else if ([title containsString:@"المجتمع"]) {
            [btn setTitle:@"المطور" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor redColor]; // أحمر
            btn.layer.shadowColor = [UIColor redColor].CGColor;
            btn.layer.shadowRadius = 8.0;
            btn.layer.shadowOpacity = 0.8;
            btn.layer.shadowOffset = CGSizeZero;
            
            [btn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [btn addTarget:targetMenu action:@selector(openHasanyDev:) forControlEvents:UIControlEventTouchUpInside];
        }
        // زر إعادة الإعدادات
        else if ([title containsString:@"إعادة"]) {
            btn.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1.0];
            btn.layer.borderColor = [UIColor redColor].CGColor;
            btn.layer.borderWidth = 1.0;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else if ([title isEqualToString:@"عربي"]) {
            btn.backgroundColor = [UIColor redColor];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    
    // تعديل أزرار التشغيل (UISwitch)
    else if ([view isKindOfClass:[UISwitch class]]) {
        ((UISwitch *)view).onTintColor = [UIColor redColor];
        ((UISwitch *)view).thumbTintColor = [UIColor blackColor];
    }
    
    // تعديل أشرطة السحب (UISlider)
    else if ([view isKindOfClass:[UISlider class]]) {
        ((UISlider *)view).minimumTrackTintColor = [UIColor redColor];
        ((UISlider *)view).thumbTintColor = [UIColor redColor];
        ((UISlider *)view).maximumTrackTintColor = [UIColor darkGrayColor];
    }
    
    // مسح الألوان البرتقالية من أي فيو ثاني وتحويله للأحمر
    else {
        if (view.backgroundColor && CGColorGetNumberOfComponents(view.backgroundColor.CGColor) > 2) {
            const CGFloat *components = CGColorGetComponents(view.backgroundColor.CGColor);
            if (components[0] > 0.7 && components[1] > 0.3 && components[1] < 0.7 && components[2] < 0.3) {
                view.backgroundColor = [UIColor redColor];
            }
        }
    }
    
    // تكرار العملية لكل العناصر الفرعية
    for (UIView *sub in view.subviews) {
        applyCustomDesign(sub, targetMenu);
    }
}


// ==========================================
// 3. تصميم المنيو والتوهج
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
    
    // تصميم الخلفية الرئيسية (أسود مع حدود وتوهج أحمر)
    UIView *mainMenu = (UIView *)self;
    mainMenu.backgroundColor = [UIColor colorWithRed:0.07 green:0.07 blue:0.07 alpha:0.95]; // أسود غامق
    mainMenu.layer.borderColor = [UIColor redColor].CGColor;
    mainMenu.layer.borderWidth = 1.5;
    mainMenu.layer.shadowColor = [UIColor redColor].CGColor;
    mainMenu.layer.shadowRadius = 15.0; // قوة التوهج
    mainMenu.layer.shadowOpacity = 0.9;
    mainMenu.layer.shadowOffset = CGSizeZero;
    mainMenu.layer.masksToBounds = NO;
    
    // استدعاء الدالة المساعدة لتطبيق التصميم على كل العناصر الداخلية
    applyCustomDesign(mainMenu, self);
}

%end

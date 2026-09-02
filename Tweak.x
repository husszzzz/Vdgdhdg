#import <UIKit/UIKit.h>

@interface GBModMenu : UIView
@end

// ==========================================
// 1. نظام تغيير النصوص (تم حل مشكلة الكومبايلر)
// ==========================================
%hook UILabel
- (void)setText:(NSString *)text {
    // التحقق من النص لتجنب الكراش
    if (!text || ![text isKindOfClass:[NSString class]]) {
        %orig(text);
        return;
    }
    
    NSString *newText = text;
    
    // تبديل النصوص
    if ([text containsString:@"i3rby Store"]) {
        newText = @"hassanyIPA";
    } else if ([text containsString:@"ايفون بالعربي"]) {
        newText = @"";
    }
    
    // استدعاء الدالة الأصلية مرة واحدة فقط لمنع خطأ Theos
    %orig(newText);
}
%end

// ==========================================
// 2. أدوات الخطف (Hijacking Tools) وتعديل التصميم
// ==========================================
static UIView* hijackRowWithText(UIView *root, NSString *searchText) {
    if ([root isKindOfClass:[UILabel class]]) {
        if ([[(UILabel *)root text] containsString:searchText]) {
            return root.superview; // سحب السطر بالكامل
        }
    }
    for (UIView *sub in root.subviews) {
        UIView *found = hijackRowWithText(sub, searchText);
        if (found) return found;
    }
    return nil;
}

static void styleHijackedRow(UIView *row) {
    row.backgroundColor = [UIColor clearColor];
    for (UIView *sub in row.subviews) {
        if ([sub isKindOfClass:[UILabel class]]) {
            ((UILabel *)sub).textColor = [UIColor whiteColor];
            ((UILabel *)sub).font = [UIFont boldSystemFontOfSize:16];
        } else if ([sub isKindOfClass:[UISwitch class]]) {
            ((UISwitch *)sub).onTintColor = [UIColor redColor];
            ((UISwitch *)sub).thumbTintColor = [UIColor blackColor];
        }
        styleHijackedRow(sub); 
    }
}

// ==========================================
// 3. بناء المنيو الأفقي الجديد (Horizontal Menu)
// ==========================================
%hook GBModMenu

- (void)layoutSubviews {
    %orig;
    
    UIView *mainMenu = (UIView *)self;
    
    // --- 1. تحويل المنيو إلى شكل أفقي ---
    CGRect newBounds = mainMenu.bounds;
    newBounds.size.width = 600;  
    newBounds.size.height = 360; 
    mainMenu.bounds = newBounds;
    
    // --- 2. ستايل الخلفية النيون ---
    mainMenu.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.05 alpha:0.98];
    mainMenu.layer.borderColor = [UIColor redColor].CGColor;
    mainMenu.layer.borderWidth = 2.0;
    mainMenu.layer.cornerRadius = 15.0;
    
    mainMenu.layer.shadowColor = [UIColor redColor].CGColor;
    mainMenu.layer.shadowRadius = 20.0;
    mainMenu.layer.shadowOpacity = 1.0;
    mainMenu.layer.shadowOffset = CGSizeZero;
    mainMenu.layer.masksToBounds = NO;
    
    // أنيميشن النبض
    static BOOL animated = NO;
    if (!animated) {
        CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"shadowRadius"];
        pulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pulse.fromValue = @(15.0);
        pulse.toValue = @(35.0);
        pulse.autoreverses = YES;
        pulse.duration = 1.5;
        pulse.repeatCount = HUGE_VALF;
        [mainMenu.layer addAnimation:pulse forKey:@"pulseGlow"];
        animated = YES;
    }
    
    // --- 3. إخفاء اللستة القديمة ---
    for (UIView *sub in mainMenu.subviews) {
        if ([sub isKindOfClass:[UIScrollView class]]) {
            sub.alpha = 0.0; 
        }
    }
    
    // --- 4. بناء الأقسام (Tabs) وحاوية الخطف ---
    UIView *hassanyUI = [mainMenu viewWithTag:7777];
    if (!hassanyUI) {
        hassanyUI = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 600, 320)];
        hassanyUI.tag = 7777;
        hassanyUI.backgroundColor = [UIColor clearColor];
        [mainMenu addSubview:hassanyUI];
        
        // الأقسام العلوية
        UISegmentedControl *tabs = [[UISegmentedControl alloc] initWithItems:@[@"التوقع", @"الرسوم", @"الإعدادات", @"فريق التطوير"]];
        tabs.frame = CGRectMake(20, 10, 560, 40);
        tabs.selectedSegmentIndex = 0; 
        
        if (@available(iOS 13.0, *)) {
            tabs.selectedSegmentTintColor = [UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0];
        } else {
            tabs.tintColor = [UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0];
        }
        [tabs setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont boldSystemFontOfSize:15]} forState:UIControlStateNormal];
        [hassanyUI addSubview:tabs];
        
        // منطقة المحتوى
        UIView *contentArea = [[UIView alloc] initWithFrame:CGRectMake(20, 65, 560, 235)];
        contentArea.tag = 8888;
        contentArea.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.6];
        contentArea.layer.cornerRadius = 10;
        contentArea.layer.borderColor = [UIColor colorWithRed:0.4 green:0.0 blue:0.0 alpha:1.0].CGColor;
        contentArea.layer.borderWidth = 1.0;
        [hassanyUI addSubview:contentArea];
        
        // --- 5. الخطف الفعلي ---
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // خطف الزر
            UIView *hijackedRow = hijackRowWithText(mainMenu, @"خطوط التوقع");
            
            if (hijackedRow) {
                [hijackedRow removeFromSuperview];
                hijackedRow.alpha = 1.0; 
                hijackedRow.frame = CGRectMake(10, 15, 540, 50); // ترتيب قياسه
                styleHijackedRow(hijackedRow);
                [contentArea addSubview:hijackedRow];
            }
        });
    }
}
%end

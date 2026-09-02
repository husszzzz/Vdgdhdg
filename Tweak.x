#import <UIKit/UIKit.h>

@interface GBModMenu : UIView
@end

// ==========================================
// 1. نظام تغيير النصوص (نمسح الهوية القديمة)
// ==========================================
%hook UILabel
- (void)setText:(NSString *)text {
    if (!text || ![text isKindOfClass:[NSString class]]) { %orig; return; }
    
    if ([text containsString:@"i3rby Store"]) { %orig(@"hassanyIPA"); }
    else if ([text containsString:@"ايفون بالعربي"]) { %orig(@""); }
    else { %orig; }
}
%end

// ==========================================
// 2. أدوات الخطف (Hijacking Tools) وتعديل التصميم
// ==========================================
// هذه الدالة تبحث عن أي كلمة تريدها وتسحب السطر كامل (الزر مع النص)
static UIView* hijackRowWithText(UIView *root, NSString *searchText) {
    if ([root isKindOfClass:[UILabel class]]) {
        if ([[(UILabel *)root text] containsString:searchText]) {
            return root.superview; // السطر بالكامل
        }
    }
    for (UIView *sub in root.subviews) {
        UIView *found = hijackRowWithText(sub, searchText);
        if (found) return found;
    }
    return nil;
}

// دالة لتنظيف وتلوين السطر المخطوف بالأحمر والأسود
static void styleHijackedRow(UIView *row) {
    row.backgroundColor = [UIColor clearColor]; // إزالة خلفيته الأصلية
    for (UIView *sub in row.subviews) {
        if ([sub isKindOfClass:[UILabel class]]) {
            ((UILabel *)sub).textColor = [UIColor whiteColor];
            ((UILabel *)sub).font = [UIFont boldSystemFontOfSize:16];
        } else if ([sub isKindOfClass:[UISwitch class]]) {
            ((UISwitch *)sub).onTintColor = [UIColor redColor];
            ((UISwitch *)sub).thumbTintColor = [UIColor blackColor];
        }
        // تطبيق التلوين على كل العناصر الداخلية
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
    
    // --- 1. تحويل المنيو إلى شكل أفقي (بالعرض) ---
    // نغير الأبعاد لنعطيه شكل الشاشة العريضة
    CGRect newBounds = mainMenu.bounds;
    newBounds.size.width = 600;  // عرض واسع
    newBounds.size.height = 360; // ارتفاع مناسب
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
    // نخفي القائمة القديمة حتى ما تشوه التصميم، بس نخليها شغالة بالخلفية
    for (UIView *sub in mainMenu.subviews) {
        if ([sub isKindOfClass:[UIScrollView class]]) {
            sub.alpha = 0.0; 
        }
    }
    
    // --- 4. بناء الأقسام (Tabs) وحاوية الخطف ---
    // نستخدم Tag لضمان بناء الواجهة مرة واحدة فقط
    UIView *hassanyUI = [mainMenu viewWithTag:7777];
    if (!hassanyUI) {
        // نترك 40 بكسل من الفوق حتى ما نغطي زر الإغلاق الأصلي (X) وشريط السحب
        hassanyUI = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 600, 320)];
        hassanyUI.tag = 7777;
        hassanyUI.backgroundColor = [UIColor clearColor];
        [mainMenu addSubview:hassanyUI];
        
        // الأقسام العلوية
        UISegmentedControl *tabs = [[UISegmentedControl alloc] initWithItems:@[@"التوقع", @"الرسوم", @"الإعدادات", @"فريق التطوير"]];
        tabs.frame = CGRectMake(20, 10, 560, 40);
        tabs.selectedSegmentIndex = 0; // التوقع هو الافتراضي
        
        // تلوين الأقسام
        if (@available(iOS 13.0, *)) {
            tabs.selectedSegmentTintColor = [UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0];
        } else {
            tabs.tintColor = [UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0];
        }
        [tabs setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont boldSystemFontOfSize:15]} forState:UIControlStateNormal];
        [hassanyUI addSubview:tabs];
        
        // منطقة المحتوى (اللي راح نحط بيها الزر المخطوف)
        UIView *contentArea = [[UIView alloc] initWithFrame:CGRectMake(20, 65, 560, 235)];
        contentArea.tag = 8888;
        contentArea.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.6];
        contentArea.layer.cornerRadius = 10;
        contentArea.layer.borderColor = [UIColor colorWithRed:0.4 green:0.0 blue:0.0 alpha:1.0].CGColor;
        contentArea.layer.borderWidth = 1.0;
        [hassanyUI addSubview:contentArea];
        
        // --- 5. الخطف الفعلي (Hijacking) ---
        // نستخدم توقيت بسيط (نصف ثانية) للتأكد أن اللعبة بنت الأزرار الأصلية بالخلفية قبل سحبها
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // نخطف زر التوقع
            UIView *hijackedRow = hijackRowWithText(mainMenu, @"خطوط التوقع");
            
            if (hijackedRow) {
                [hijackedRow removeFromSuperview]; // سحب من اللستة القديمة
                hijackedRow.alpha = 1.0; // إظهار
                
                // ترتيب قياساته داخل المنيو العريض
                hijackedRow.frame = CGRectMake(10, 15, 540, 50);
                
                // صبغه بألوان الحسني
                styleHijackedRow(hijackedRow);
                
                // زراعته في المحتوى الجديد
                [contentArea addSubview:hijackedRow];
            }
        });
    }
}
%end

#import <UIKit/UIKit.h>

@interface GBModMenu : UIView
- (void)tabChanged:(UISegmentedControl *)sender;
- (void)openHasanyChannel:(id)sender;
- (void)openHasanyDev:(id)sender;
@end

// ==========================================
// 1. نظام تغيير النصوص (نمسح الهوية القديمة ونغير الأسماء)
// ==========================================
%hook UILabel
- (void)setText:(NSString *)text {
    if (!text || ![text isKindOfClass:[NSString class]]) {
        %orig(text);
        return;
    }
    
    NSString *newText = text;
    
    // طمس الهوية القديمة
    if ([text containsString:@"i3rby Store"]) { newText = @"hassanyIPA"; }
    else if ([text containsString:@"ايفون بالعربي"]) { newText = @""; }
    
    // تغيير أسماء الأقسام والأزرار حسب طلبك
    else if ([text containsString:@"السحب الابتدائي"]) { newText = @"توقع الضربه القويه (ينصح به)"; }
    else if ([text containsString:@"البشرنة"]) { newText = @"أسلوب اللعب"; }
    
    %orig(newText);
}
%end

// ==========================================
// 2. محرك الخطف والتصميم (Hijack & Style Engine)
// ==========================================
// دالة للبحث عن الزر (السطر) وسحبه برمجياً
static UIView* extractRow(UIView *root, NSString *searchText) {
    if ([root isKindOfClass:[UILabel class]]) {
        if ([[(UILabel *)root text] containsString:searchText]) {
            UIView *parent = root.superview;
            // شرط الارتفاع حتى ما نسحب القائمة كلها بالغلط (نسحب فقط سطر الزر)
            if (parent && parent.bounds.size.height < 120) {
                return parent;
            }
        }
    }
    for (UIView *sub in root.subviews) {
        UIView *found = extractRow(sub, searchText);
        if (found) return found;
    }
    return nil;
}

// دالة لتطبيق ألوان الحسني (أحمر وأسود) على السطر المسحوب
static void styleHijackedRow(UIView *row) {
    row.backgroundColor = [UIColor clearColor];
    for (UIView *sub in row.subviews) {
        if ([sub isKindOfClass:[UILabel class]]) {
            ((UILabel *)sub).textColor = [UIColor whiteColor];
            ((UILabel *)sub).font = [UIFont boldSystemFontOfSize:15];
        } 
        else if ([sub isKindOfClass:[UISwitch class]]) {
            ((UISwitch *)sub).onTintColor = [UIColor redColor];
            ((UISwitch *)sub).thumbTintColor = [UIColor blackColor];
        }
        else if ([sub isKindOfClass:[UISlider class]]) {
            ((UISlider *)sub).minimumTrackTintColor = [UIColor redColor];
            ((UISlider *)sub).thumbTintColor = [UIColor redColor];
        }
        else if ([sub isKindOfClass:[UISegmentedControl class]]) {
            if (@available(iOS 13.0, *)) {
                ((UISegmentedControl *)sub).selectedSegmentTintColor = [UIColor redColor];
            } else {
                ((UISegmentedControl *)sub).tintColor = [UIColor redColor];
            }
        }
        styleHijackedRow(sub); 
    }
}

// ==========================================
// 3. بناء الواجهة الأسطورية
// ==========================================
%hook GBModMenu

%new
- (void)tabChanged:(UISegmentedControl *)sender {
    UIView *hassanyUI = [self viewWithTag:7777];
    for (int i = 0; i < 4; i++) {
        UIView *container = [hassanyUI viewWithTag:8000 + i];
        container.hidden = (i != sender.selectedSegmentIndex);
    }
}

%new
- (void)openHasanyChannel:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/hassanyIPA"] options:@{} completionHandler:nil];
}

%new
- (void)openHasanyDev:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/OM_G9"] options:@{} completionHandler:nil];
}

- (void)layoutSubviews {
    %orig;
    
    UIView *mainMenu = (UIView *)self;
    
    // --- 1. قياسات المنيو والخلفية ---
    CGRect newBounds = mainMenu.bounds;
    newBounds.size.width = 600;  
    newBounds.size.height = 380; 
    mainMenu.bounds = newBounds;
    
    mainMenu.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.05 alpha:0.98];
    mainMenu.layer.borderColor = [UIColor redColor].CGColor;
    mainMenu.layer.borderWidth = 2.0;
    mainMenu.layer.cornerRadius = 15.0;
    
    mainMenu.layer.shadowColor = [UIColor redColor].CGColor;
    mainMenu.layer.shadowRadius = 25.0;
    mainMenu.layer.shadowOpacity = 1.0;
    
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
    
    // --- 2. إخفاء المنيو القديم وكل محتوياته (بما فيها صندوق برو) ---
    for (UIView *sub in mainMenu.subviews) {
        if (sub.tag != 7777) {
            sub.alpha = 0.0;
            sub.hidden = YES;
            // تصغير الحجم حتى ما يأثر على الضغطات
            sub.frame = CGRectMake(0, 0, 1, 1);
        }
    }
    
    // --- 3. بناء واجهة الحسني (مرة واحدة) ---
    UIView *hassanyUI = [mainMenu viewWithTag:7777];
    if (!hassanyUI) {
        hassanyUI = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 600, 380)];
        hassanyUI.tag = 7777;
        [mainMenu addSubview:hassanyUI];
        
        // الأقسام العلوية
        UISegmentedControl *tabs = [[UISegmentedControl alloc] initWithItems:@[@"التوقع", @"طريقة العرض", @"اللعب التلقائي", @"الإعدادات"]];
        tabs.frame = CGRectMake(20, 20, 560, 40);
        tabs.selectedSegmentIndex = 0; 
        [tabs addTarget:self action:@selector(tabChanged:) forControlEvents:UIControlEventValueChanged];
        
        if (@available(iOS 13.0, *)) {
            tabs.selectedSegmentTintColor = [UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0];
        } else {
            tabs.tintColor = [UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0];
        }
        [tabs setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont boldSystemFontOfSize:15]} forState:UIControlStateNormal];
        [hassanyUI addSubview:tabs];
        
        // --- 4. بناء حاويات السحب (ScrollViews) للأقسام الأربعة ---
        for (int i = 0; i < 4; i++) {
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 75, 560, 285)];
            scrollView.tag = 8000 + i; 
            scrollView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.6];
            scrollView.layer.cornerRadius = 10;
            scrollView.layer.borderColor = [UIColor colorWithRed:0.4 green:0.0 blue:0.0 alpha:1.0].CGColor;
            scrollView.layer.borderWidth = 1.0;
            scrollView.hidden = (i != 0); 
            [hassanyUI addSubview:scrollView];
        }
        
        // جلب الحاويات
        UIScrollView *tab0 = (UIScrollView *)[hassanyUI viewWithTag:8000];
        UIScrollView *tab1 = (UIScrollView *)[hassanyUI viewWithTag:8001];
        UIScrollView *tab2 = (UIScrollView *)[hassanyUI viewWithTag:8002];
        UIScrollView *tab3 = (UIScrollView *)[hassanyUI viewWithTag:8003];
        
        // --- 5. تنفيذ عملية السحب (بعد نصف ثانية لضمان تحميل اللعبة للأزرار) ---
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // قائمة الأزرار لكل قسم
            NSArray *targetsTab0 = @[@"خطوط التوقع", @"توقع الخصم", @"حدود الطاولة", @"الكرة", @"حماية البث"];
            NSArray *targetsTab1 = @[@"الرسوم", @"إزاحة Y", @"إزاحة X", @"مقياس X", @"مقياس Y", @"سمك الخط", @"شفافية الخط", @"حجم نقطة النهاية", @"حجم حلقة الجيب", @"توقع الضربه القويه"];
            NSArray *targetsTab2 = @[@"زر الاختصار", @"إيقاف عند اللمس", @"نمط دوران", @"وضع التصويب", @"أسلوب اللعب", @"مستوى اللعب", @"وضع الكسر", @"قوة التصويب", @"أقصى سرعة تصويب"];
            
            // دالة مساعدة لزرع الأزرار داخل الحاوية الخاصة بها
            void (^plantButtons)(NSArray *, UIScrollView *) = ^(NSArray *targets, UIScrollView *scroll) {
                CGFloat currentY = 10;
                for (NSString *targetName in targets) {
                    UIView *row = extractRow(mainMenu, targetName);
                    if (row) {
                        [row removeFromSuperview];
                        row.alpha = 1.0;
                        row.hidden = NO;
                        // ترتيب قياس السطر
                        row.frame = CGRectMake(10, currentY, 540, row.frame.size.height > 20 ? row.frame.size.height : 50);
                        styleHijackedRow(row);
                        [scroll addSubview:row];
                        currentY += row.frame.size.height + 5;
                    }
                }
                scroll.contentSize = CGSizeMake(560, currentY + 20); // تفعيل السحب إذا زادت الأزرار
            };
            
            // تنفيذ الزرع للأقسام الثلاثة
            plantButtons(targetsTab0, tab0);
            plantButtons(targetsTab1, tab1);
            plantButtons(targetsTab2, tab2);
            
            // --- 6. تصميم قسم الإعدادات (القسم الرابع) ---
            // صورة الحسني
            UIImageView *profilePic = [[UIImageView alloc] initWithFrame:CGRectMake(230, 20, 100, 100)];
            profilePic.layer.cornerRadius = 50;
            profilePic.layer.masksToBounds = YES;
            profilePic.layer.borderWidth = 2.0;
            profilePic.layer.borderColor = [UIColor redColor].CGColor;
            [tab3 addSubview:profilePic];
            
            // تحميل الصورة
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://f.top4top.io/p_38977zbnk0.jpeg"]];
                if (imgData) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        profilePic.image = [UIImage imageWithData:imgData];
                    });
                }
            });
            
            // الاسم
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, 560, 30)];
            nameLabel.text = @"Hassany Premium Mod";
            nameLabel.textColor = [UIColor whiteColor];
            nameLabel.font = [UIFont boldSystemFontOfSize:20];
            nameLabel.textAlignment = NSTextAlignmentCenter;
            [tab3 addSubview:nameLabel];
            
            // زر القناة
            UIButton *btnChannel = [UIButton buttonWithType:UIButtonTypeCustom];
            btnChannel.frame = CGRectMake(180, 175, 200, 40);
            [btnChannel setTitle:@"قناة التيليجرام" forState:UIControlStateNormal];
            btnChannel.backgroundColor = [UIColor colorWithRed:0.8 green:0.0 blue:0.0 alpha:1.0];
            btnChannel.layer.cornerRadius = 10;
            [btnChannel addTarget:self action:@selector(openHasanyChannel:) forControlEvents:UIControlEventTouchUpInside];
            [tab3 addSubview:btnChannel];
            
            // زر المطور
            UIButton *btnDev = [UIButton buttonWithType:UIButtonTypeCustom];
            btnDev.frame = CGRectMake(180, 225, 200, 40);
            [btnDev setTitle:@"التواصل مع المطور" forState:UIControlStateNormal];
            btnDev.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
            btnDev.layer.borderColor = [UIColor redColor].CGColor;
            btnDev.layer.borderWidth = 1.0;
            btnDev.layer.cornerRadius = 10;
            [btnDev addTarget:self action:@selector(openHasanyDev:) forControlEvents:UIControlEventTouchUpInside];
            [tab3 addSubview:btnDev];
            
            tab3.contentSize = CGSizeMake(560, 300);
        });
    }
}
%end

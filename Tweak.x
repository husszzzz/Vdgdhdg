#import <UIKit/UIKit.h>

// ==========================================
// 1. تعريف الكلاسات
// ==========================================
@interface GBModMenu : UIView
@end

// متغير عام (Global) نحفظ بي المنيو القديم حتى نتحكم بي عن بعد
static UIView *ghostMenu = nil;

// ==========================================
// 2. محرك البحث الشبح (يبحث بالمنيو المخفي بس ما يسحب شي)
// ==========================================
static UISwitch* findGhostSwitch(UIView *root, NSString *searchText) {
    if ([root isKindOfClass:[UILabel class]]) {
        if ([[(UILabel *)root text] containsString:searchText]) {
            UIView *parent = root.superview;
            for (UIView *sub in parent.subviews) {
                if ([sub isKindOfClass:[UISwitch class]]) return (UISwitch *)sub;
            }
            if (parent.superview) {
                for (UIView *sub in parent.superview.subviews) {
                    if ([sub isKindOfClass:[UISwitch class]]) return (UISwitch *)sub;
                }
            }
        }
    }
    for (UIView *sub in root.subviews) {
        UISwitch *found = findGhostSwitch(sub, searchText);
        if (found) return found;
    }
    return nil;
}

// ==========================================
// 3. بناء الواجهة الجديدة كلياً (من الصفر)
// ==========================================
%hook GBModMenu

// زر التحكم الخاص بيك (من ينضغط، يروح يضغط الزر المخفي)
%new
- (void)hassanySwitchToggled:(UISwitch *)sender {
    NSString *targetName = sender.accessibilityIdentifier; // اسم الزر
    if (ghostMenu) {
        UISwitch *originalSwitch = findGhostSwitch(ghostMenu, targetName);
        if (originalSwitch) {
            // إرسال الأمر للزر الأصلي المخفي
            [originalSwitch setOn:sender.isOn animated:YES];
            [originalSwitch sendActionsForControlEvents:UIControlEventValueChanged];
            [originalSwitch sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
}

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

// دالة مساعدة لبناء سطر جديد نظيف 100% بداخل المنيو مالتك
%new
- (void)buildNewRowWithTitle:(NSString *)title yPos:(CGFloat *)yPos inContainer:(UIScrollView *)container {
    UIView *row = [[UIView alloc] initWithFrame:CGRectMake(10, *yPos, 560, 50)];
    row.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.8];
    row.layer.cornerRadius = 8.0;
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 400, 50)];
    lbl.text = title;
    lbl.textColor = [UIColor whiteColor];
    lbl.font = [UIFont boldSystemFontOfSize:16];
    [row addSubview:lbl];
    
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(490, 10, 50, 30)];
    sw.onTintColor = [UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0];
    sw.accessibilityIdentifier = title; // نحفظ الاسم حتى ندور عليه بالمنيو المخفي
    [sw addTarget:self action:@selector(hassanySwitchToggled:) forControlEvents:UIControlEventValueChanged];
    [row addSubview:sw];
    
    [container addSubview:row];
    *yOffset += 55;
    container.contentSize = CGSizeMake(580, *yPos + 20);
}

- (void)layoutSubviews {
    %orig;
    
    // حفظ المنيو القديم وجعله شبح (مخفي تماماً)
    ghostMenu = (UIView *)self;
    ghostMenu.alpha = 0.02; // شفاف جداً حتى عبالك مختفي، بس الايفون يبقي شغال
    
    // نبحث إذا واجهتنا مبنية أو لا (حتى ما تنبني مرتين)
    UIView *hassanyUI = [self.superview viewWithTag:7777];
    if (!hassanyUI) {
        
        // بناء حاوية الحسني الفخمة فوق المنيو القديم (منفصلة عنه)
        hassanyUI = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 620, 400)];
        hassanyUI.center = CGPointMake(self.superview.bounds.size.width / 2, self.superview.bounds.size.height / 2);
        hassanyUI.tag = 7777;
        hassanyUI.backgroundColor = [UIColor colorWithRed:0.07 green:0.07 blue:0.07 alpha:0.95]; 
        hassanyUI.layer.borderColor = [UIColor redColor].CGColor;
        hassanyUI.layer.borderWidth = 1.5;
        hassanyUI.layer.cornerRadius = 15.0;
        hassanyUI.layer.shadowColor = [UIColor redColor].CGColor;
        hassanyUI.layer.shadowRadius = 20.0;
        hassanyUI.layer.shadowOpacity = 0.9;
        
        [self.superview addSubview:hassanyUI]; // نضيفها للشاشة الرئيسية، مو للمنيو القديم
        
        UISegmentedControl *tabs = [[UISegmentedControl alloc] initWithItems:@[@"التوقع", @"طريقة العرض", @"اللعب التلقائي", @"الإعدادات"]];
        tabs.frame = CGRectMake(20, 15, 580, 45);
        tabs.selectedSegmentIndex = 0; 
        [tabs addTarget:self action:@selector(tabChanged:) forControlEvents:UIControlEventValueChanged];
        
        if (@available(iOS 13.0, *)) {
            tabs.selectedSegmentTintColor = [UIColor colorWithRed:0.8 green:0.0 blue:0.0 alpha:1.0];
        } else {
            tabs.tintColor = [UIColor colorWithRed:0.8 green:0.0 blue:0.0 alpha:1.0];
        }
        [tabs setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont boldSystemFontOfSize:15]} forState:UIControlStateNormal];
        [hassanyUI addSubview:tabs];
        
        // بناء السكرولات النظيفة
        for (int i = 0; i < 4; i++) {
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 75, 580, 310)];
            scrollView.tag = 8000 + i; 
            scrollView.backgroundColor = [UIColor clearColor]; 
            scrollView.showsVerticalScrollIndicator = NO; 
            scrollView.alwaysBounceVertical = YES; 
            scrollView.hidden = (i != 0);
            [hassanyUI addSubview:scrollView];
        }
        
        // --- بناء الأزرار يدوياً ---
        UIScrollView *tab0 = (UIScrollView *)[hassanyUI viewWithTag:8000];
        UIScrollView *tab1 = (UIScrollView *)[hassanyUI viewWithTag:8001];
        UIScrollView *tab2 = (UIScrollView *)[hassanyUI viewWithTag:8002];
        
        CGFloat y0 = 10, y1 = 10, y2 = 10;
        
        NSArray *targets0 = @[@"خطوط التوقع", @"توقع الخصم", @"حدود الطاولة", @"الكره الخاطئة", @"حماية البث"];
        for (NSString *name in targets0) [self buildNewRowWithTitle:name yPos:&y0 inContainer:tab0];
        
        NSArray *targets2 = @[@"زر الاختصار", @"إيقاف عند اللمس", @"نمط دوران", @"وضع التصويب", @"البشرنة", @"مستوى اللعب", @"وضع الكسر"];
        for (NSString *name in targets2) [self buildNewRowWithTitle:name yPos:&y2 inContainer:tab2];
        
        // (ملاحظة: السلايدرات مثل إزاحة X وإزاحة Y تتطلب برمجة خاصة بالـ Proxy، حالياً ضفتلك أهم شي السويتشات حتى تشوف الفكرة شلون ناجحة ومستقرة 100%)

        // --- قسم الإعدادات ---
        UIScrollView *tab3 = (UIScrollView *)[hassanyUI viewWithTag:8003];
        UIImageView *profilePic = [[UIImageView alloc] initWithFrame:CGRectMake(240, 10, 100, 100)];
        profilePic.layer.cornerRadius = 50;
        profilePic.layer.masksToBounds = YES;
        profilePic.layer.borderWidth = 2.0;
        profilePic.layer.borderColor = [UIColor redColor].CGColor;
        [tab3 addSubview:profilePic];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://f.top4top.io/p_38977zbnk0.jpeg"]];
            if (imgData) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    profilePic.image = [UIImage imageWithData:imgData];
                });
            }
        });
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, 580, 30)];
        nameLabel.text = @"Hassany Premium Mod";
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont boldSystemFontOfSize:22];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [tab3 addSubview:nameLabel];
        
        UIButton *btnChannel = [UIButton buttonWithType:UIButtonTypeCustom];
        btnChannel.frame = CGRectMake(190, 170, 200, 45);
        [btnChannel setTitle:@"قناة التيليجرام" forState:UIControlStateNormal];
        btnChannel.backgroundColor = [UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0];
        btnChannel.layer.cornerRadius = 10;
        [btnChannel addTarget:self action:@selector(openHasanyChannel:) forControlEvents:UIControlEventTouchUpInside];
        [tab3 addSubview:btnChannel];
        
        UIButton *btnDev = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDev.frame = CGRectMake(190, 225, 200, 45);
        [btnDev setTitle:@"التواصل مع المطور" forState:UIControlStateNormal];
        btnDev.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        btnDev.layer.borderColor = [UIColor redColor].CGColor;
        btnDev.layer.borderWidth = 1.0;
        btnDev.layer.cornerRadius = 10;
        [btnDev addTarget:self action:@selector(openHasanyDev:) forControlEvents:UIControlEventTouchUpInside];
        [tab3 addSubview:btnDev];
        
        tab3.contentSize = CGSizeMake(580, 300);
    }
}
%end

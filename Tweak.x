#import <UIKit/UIKit.h>

// ==========================================
// 1. تعريف الكلاسات (Interfaces)
// ==========================================
@interface GBModMenu : UIView
- (void)tabChanged:(UISegmentedControl *)sender;
- (void)openHasanyChannel:(id)sender;
- (void)openHasanyDev:(id)sender;
@end

// كلاس الزر الذكي (نظام علامة الصح ✅)
@interface CBToggle : UIButton
@property (nonatomic, strong) UISwitch *targetSwitch;
@property (nonatomic, strong) NSString *baseTitle;
- (void)updateLook;
@end

// ==========================================
// 2. برمجة زر الصح (Implementation)
// ==========================================
@implementation CBToggle
- (void)btnTapped {
    // تفعيل السويتش الأصلي المخفي
    [self.targetSwitch setOn:!self.targetSwitch.isOn animated:YES];
    [self.targetSwitch sendActionsForControlEvents:UIControlEventValueChanged];
    [self updateLook];
}
- (void)updateLook {
    if (self.targetSwitch.isOn) {
        [self setTitle:[NSString stringWithFormat:@"✅  %@", self.baseTitle] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor colorWithRed:0.6 green:0.0 blue:0.0 alpha:0.9];
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor redColor].CGColor;
    } else {
        [self setTitle:[NSString stringWithFormat:@"⬜️  %@", self.baseTitle] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.7];
        self.layer.borderWidth = 0.0;
    }
}
@end

// ==========================================
// 3. تغيير الأسماء الأصلية (Hooks)
// ==========================================
%hook UILabel
- (void)setText:(NSString *)text {
    if (!text || ![text isKindOfClass:[NSString class]]) { %orig; return; }
    
    NSString *newText = text;
    if ([text containsString:@"i3rby Store"]) { newText = @"hassanyIPA"; }
    else if ([text containsString:@"ايفون بالعربي"]) { newText = @""; }
    else if ([text containsString:@"السحب الابتدائي"]) { newText = @"توقع الضربه القويه"; }
    else if ([text containsString:@"البشرنة"]) { newText = @"أسلوب اللعب"; }
    else if ([text containsString:@"الرسوم"]) { newText = @"طريقة العرض"; }
    else if ([text containsString:@"الكره الخاطئة"]) { newText = @"تنبيه الكره الخاطئة"; }
    
    %orig(newText);
}
%end

// ==========================================
// 4. محرك البناء النظيف (بدون سحب العشوائيات)
// ==========================================
static UILabel* findLabel(UIView *root, NSString *searchText) {
    if (root.tag == 7777 || root.tag == 9999) return nil; 
    if ([root isKindOfClass:[UILabel class]]) {
        if ([[(UILabel *)root text] containsString:searchText]) return (UILabel *)root;
    }
    for (UIView *sub in root.subviews) {
        UILabel *found = findLabel(sub, searchText);
        if (found) return found;
    }
    return nil;
}

static UIView* findTrueRow(UILabel *label) {
    UIView *current = label.superview;
    while (current != nil) {
        for (UIView *sub in current.subviews) {
            if ([sub isKindOfClass:[UISwitch class]] || [sub isKindOfClass:[UISlider class]] || [sub isKindOfClass:[UISegmentedControl class]]) {
                return current;
            }
        }
        if ([current isKindOfClass:[UIScrollView class]]) break;
        current = current.superview;
    }
    return label.superview; 
}

// الدالة الأسطورية: تصنع واجهة نظيفة وتربطها بالمخفي
static void buildCleanRow(NSString *targetName, UIScrollView *scroll, CGFloat *yOffset, UIView *mainMenu) {
    UILabel *origLabel = findLabel(mainMenu, targetName);
    if (!origLabel) return;

    UIView *origRow = findTrueRow(origLabel);
    if (!origRow || origRow.tag == 9999) return;
    origRow.tag = 9999; // نعلمه حتى ما نرجعله

    // 1. نخفي السطر القديم بمكانه (ما نسحبه أبداً حتى ما يخرب)
    origRow.hidden = YES;

    // 2. نبني سطرنا النظيف
    UIView *cleanRow = [[UIView alloc] initWithFrame:CGRectMake(10, *yOffset, 560, 50)];
    cleanRow.backgroundColor = [UIColor clearColor];

    // 3. نبحث شنو بداخل السطر القديم (سويتش لو سلايدر لو خيارات؟)
    UISwitch *origSw = nil;
    UISlider *origSl = nil;
    UISegmentedControl *origSeg = nil;

    for (UIView *v in origRow.subviews) {
        if ([v isKindOfClass:[UISwitch class]]) origSw = (UISwitch *)v;
        else if ([v isKindOfClass:[UISlider class]]) origSl = (UISlider *)v;
        else if ([v isKindOfClass:[UISegmentedControl class]]) origSeg = (UISegmentedControl *)v;
    }

    // 4. نصمم على كيفنا
    if (origSw) {
        // زر الصح ✅
        CBToggle *btn = [CBToggle buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 560, 45);
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        btn.layer.cornerRadius = 10;
        btn.baseTitle = targetName;
        btn.targetSwitch = origSw;
        [btn addTarget:btn action:@selector(btnTapped) forControlEvents:UIControlEventTouchUpInside];
        [btn updateLook];
        [cleanRow addSubview:btn];
        *yOffset += 55;
    } 
    else if (origSl) {
        // شريط السحب (Slider)
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
        lbl.text = targetName;
        lbl.textColor = [UIColor whiteColor];
        lbl.font = [UIFont boldSystemFontOfSize:16];
        [cleanRow addSubview:lbl];

        [origSl removeFromSuperview];
        origSl.translatesAutoresizingMaskIntoConstraints = YES;
        origSl.frame = CGRectMake(210, 10, 330, 30);
        origSl.minimumTrackTintColor = [UIColor redColor];
        origSl.thumbTintColor = [UIColor redColor];
        [cleanRow addSubview:origSl];
        *yOffset += 55;
    } 
    else if (origSeg) {
        // الخيارات المتعددة (Segment)
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 50)];
        lbl.text = targetName;
        lbl.textColor = [UIColor whiteColor];
        lbl.font = [UIFont boldSystemFontOfSize:16];
        [cleanRow addSubview:lbl];

        [origSeg removeFromSuperview];
        origSeg.translatesAutoresizingMaskIntoConstraints = YES;
        origSeg.frame = CGRectMake(170, 10, 370, 35);
        if (@available(iOS 13.0, *)) {
            origSeg.selectedSegmentTintColor = [UIColor redColor];
        } else {
            origSeg.tintColor = [UIColor redColor];
        }
        [origSeg setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
        [cleanRow addSubview:origSeg];
        *yOffset += 60;
    }

    [scroll addSubview:cleanRow];
    scroll.contentSize = CGSizeMake(580, *yOffset + 20); // تفعيل النزول
}

static CGFloat tabY0 = 10, tabY1 = 10, tabY2 = 10;

static void continuousRadar(UIView *mainMenu, UIView *hassanyUI) {
    UIScrollView *tab0 = (UIScrollView *)[hassanyUI viewWithTag:8000];
    UIScrollView *tab1 = (UIScrollView *)[hassanyUI viewWithTag:8001];
    UIScrollView *tab2 = (UIScrollView *)[hassanyUI viewWithTag:8002];
    
    // الأسماء بالضبط مثل ما طلبتها
    NSArray *targets0 = @[@"خطوط التوقع", @"توقع الخصم", @"حدود الطاولة", @"تنبيه الكره الخاطئة", @"حماية البث"];
    NSArray *targets1 = @[@"طريقة العرض", @"إزاحة Y", @"إزاحة X", @"مقياس X", @"مقياس Y", @"سمك الخط", @"شفافية الخط", @"نقطة النهاية", @"حلقة الجيب", @"توقع الضربه القويه"];
    NSArray *targets2 = @[@"زر الاختصار", @"إيقاف عند اللمس", @"نمط دوران", @"وضع التصويب", @"أسلوب اللعب", @"مستوى اللعب", @"وضع الكسر", @"قوة التصويب", @"سرعة تصويب"];
    
    for (NSString *name in targets0) buildCleanRow(name, tab0, &tabY0, mainMenu);
    for (NSString *name in targets1) buildCleanRow(name, tab1, &tabY1, mainMenu);
    for (NSString *name in targets2) buildCleanRow(name, tab2, &tabY2, mainMenu);
    
    // إخفاء المنيو القديم بالكامل حتى ما يخرب المنظر
    for (UIView *sub in mainMenu.subviews) {
        if (sub.tag != 7777) { sub.alpha = 0.01; sub.userInteractionEnabled = NO; }
    }
    
    // البحث مستمر كل ثانية حتى يصيد الأزرار المتأخرة
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        continuousRadar(mainMenu, hassanyUI);
    });
}

// ==========================================
// 5. بناء واجهة المنيو الرئيسية
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
    
    CGRect newBounds = mainMenu.bounds;
    newBounds.size.width = 620;  
    newBounds.size.height = 400; 
    mainMenu.bounds = newBounds;
    mainMenu.backgroundColor = [UIColor clearColor]; 
    mainMenu.layer.borderWidth = 0;
    
    UIView *hassanyUI = [mainMenu viewWithTag:7777];
    if (!hassanyUI) {
        hassanyUI = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 620, 400)];
        hassanyUI.tag = 7777;
        hassanyUI.backgroundColor = [UIColor colorWithRed:0.07 green:0.07 blue:0.07 alpha:0.95]; 
        hassanyUI.layer.borderColor = [UIColor redColor].CGColor;
        hassanyUI.layer.borderWidth = 1.5;
        hassanyUI.layer.cornerRadius = 15.0;
        hassanyUI.layer.shadowColor = [UIColor redColor].CGColor;
        hassanyUI.layer.shadowRadius = 20.0;
        hassanyUI.layer.shadowOpacity = 0.9;
        
        [mainMenu addSubview:hassanyUI];
        
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
        
        // بناء السكرولات النظيفة (بدون حدود مخربطة)
        for (int i = 0; i < 4; i++) {
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 75, 580, 310)];
            scrollView.tag = 8000 + i; 
            scrollView.backgroundColor = [UIColor clearColor]; 
            scrollView.showsVerticalScrollIndicator = NO; 
            scrollView.alwaysBounceVertical = YES; // تفعيل النزول والصعود
            scrollView.hidden = (i != 0);
            [hassanyUI addSubview:scrollView];
        }
        
        // --- قسم الإعدادات (الفخم) ---
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
        [btnChannel addTarget:mainMenu action:@selector(openHasanyChannel:) forControlEvents:UIControlEventTouchUpInside];
        [tab3 addSubview:btnChannel];
        
        UIButton *btnDev = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDev.frame = CGRectMake(190, 225, 200, 45);
        [btnDev setTitle:@"التواصل مع المطور" forState:UIControlStateNormal];
        btnDev.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        btnDev.layer.borderColor = [UIColor redColor].CGColor;
        btnDev.layer.borderWidth = 1.0;
        btnDev.layer.cornerRadius = 10;
        [btnDev addTarget:mainMenu action:@selector(openHasanyDev:) forControlEvents:UIControlEventTouchUpInside];
        [tab3 addSubview:btnDev];
        
        tab3.contentSize = CGSizeMake(580, 300);
        
        continuousRadar(mainMenu, hassanyUI);
    }
    
    [mainMenu bringSubviewToFront:hassanyUI];
}
%end

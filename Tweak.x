#import <UIKit/UIKit.h>

// ==========================================
// 1. تعريف الكلاسات (Interfaces)
// ==========================================
@interface GBModMenu : UIView
@end

// كلاس الزر الذكي (نظام علامة الصح ✔ و ☐)
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
    BOOL newState = !self.targetSwitch.isOn;
    [self.targetSwitch setOn:newState animated:YES];
    [self.targetSwitch sendActionsForControlEvents:UIControlEventValueChanged];
    [self.targetSwitch sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self updateLook];
}
- (void)updateLook {
    if (self.targetSwitch.isOn) {
        [self setTitle:[NSString stringWithFormat:@"✔  %@", self.baseTitle] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:0.95];
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor redColor].CGColor;
    } else {
        [self setTitle:[NSString stringWithFormat:@"☐  %@", self.baseTitle] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.8];
        self.layer.borderWidth = 0.0;
    }
}
@end

// ==========================================
// 3. تغيير الأسماء الأصلية (Hooks)
// ==========================================
%hook UILabel
- (void)setText:(NSString *)text {
    if (text != nil && [text isKindOfClass:[NSString class]]) {
        NSString *newText = text;
        
        if ([text containsString:@"i3rby Store"]) { newText = @"hassanyIPA"; }
        else if ([text containsString:@"ايفون بالعربي"]) { newText = @""; }
        else if ([text containsString:@"السحب الابتدائي"]) { newText = @"توقع الضربه القويه"; }
        else if ([text containsString:@"البشرنة"]) { newText = @"أسلوب اللعب"; }
        else if ([text isEqualToString:@"الرسوم"]) { newText = @"طريقة العرض"; }
        else if ([text containsString:@"الكره الخاطئة"]) { newText = @"تنبيه الكره الخاطئة"; }
        
        %orig(newText);
    } else {
        %orig(text);
    }
}
%end

// ==========================================
// 4. محرك البناء والخطف الدقيق (C-Functions)
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

static UIView* getRowForLabel(UILabel *lbl) {
    UIView *parent = lbl.superview;
    if (parent && parent.bounds.size.height >= 20 && parent.bounds.size.height <= 90) return parent;
    if (parent.superview && parent.superview.bounds.size.height >= 20 && parent.superview.bounds.size.height <= 90) return parent.superview;
    return parent;
}

// دالة تكسر قيود الزر القديم وتبنيه بالتصميم الجديد
static void hijackRow(UIView *row, NSString *targetName, UIScrollView *scroll, CGFloat *offset) {
    row.tag = 9999;
    [row removeFromSuperview];
    
    // تدمير القيود القديمة حتى ما يتداخل ولا يصير بالنص
    [row removeConstraints:row.constraints];
    row.translatesAutoresizingMaskIntoConstraints = YES;
    
    CGFloat h = row.bounds.size.height;
    if (h < 30 || h > 90) h = 50; 
    
    row.frame = CGRectMake(10, *offset, 560, h);
    row.backgroundColor = [UIColor clearColor];
    
    UISwitch *sw = nil;
    UISlider *sl = nil;
    UISegmentedControl *seg = nil;
    UILabel *txt = nil;
    
    for (UIView *v in row.subviews) {
        if ([v isKindOfClass:[UISwitch class]]) sw = (UISwitch *)v;
        else if ([v isKindOfClass:[UISlider class]]) sl = (UISlider *)v;
        else if ([v isKindOfClass:[UISegmentedControl class]]) seg = (UISegmentedControl *)v;
        else if ([v isKindOfClass:[UILabel class]]) txt = (UILabel *)v;
    }
    
    if (sw && txt) {
        sw.alpha = 0.0; 
        txt.alpha = 0.0; 
        
        CBToggle *btn = [CBToggle buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 560, h);
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        btn.layer.cornerRadius = 10;
        btn.baseTitle = targetName;
        btn.targetSwitch = sw;
        
        [btn addTarget:btn action:@selector(btnTapped) forControlEvents:UIControlEventTouchUpInside];
        [btn updateLook]; 
        
        [row addSubview:btn];
    } else {
        if (txt) { txt.textColor = [UIColor whiteColor]; txt.font = [UIFont boldSystemFontOfSize:15]; }
        if (sl) { sl.minimumTrackTintColor = [UIColor redColor]; sl.thumbTintColor = [UIColor redColor]; }
        if (seg) {
            if (@available(iOS 13.0, *)) seg.selectedSegmentTintColor = [UIColor redColor];
            else seg.tintColor = [UIColor redColor];
            [seg setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
        }
    }
    
    [scroll addSubview:row];
    *offset += h + 15; // مسافة 15 بكسل بين كل زر لترتيب أقوى
    scroll.contentSize = CGSizeMake(580, *offset + 20); 
}

static CGFloat tabOffset0 = 10, tabOffset1 = 10, tabOffset2 = 10;

static void continuousRadar(UIView *mainMenu, UIView *hassanyUI) {
    UIScrollView *t0 = (UIScrollView *)[hassanyUI viewWithTag:8000];
    UIScrollView *t1 = (UIScrollView *)[hassanyUI viewWithTag:8001];
    UIScrollView *t2 = (UIScrollView *)[hassanyUI viewWithTag:8002];
    
    NSArray *targets0 = @[@"خطوط التوقع", @"توقع الخصم", @"حدود الطاولة", @"تنبيه الكره الخاطئة", @"حماية البث"];
    NSArray *targets1 = @[@"طريقة العرض", @"إزاحة Y", @"إزاحة X", @"مقياس X", @"مقياس Y", @"سمك الخط", @"شفافية الخط", @"نقطة النهاية", @"حلقة الجيب", @"توقع الضربه القويه"];
    NSArray *targets2 = @[@"زر الاختصار", @"إيقاف عند اللمس", @"نمط دوران", @"وضع التصويب", @"أسلوب اللعب", @"مستوى اللعب", @"وضع الكسر", @"قوة التصويب", @"سرعة تصويب"];
    
    if (t0) {
        for (NSString *name in targets0) {
            UILabel *lbl = findLabel(mainMenu, name);
            if (lbl) hijackRow(getRowForLabel(lbl), name, t0, &tabOffset0);
        }
    }
    if (t1) {
        for (NSString *name in targets1) {
            UILabel *lbl = findLabel(mainMenu, name);
            if (lbl) hijackRow(getRowForLabel(lbl), name, t1, &tabOffset1);
        }
    }
    if (t2) {
        for (NSString *name in targets2) {
            UILabel *lbl = findLabel(mainMenu, name);
            if (lbl) hijackRow(getRowForLabel(lbl), name, t2, &tabOffset2);
        }
    }
    
    for (UIView *sub in mainMenu.subviews) {
        if (sub.tag != 7777) { 
            sub.alpha = 0.01; 
            sub.userInteractionEnabled = NO; 
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        continuousRadar(mainMenu, hassanyUI);
    });
}

// ==========================================
// 5. بناء واجهة المنيو الرئيسية
// ==========================================
%hook GBModMenu

%new
- (void)hassanyTabChanged:(UISegmentedControl *)sender {
    UIView *hassanyUI = [self viewWithTag:7777];
    for (int i = 0; i < 4; i++) {
        UIView *container = [hassanyUI viewWithTag:8000 + i];
        container.hidden = (i != sender.selectedSegmentIndex);
    }
}

%new
- (void)hassanyOpenChannel {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/hassanyIPA"] options:@{} completionHandler:nil];
}

%new
- (void)hassanyOpenDev {
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
        [tabs addTarget:self action:@selector(hassanyTabChanged:) forControlEvents:UIControlEventValueChanged];
        
        if (@available(iOS 13.0, *)) {
            tabs.selectedSegmentTintColor = [UIColor colorWithRed:0.8 green:0.0 blue:0.0 alpha:1.0];
        } else {
            tabs.tintColor = [UIColor colorWithRed:0.8 green:0.0 blue:0.0 alpha:1.0];
        }
        [tabs setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont boldSystemFontOfSize:15]} forState:UIControlStateNormal];
        [hassanyUI addSubview:tabs];
        
        for (int i = 0; i < 4; i++) {
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 75, 580, 310)];
            scrollView.tag = 8000 + i; 
            scrollView.backgroundColor = [UIColor clearColor]; 
            scrollView.showsVerticalScrollIndicator = NO; 
            scrollView.alwaysBounceVertical = YES; 
            scrollView.hidden = (i != 0);
            [hassanyUI addSubview:scrollView];
        }
        
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
        [btnChannel addTarget:self action:@selector(hassanyOpenChannel) forControlEvents:UIControlEventTouchUpInside];
        [tab3 addSubview:btnChannel];
        
        UIButton *btnDev = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDev.frame = CGRectMake(190, 225, 200, 45);
        [btnDev setTitle:@"التواصل مع المطور" forState:UIControlStateNormal];
        btnDev.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        btnDev.layer.borderColor = [UIColor redColor].CGColor;
        btnDev.layer.borderWidth = 1.0;
        btnDev.layer.cornerRadius = 10;
        [btnDev addTarget:self action:@selector(hassanyOpenDev) forControlEvents:UIControlEventTouchUpInside];
        [tab3 addSubview:btnDev];
        
        tab3.contentSize = CGSizeMake(580, 300);
        
        continuousRadar(mainMenu, hassanyUI);
    }
    
    [mainMenu bringSubviewToFront:hassanyUI];
}
%end

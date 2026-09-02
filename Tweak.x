#import <UIKit/UIKit.h>

@interface GBModMenu : UIView
- (void)tabChanged:(UISegmentedControl *)sender;
- (void)openHasanyChannel:(id)sender;
- (void)openHasanyDev:(id)sender;
@end

// ==========================================
// 1. نظام تغيير النصوص (يعمل قبل ظهور المنيو)
// ==========================================
%hook UILabel
- (void)setText:(NSString *)text {
    if (!text || ![text isKindOfClass:[NSString class]]) { 
        %orig; 
        return; 
    }
    
    NSString *newText = text;
    if ([text containsString:@"i3rby Store"]) { newText = @"hassanyIPA"; }
    else if ([text containsString:@"ايفون بالعربي"]) { newText = @""; }
    else if ([text containsString:@"السحب الابتدائي"]) { newText = @"توقع الضربه القويه"; }
    else if ([text containsString:@"البشرنة"]) { newText = @"أسلوب اللعب"; }
    else if ([text isEqualToString:@"الرسوم"]) { newText = @"طريقة العرض"; }
    else if ([text containsString:@"الكره الخاطئة"]) { newText = @"تنبيه الكره الخاطئة"; }
    
    %orig(newText);
}
%end

// ==========================================
// 2. دوال البحث والخطف (مفصولة لمنع الكراش)
// ==========================================
// دالة تبحث عن النص وترجع الـ Label
static UILabel* findLabel(UIView *root, NSString *searchText) {
    if (root.tag == 7777) return nil; // لا تبحث داخل تصميمنا
    
    if ([root isKindOfClass:[UILabel class]]) {
        if ([[(UILabel *)root text] containsString:searchText]) return (UILabel *)root;
    }
    for (UIView *sub in root.subviews) {
        UILabel *found = findLabel(sub, searchText);
        if (found) return found;
    }
    return nil;
}

// دالة تجيب السطر الكامل اللي يحتوي على الـ Label وأزرار التحكم
static UIView* findTrueRow(UILabel *label) {
    UIView *current = label.superview;
    while (current != nil) {
        for (UIView *sub in current.subviews) {
            if ([sub isKindOfClass:[UISwitch class]] || [sub isKindOfClass:[UISlider class]] || [sub isKindOfClass:[UISegmentedControl class]]) {
                return current; // لگينا السطر الحقيقي
            }
        }
        if ([current isKindOfClass:[UIScrollView class]]) break;
        current = current.superview;
    }
    return label.superview; 
}

// دالة تلوين وترتيب السطر المسحوب
static void styleHijackedRow(UIView *row) {
    row.backgroundColor = [UIColor clearColor];
    row.userInteractionEnabled = YES;
    
    for (UIView *sub in row.subviews) {
        if ([sub isKindOfClass:[UILabel class]]) {
            ((UILabel *)sub).textColor = [UIColor whiteColor];
            ((UILabel *)sub).font = [UIFont boldSystemFontOfSize:15];
            ((UILabel *)sub).adjustsFontSizeToFitWidth = YES;
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
            [((UISegmentedControl *)sub) setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
        }
        styleHijackedRow(sub); 
    }
}

// ==========================================
// 3. الرادار المتكرر (يسحب الأزرار ويرتبها)
// ==========================================
static void executeRadar(UIView *mainMenu, UIView *hassanyUI, int attempt) {
    if (attempt > 25) return; // إيقاف الرادار بعد عدة محاولات
    
    // نبحث عن أول زر للتأكد أن القائمة الأصلية تم بناؤها
    UILabel *markerLabel = findLabel(mainMenu, @"خطوط التوقع");
    
    if (markerLabel != nil) {
        UIScrollView *tab0 = (UIScrollView *)[hassanyUI viewWithTag:8000];
        UIScrollView *tab1 = (UIScrollView *)[hassanyUI viewWithTag:8001];
        UIScrollView *tab2 = (UIScrollView *)[hassanyUI viewWithTag:8002];
        
        // الأسماء الجديدة اللي تم تغييرها بالـ hook
        NSArray *targetsTab0 = @[@"خطوط التوقع", @"توقع الخصم", @"حدود الطاولة", @"تنبيه الكره الخاطئة", @"حماية البث"];
        NSArray *targetsTab1 = @[@"طريقة العرض", @"إزاحة Y", @"إزاحة X", @"مقياس X", @"مقياس Y", @"سمك الخط", @"شفافية الخط", @"نقطة النهاية", @"حلقة الجيب", @"توقع الضربه القويه"];
        NSArray *targetsTab2 = @[@"زر الاختصار", @"إيقاف عند اللمس", @"نمط دوران", @"وضع التصويب", @"أسلوب اللعب", @"مستوى اللعب", @"وضع الكسر", @"قوة التصويب", @"سرعة تصويب"];
        
        void (^plantButtons)(NSArray *, UIScrollView *) = ^(NSArray *targets, UIScrollView *scroll) {
            CGFloat currentY = 10;
            for (NSString *targetName in targets) {
                UILabel *lbl = findLabel(mainMenu, targetName);
                if (lbl) {
                    UIView *row = findTrueRow(lbl);
                    if (row) {
                        [row removeFromSuperview]; // سحب
                        
                        // تدمير قيود الايفون الأصلية وإجبار القياسات الجديدة
                        row.translatesAutoresizingMaskIntoConstraints = YES;
                        row.frame = CGRectMake(10, currentY, 560, 50);
                        row.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                        
                        styleHijackedRow(row);
                        [scroll addSubview:row];
                        currentY += 60; // ترك مسافة بين كل زر
                    }
                }
            }
            scroll.contentSize = CGSizeMake(580, currentY + 20);
        };
        
        plantButtons(targetsTab0, tab0);
        plantButtons(targetsTab1, tab1);
        plantButtons(targetsTab2, tab2);
        
        // إخفاء المنيو القديم تماماً بعد السحب بنجاح
        for (UIView *sub in mainMenu.subviews) {
            if (sub.tag != 7777) {
                sub.alpha = 0.0;
                sub.hidden = YES;
                sub.userInteractionEnabled = NO;
            }
        }
    } else {
        // إذا الأزرار ما ظهرت، نعيد البحث بعد نصف ثانية
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            executeRadar(mainMenu, hassanyUI, attempt + 1);
        });
    }
}

// ==========================================
// 4. بناء الواجهة والتصميم
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
    
    // الخدعة: إبقاء العناصر القديمة مرئية للنظام بنسبة 1% حتى يجبره يبني الأزرار
    for (UIView *sub in mainMenu.subviews) {
        if (sub.tag != 7777) {
            sub.alpha = 0.01; 
        }
    }
    
    UIView *hassanyUI = [mainMenu viewWithTag:7777];
    if (!hassanyUI) {
        hassanyUI = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 620, 400)];
        hassanyUI.tag = 7777;
        hassanyUI.backgroundColor = [UIColor colorWithRed:0.07 green:0.07 blue:0.07 alpha:1.0]; 
        hassanyUI.layer.borderColor = [UIColor redColor].CGColor;
        hassanyUI.layer.borderWidth = 2.0;
        hassanyUI.layer.cornerRadius = 15.0;
        hassanyUI.layer.shadowColor = [UIColor redColor].CGColor;
        hassanyUI.layer.shadowRadius = 25.0;
        hassanyUI.layer.shadowOpacity = 1.0;
        
        [mainMenu addSubview:hassanyUI];
        
        UISegmentedControl *tabs = [[UISegmentedControl alloc] initWithItems:@[@"التوقع", @"طريقة العرض", @"اللعب التلقائي", @"الإعدادات"]];
        tabs.frame = CGRectMake(20, 20, 580, 45);
        tabs.selectedSegmentIndex = 0; 
        [tabs addTarget:self action:@selector(tabChanged:) forControlEvents:UIControlEventValueChanged];
        
        if (@available(iOS 13.0, *)) {
            tabs.selectedSegmentTintColor = [UIColor colorWithRed:0.8 green:0.0 blue:0.0 alpha:1.0];
        } else {
            tabs.tintColor = [UIColor colorWithRed:0.8 green:0.0 blue:0.0 alpha:1.0];
        }
        [tabs setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont boldSystemFontOfSize:15]} forState:UIControlStateNormal];
        [hassanyUI addSubview:tabs];
        
        // حاويات الأقسام
        for (int i = 0; i < 4; i++) {
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 80, 580, 300)];
            scrollView.tag = 8000 + i; 
            scrollView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.6];
            scrollView.layer.cornerRadius = 10;
            scrollView.layer.borderColor = [UIColor colorWithRed:0.4 green:0.0 blue:0.0 alpha:1.0].CGColor;
            scrollView.layer.borderWidth = 1.0;
            scrollView.hidden = (i != 0);
            [hassanyUI addSubview:scrollView];
        }
        
        // --- قسم الإعدادات ---
        UIScrollView *tab3 = (UIScrollView *)[hassanyUI viewWithTag:8003];
        UIImageView *profilePic = [[UIImageView alloc] initWithFrame:CGRectMake(240, 20, 100, 100)];
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
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, 580, 30)];
        nameLabel.text = @"Hassany Premium Mod";
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont boldSystemFontOfSize:22];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [tab3 addSubview:nameLabel];
        
        UIButton *btnChannel = [UIButton buttonWithType:UIButtonTypeCustom];
        btnChannel.frame = CGRectMake(190, 180, 200, 45);
        [btnChannel setTitle:@"قناة التيليجرام" forState:UIControlStateNormal];
        btnChannel.backgroundColor = [UIColor colorWithRed:0.8 green:0.0 blue:0.0 alpha:1.0];
        btnChannel.layer.cornerRadius = 10;
        [btnChannel addTarget:mainMenu action:@selector(openHasanyChannel:) forControlEvents:UIControlEventTouchUpInside];
        [tab3 addSubview:btnChannel];
        
        UIButton *btnDev = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDev.frame = CGRectMake(190, 235, 200, 45);
        [btnDev setTitle:@"التواصل مع المطور" forState:UIControlStateNormal];
        btnDev.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        btnDev.layer.borderColor = [UIColor redColor].CGColor;
        btnDev.layer.borderWidth = 1.0;
        btnDev.layer.cornerRadius = 10;
        [btnDev addTarget:mainMenu action:@selector(openHasanyDev:) forControlEvents:UIControlEventTouchUpInside];
        [tab3 addSubview:btnDev];
        
        tab3.contentSize = CGSizeMake(580, 320);
        
        // تشغيل الرادار
        executeRadar(mainMenu, hassanyUI, 0);
    }
    
    [mainMenu bringSubviewToFront:hassanyUI];
}
%end

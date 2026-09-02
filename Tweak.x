#import <UIKit/UIKit.h>

@interface GBModMenu : UIView
- (void)tabChanged:(UISegmentedControl *)sender;
- (void)openHasanyChannel:(id)sender;
- (void)openHasanyDev:(id)sender;
@end

// ==========================================
// 1. نظام تغيير النصوص والأسماء
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
    else if ([text containsString:@"السحب الابتدائي"]) { newText = @"توقع الضربه القويه (ينصح به)"; }
    else if ([text containsString:@"البشرنة"]) { newText = @"أسلوب اللعب"; }
    else if ([text isEqualToString:@"الرسوم"]) { newText = @"طريقة العرض"; }
    else if ([text containsString:@"الكره الخاطئة"]) { newText = @"تنبيه الكره الخاطئة"; }
    
    %orig(newText);
}
%end

// ==========================================
// 2. أدوات الخطف والتصميم
// ==========================================
static UIView* extractRow(UIView *root, NSString *searchText) {
    if (root.tag == 7777) return nil; // حماية: لا تبحث داخل تصميم الحسني
    
    if ([root isKindOfClass:[UILabel class]]) {
        if ([[(UILabel *)root text] containsString:searchText]) {
            UIView *parent = root.superview;
            if (parent && parent.bounds.size.height >= 20 && parent.bounds.size.height <= 150 && parent != root) {
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
// 3. محرك الرادار (تم تحويله لدالة مستقلة لحل مشكلة الكومبايلر)
// ==========================================
static void executeHijackRadar(UIView *mainMenu, UIView *hassanyUI, int attempts) {
    UIView *marker = extractRow(mainMenu, @"خطوط التوقع");
    
    // إذا لگى الأزرار أو حاول أكثر من 15 مرة
    if (marker || attempts > 15) {
        
        UIScrollView *tab0 = (UIScrollView *)[hassanyUI viewWithTag:8000];
        UIScrollView *tab1 = (UIScrollView *)[hassanyUI viewWithTag:8001];
        UIScrollView *tab2 = (UIScrollView *)[hassanyUI viewWithTag:8002];
        UIScrollView *tab3 = (UIScrollView *)[hassanyUI viewWithTag:8003];
        
        NSArray *targetsTab0 = @[@"خطوط التوقع", @"توقع الخصم", @"حدود الطاولة", @"تنبيه الكره الخاطئة", @"حماية البث"];
        NSArray *targetsTab1 = @[@"طريقة العرض", @"إزاحة Y", @"إزاحة X", @"مقياس X", @"مقياس Y", @"سمك الخط", @"شفافية الخط", @"نقطة النهاية", @"حلقة الجيب", @"توقع الضربه القويه"];
        NSArray *targetsTab2 = @[@"زر الاختصار", @"إيقاف عند اللمس", @"نمط دوران", @"وضع التصويب", @"أسلوب اللعب", @"مستوى اللعب", @"وضع الكسر", @"قوة التصويب", @"سرعة تصويب"];
        
        void (^plantButtons)(NSArray *, UIScrollView *) = ^(NSArray *targets, UIScrollView *scroll) {
            CGFloat currentY = 0;
            for (NSString *targetName in targets) {
                UIView *row = extractRow(mainMenu, targetName);
                if (row) {
                    [row removeFromSuperview];
                    row.translatesAutoresizingMaskIntoConstraints = YES; // حل مشكلة اختفاء الأزرار
                    row.alpha = 1.0;
                    row.hidden = NO;
                    
                    CGFloat h = row.frame.size.height > 20 ? row.frame.size.height : 50;
                    row.frame = CGRectMake(10, currentY, 560, h);
                    
                    styleHijackedRow(row);
                    [scroll addSubview:row];
                    currentY += h + 10;
                }
            }
            scroll.contentSize = CGSizeMake(580, currentY + 20);
        };
        
        plantButtons(targetsTab0, tab0);
        plantButtons(targetsTab1, tab1);
        plantButtons(targetsTab2, tab2);
        
        // طمس المنيو القديم بالكامل
        for (UIView *sub in mainMenu.subviews) {
            if (sub.tag != 7777) {
                sub.alpha = 0.0;
                sub.userInteractionEnabled = NO;
            }
        }
        
        // --- قسم الإعدادات ---
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
        
    } else {
        // إعادة المحاولة بعد نصف ثانية إذا الأزرار ما مبنية بعد
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            executeHijackRadar(mainMenu, hassanyUI, attempts + 1);
        });
    }
}

// ==========================================
// 4. البناء والواجهة الأساسية
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
        
        for (int i = 0; i < 4; i++) {
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 80, 580, 300)];
            scrollView.tag = 8000 + i; 
            scrollView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.6];
            scrollView.layer.cornerRadius = 10;
            scrollView.layer.borderColor = [UIColor colorWithRed:0.4 green:0.0 blue:0.0 alpha:1.0].CGColor;
            scrollView.layer.borderWidth = 1.0;
            scrollView.hidden = (i != 0);
            scrollView.contentInset = UIEdgeInsetsMake(10, 0, 20, 0); 
            [hassanyUI addSubview:scrollView];
        }
        
        // تشغيل الرادار المدرع
        executeHijackRadar(mainMenu, hassanyUI, 0);
    }
    
    [mainMenu bringSubviewToFront:hassanyUI];
}
%end

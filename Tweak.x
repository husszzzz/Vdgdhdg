#import <UIKit/UIKit.h>
#import <objc/runtime.h>

// ==========================================================
// فاحص الكلمات الذكي (Smart Keyword Checker)
// ==========================================================
static BOOL containsWelcomeKeywords(NSString *text) {
    if (!text || text.length == 0) return NO;
    
    // قائمة الكلمات الدلالية لرسائل الترحيب والحقوق
    NSArray *keywords = @[
        @"مرحبا", @"مرحباً", @"أهلا", @"أهلاً", @"ترحيب", @"متجر", @"تطوير", @"حقوق",
        @"اشتراك", @"قناة", @"تليجرام", @"تلي", @"سورس", @"حياك", @"حياكم", @"كود",
        @"welcome", @"hello", @"enjoy", @"developed", @"developer", @"channel", 
        @"telegram", @"store", @"t.me", @"crack", @"hacked", @"by:", @"vip"
    ];
    
    NSString *lower = [text lowercaseString];
    for (NSString *kw in keywords) {
        if ([lower containsString:[kw lowercaseString]]) {
            return YES;
        }
    }
    return NO;
}

// دالة تفحص كل النصوص داخل أي واجهة أو نافذة مخصصة
static BOOL viewTreeHasWelcomeText(UIView *view) {
    if (!view) return NO;
    
    if ([view isKindOfClass:[UILabel class]]) {
        if (containsWelcomeKeywords([(UILabel *)view text])) return YES;
    } else if ([view isKindOfClass:[UIButton class]]) {
        if (containsWelcomeKeywords([(UIButton *)view currentTitle])) return YES;
    } else if ([view isKindOfClass:[UITextView class]]) {
        if (containsWelcomeKeywords([(UITextView *)view text])) return YES;
    } else if ([view isKindOfClass:[UITextField class]]) {
        if (containsWelcomeKeywords([(UITextField *)view placeholder])) return YES;
    }
    
    for (UIView *sub in view.subviews) {
        if (viewTreeHasWelcomeText(sub)) return YES;
    }
    return NO;
}

// ==========================================================
// 1. هوك اعتراض رسائل النظام الحديثة (UIAlertController)
// ==========================================================
%hook UIViewController

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    
    // فحص رسائل الـ Alert العادية
    if ([viewControllerToPresent isKindOfClass:[UIAlertController class]]) {
        UIAlertController *alert = (UIAlertController *)viewControllerToPresent;
        NSString *title = alert.title ? alert.title : @"";
        NSString *message = alert.message ? alert.message : @"";
        
        if (containsWelcomeKeywords(title) || containsWelcomeKeywords(message)) {
            // اعتراض فوري: إخفاء التنبيه بدون عرضه نهائياً
            if (completion) completion();
            return;
        }
    }
    
    // فحص الواجهات المخصصة (مثل الشاشات الفخمة والبلور)
    if (viewTreeHasWelcomeText(viewControllerToPresent.view)) {
        if (completion) completion();
        return; // منع ظهور الشاشة المخصصة
    }
    
    %orig(viewControllerToPresent, flag, completion);
}

%end

// ==========================================================
// 2. هوك اعتراض الرسائل الكلاسيكية القديمة (UIAlertView)
// ==========================================================
%hook UIAlertView

- (void)show {
    NSString *title = [self title] ?: @"";
    NSString *message = [self message] ?: @"";
    
    if (containsWelcomeKeywords(title) || containsWelcomeKeywords(message)) {
        // حظر الظهور
        return;
    }
    %orig;
}

%end

// ==========================================================
// 3. هوك النوافذ الطافية المباشرة (Direct Window Overlays)
// ==========================================================
%hook UIWindow

- (void)addSubview:(UIView *)view {
    // إذا حاول أي ملف حقن نافذة عائمة ترحيبية مباشرة على شاشة التطبيق
    if (viewTreeHasWelcomeText(view)) {
        view.hidden = YES;
        view.alpha = 0.0;
        [view removeFromSuperview];
        return;
    }
    %orig(view);
}

%end

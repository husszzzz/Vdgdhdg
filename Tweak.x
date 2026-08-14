#import <UIKit/UIKit.h>

// 1. هذا السطر هو الحل! يخبر المترجم أن هذا الكلاس هو واجهة عادية
@interface iKiraPlusVC : UIViewController
@end

// ==========================================================
// 2. هوك لتدمير كلاس رسالة كيرا من الداخل
// ==========================================================
%hook iKiraPlusVC

- (void)viewDidLoad {
    %orig; // السماح للنظام بإكمال عمله الطبيعي
    
    // إخفاء الشاشة وتصفير شفافيتها
    self.view.hidden = YES;
    self.view.alpha = 0.0;
    
    // تعطيل اللمس حتى لا تعلق الشاشة
    self.view.userInteractionEnabled = NO;
    
    // إغلاق الواجهة تلقائياً في الخلفية (Dismiss)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    });
}

%end

// ==========================================================
// 3. حماية إضافية: منع اللعبة من عرض هذا الكلاس نهائياً
// ==========================================================
%hook UIViewController

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    
    // سحب اسم الشاشة اللي تحاول تظهر
    NSString *className = NSStringFromClass([viewControllerToPresent class]);
    
    // إذا كان اسمها iKiraPlusVC، نرفض العرض فوراً
    if ([className containsString:@"iKiraPlusVC"]) {
        if (completion) completion();
        return; // حظر الظهور
    }
    
    // إذا شاشة طبيعية، نعرضها
    %orig;
}

%end

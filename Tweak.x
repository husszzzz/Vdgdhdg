#import <UIKit/UIKit.h>

// ==========================================================
// 1. هوك لتدمير كلاس رسالة كيرا من الداخل
// ==========================================================
%hook iKiraPlusVC

- (void)viewDidLoad {
    %orig; // خلي النظام يكمل شغله الطبيعي
    
    // إخفاء الشاشة وتصفير شفافيتها
    self.view.hidden = YES;
    self.view.alpha = 0.0;
    
    // تعطيل اللمس حتى لا تعلق الشاشة عندك وتصير شفافة وتمنعك من اللعب
    self.view.userInteractionEnabled = NO;
    
    // إغلاق الواجهة تلقائياً في الخلفية (Dismiss)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    });
}

%end

// ==========================================================
// 2. حماية إضافية: منع اللعبة من عرض هذا الكلاس نهائياً
// ==========================================================
%hook UIViewController

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    
    // نجيب اسم الشاشة اللي تحاول تظهر هسه
    NSString *className = NSStringFromClass([viewControllerToPresent class]);
    
    // إذا كان اسمها iKiraPlusVC، نرفض العرض فوراً
    if ([className containsString:@"iKiraPlusVC"]) {
        if (completion) completion();
        return; // حظر الظهور
    }
    
    // إذا شاشة طبيعية باللعبة، نعرضها طبيعي
    %orig;
}

%end

#import <UIKit/UIKit.h>

@interface iKiraPlusVC : UIViewController
@end

// ==========================================================
// 1. هوك تدمير واجهة الترحيب (iKiraPlusVC)
// ==========================================================
%hook iKiraPlusVC
- (void)viewDidLoad {
    %orig; 
    self.view.hidden = YES;
    self.view.alpha = 0.0;
    self.view.userInteractionEnabled = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    });
}
%end

%hook UIViewController
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    NSString *className = NSStringFromClass([viewControllerToPresent class]);
    if ([className containsString:@"iKiraPlusVC"]) {
        if (completion) completion();
        return;
    }
    %orig;
}
%end

// ==========================================================
// 2. هوك خطير لاصطياد نصوص SwiftUI المدمجة وتغييرها باسمك
// ==========================================================
%hook NSAttributedString

- (id)initWithString:(NSString *)str {
    // التأكد من أن النص موجود لتجنب الكراش
    if (str && [str isKindOfClass:[NSString class]]) {
        
        // استبدال النص الأول
        if ([str containsString:@"Vip Active by iKiraPlus"]) {
            str = [str stringByReplacingOccurrencesOfString:@"Vip Active by iKiraPlus" withString:@"Vip Active by Hasany Store"];
        }
        // استبدال النص الثاني
        if ([str containsString:@"تعديل كيرا بلس"]) {
            str = [str stringByReplacingOccurrencesOfString:@"تعديل كيرا بلس" withString:@"تعديل حساني ستور"];
        }
        // تنظيف عام لأي مكان يظهر فيه اسم المطور القديم
        if ([str containsString:@"iKiraPlus"]) {
            str = [str stringByReplacingOccurrencesOfString:@"iKiraPlus" withString:@"Hasany"];
        }
    }
    return %orig(str);
}

%end

// ==========================================================
// 3. هوك احتياطي لقواميس النظام (Localization)
// ==========================================================
%hook NSBundle
- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName {
    NSString *origText = %orig;
    if (origText && [origText isKindOfClass:[NSString class]]) {
        if ([origText containsString:@"iKiraPlus"]) {
            origText = [origText stringByReplacingOccurrencesOfString:@"iKiraPlus" withString:@"Hasany Store"];
        }
        if ([origText containsString:@"كيرا"]) {
            origText = [origText stringByReplacingOccurrencesOfString:@"كيرا" withString:@"حساني"];
        }
    }
    return origText;
}
%end

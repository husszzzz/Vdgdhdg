#import <UIKit/UIKit.h>

// هوك لاستهداف أي تنبيه يظهر في التطبيق
%hook UIAlertController

- (void)viewDidAppear:(BOOL)animated {
    // إخفاء التنبيه فوراً بدون أن يشعر المستخدم
    [self dismissViewControllerAnimated:NO completion:nil];
    
    // تنفيذ الأمر الأصلي للتطبيق (بدون إظهار الواجهة)
    %orig(NO); 
}

%end

// هوك إضافي لتعطيل الـ UIAlertView القديم بطريقة لا تسبب خطأ في البناء
%hook UIView
- (void)didAddSubview:(UIView *)subview {
    %orig;
    if ([subview isKindOfClass:NSClassFromString(@"UIAlertView")]) {
        [subview setHidden:YES];
        [subview removeFromSuperview];
    }
}
%end

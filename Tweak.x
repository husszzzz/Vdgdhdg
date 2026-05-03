#import <UIKit/UIKit.h>

// --- تغيير حقوق الـ UILabel ---
%hook UILabel
- (void)setText:(NSString *)text {
    if (text && ([text containsString:@"Designed by"] || 
                 [text containsString:@"Created by"] || 
                 [text containsString:@"Copyright"] ||
                 [text containsString:@"Developed by"])) {
        
        %orig(@"Hassany Property ✅");
    } else {
        %orig(text);
    }
}
%end

// --- تغيير حقوق الأزرار ---
%hook UIButton
- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    // هنا صلحنا الخطأ: حذفنا animations وخلينا الفلتر يعتمد على محتوى النص
    if (title && ([title containsString:@"Dev"] || [title containsString:@"By"])) {
        %orig(@"Hassany", state);
    } else {
        %orig(title, state);
    }
}
%end

// --- تغيير تنبيهات النظام ---
%hook UIAlertController
- (void)setTitle:(NSString *)title {
    %orig(@"Hassany Security");
}

- (void)setMessage:(NSString *)message {
    if (message && ([message containsString:@"vBy"] || [message containsString:@"@"])) {
        %orig(@"Modified by Hussein Al-Hassani");
    } else {
        %orig(message);
    }
}
%end

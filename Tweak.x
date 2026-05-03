#import <UIKit/UIKit.h>

// هوك على الـ UILabel (أكثر مكان تظهر فيه الحقوق والأسماء)
%hook UILabel

- (void)setText:(NSString *)text {
    // قائمة بالكلمات التي تريد استبدالها (مثلاً: حقوق المطور الأصلي)
    // يمكنك إضافة أي اسم تلاحظه في الدليبات الأخرى هنا
    if ([text containsString:@"Designed by"] || 
        [text containsString:@"Created by"] || 
        [text containsString:@"Copyright"] ||
        [text containsString:@"Developed by"]) {
        
        %orig(@"Hassany Property ✅"); // يغير السطر بالكامل
    } else {
        %orig(text);
    }
}

%end

// هوك على الأزرار (Buttons)
%hook UIButton

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    if ([title animations] || [title containsString:@"Dev"]) {
        %orig(@"Hassany", state);
    } else {
        %orig(title, state);
    }
}

%end

// هوك شامل على تنبيهات النظام (Alerts)
%hook UIAlertController

- (void)setTitle:(NSString *)title {
    if (title) {
        %orig(@"Hassany Security");
    } else {
        %orig(title);
    }
}

- (void)setMessage:(NSString *)message {
    if ([message containsString:@"vBy"] || [message containsString:@"@"]) {
        %orig(@"Modified by Hussein Al-Hassani");
    } else {
        %orig(message);
    }
}

%end

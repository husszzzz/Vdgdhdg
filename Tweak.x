#import <UIKit/UIKit.h>

// ==========================================
// كود تغيير نصوص التطبيق (مخصص لمحول الفيديو)
// ==========================================

%hook UILabel

// 1. التعديل على النصوص العادية
- (void)setText:(NSString *)text {
    if ([text containsString:@"لثقتكم بنا"]) {
        %orig(@"تطبيق معدل بواسطة حسين الحسني ❤️"); 
    } else {
        %orig(text);
    }
}

// 2. التعديل على النصوص المنسقة (Attributed Text)
- (void)setAttributedText:(NSAttributedString *)attributedText {
    if (attributedText) {
        NSString *plainText = attributedText.string;
        
        if ([plainText containsString:@"لثقتكم بنا"]) {
            NSString *newText = @"تطبيق معدل بواسطة حسين الحسني ❤️";
            
            NSDictionary *attributes = [attributedText attributesAtIndex:0 effectiveRange:NULL];
            NSAttributedString *newAttributedText = [[NSAttributedString alloc] initWithString:newText attributes:attributes];
            
            %orig(newAttributedText);
            return;
        }
    }
    %orig(attributedText);
}

%end

// 3. التعديل على مربعات النصوص (UITextView) احتياطاً
%hook UITextView

- (void)setText:(NSString *)text {
    if ([text containsString:@"لثقتكم بنا"]) {
        %orig(@"تطبيق معدل بواسطة حسين الحسني ❤️"); 
    } else {
        %orig(text);
    }
}

%end

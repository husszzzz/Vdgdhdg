#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// ==========================================
// 1. الطريقة الأقوى: اصطياد الترجمات والنصوص من جذور النظام (NSBundle)
// ==========================================
%hook NSBundle

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName {
    NSString *originalString = %orig;
    
    // إذا التطبيق سحب الجملة من ملفات اللغة، نغيرها فوراً
    if ([originalString containsString:@"لثقتكم بنا"]) {
        return @"تطبيق معدل بواسطة حسين الحسني ❤️";
    }
    
    return originalString;
}

%end

// ==========================================
// 2. اصطياد UILabel (للنصوص العادية)
// ==========================================
%hook UILabel

- (void)setText:(NSString *)text {
    if ([text containsString:@"لثقتكم بنا"]) {
        %orig(@"تطبيق معدل بواسطة حسين الحسني ❤️"); 
    } else {
        %orig(text);
    }
}

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

// ==========================================
// 3. اصطياد UITextView (مربعات النصوص الكبيرة)
// ==========================================
%hook UITextView

- (void)setText:(NSString *)text {
    if ([text containsString:@"لثقتكم بنا"]) {
        %orig(@"تطبيق معدل بواسطة حسين الحسني ❤️"); 
    } else {
        %orig(text);
    }
}
%end

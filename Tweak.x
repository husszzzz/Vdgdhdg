#import <UIKit/UIKit.h>

%hook UILabel

// تغيير النص العادي
- (void)setText:(NSString *)text {
    if ([text isEqualToString:@"i3rby Store"]) {
        %orig(@"حسني");
    } else {
        %orig(text);
    }
}

// تغيير النص المنسق (في حال كانت الأداة تستخدم Attributed Text)
- (void)setAttributedText:(NSAttributedString *)attributedText {
    if ([attributedText.string isEqualToString:@"i3rby Store"]) {
        NSMutableAttributedString *newText = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
        [newText.mutableString setString:@"حسني"];
        %orig(newText);
    } else {
        %orig(attributedText);
    }
}

%end

// ==========================================
// كود تغيير نصوص وحقوق التطبيق 
// ==========================================
%hook UILabel

// التعديل على النصوص العادية
- (void)setText:(NSString *)text {
    // الكود يصيد الكلمة المميزة من الجملة
    if ([text containsString:@"لثقتكم بنا"]) {
        
        // النص الجديد اللي راح يظهر بالتطبيق (اكتب اللي يعجبك)
        %orig(@"تطبيق معدل بواسطة حسين الحسني ❤️"); 
        
    } else {
        // باقي نصوص التطبيق تظهر عادي
        %orig(text);
    }
}

// التعديل على النصوص المنسقة (Attributed Text)
- (void)setAttributedText:(NSAttributedString *)attributedText {
    if (attributedText) {
        NSString *plainText = attributedText.string;
        
        // نفس الكلمة نصيدها هنا
        if ([plainText containsString:@"لثقتكم بنا"]) {
            
            // النص الجديد مرة ثانية
            NSString *newText = @"تطبيق معدل بواسطة حسين الحسني ❤️";
            
            // للحفاظ على حجم ולون الخط الأصلي للتطبيق
            NSDictionary *attributes = [attributedText attributesAtIndex:0 effectiveRange:NULL];
            NSAttributedString *newAttributedText = [[NSAttributedString alloc] initWithString:newText attributes:attributes];
            
            %orig(newAttributedText);
            return;
        }
    }
    %orig(attributedText);
}

%end

#import <UIKit/UIKit.h>

// دالة ذكية لاستبدال النصوص في كل مكان داخل التطبيق
static NSString* replaceUIStrings(NSString *originalText) {
    if (!originalText || ![originalText isKindOfClass:[NSString class]]) {
        return originalText;
    }
    
    // تغيير اسم التطبيق أينما ظهر
    if ([originalText containsString:@"الصافرة"]) {
        return [originalText stringByReplacingOccurrencesOfString:@"الصافرة" withString:@"kicklive"];
    }
    
    // تغيير نصوص الإعدادات لتبدو احترافية وجديدة
    if ([originalText containsString:@"الدعم والتواصل"]) {
        return @"إصدار kicklive الاحترافي";
    }
    if ([originalText containsString:@"متابعة قناة التطبيق للتحديثات"]) {
        return @"قناة التطبيقات (@hassanyIPA)";
    }
    if ([originalText containsString:@"مشاركة التطبيق مع الأصدقاء"]) {
        return @"مطور النسخة (@OM_G9)";
    }
    if ([originalText containsString:@"لطلب إضافات أو الإبلاغ عن مشكلة"]) {
        return @"اكتشف المزيد من تطبيقاتنا";
    }
    
    return originalText;
}

// 1. اعتراض النصوص في UILabel (الخاصة بالتصميم الأساسي)
%hook UILabel
- (void)setText:(NSString *)text {
    %orig(replaceUIStrings(text));
}
%end

// 2. اعتراض النصوص من ملفات الترجمة (مهم جداً لتطبيقات SwiftUI)
%hook NSBundle
- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName {
    NSString *original = %orig;
    return replaceUIStrings(original);
}
%end

// 3. تغيير اسم التطبيق في النظام بشكل جذري
%hook NSBundle
- (id)objectForInfoDictionaryKey:(NSString *)key {
    if ([key isEqualToString:@"CFBundleDisplayName"] || [key isEqualToString:@"CFBundleName"]) {
        return @"kicklive";
    }
    return %orig;
}
%end

// ==========================================
// قسم اعتراض الأزرار والروابط (الخداع البرمجي)
// ==========================================

// 4. اعتراض أي رابط يفتحه التطبيق (مثل زر قناة التلجرام القديمة)
%hook UIApplication
- (void)openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenExternalURLOptionsKey, id> *)options completionHandler:(void (^)(BOOL success))completion {
    NSString *urlString = [url absoluteString];
    
    // إذا كان التطبيق يحاول فتح رابط تيليجرام أو موقع خارجي للقناة القديمة
    if ([urlString containsString:@"t.me/"] || [urlString containsString:@"telegram.org"]) {
        // نوجه المستخدم إجبارياً إلى قناتك
        NSURL *newChannelURL = [NSURL URLWithString:@"https://t.me/hassanyIPA"];
        %orig(newChannelURL, options, completion);
        return;
    }
    
    %orig;
}
%end

// 5. الخدعة الأقوى: اعتراض زر "مشاركة التطبيق"
// في العادة زر المشاركة يفتح نافذة UIActivityViewController
%hook UIViewController
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    
    // إذا ضغط المستخدم على زر "مشاركة التطبيق" (والذي حولنا اسمه إلى المطور)
    if ([viewControllerToPresent isKindOfClass:[UIActivityViewController class]]) {
        // نلغي ظهور نافذة المشاركة، ونفتح حساب المطور بدلاً منها!
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/OM_G9"] options:@{} completionHandler:nil];
        
        // لا ننفذ %orig حتى لا تظهر نافذة المشاركة القديمة
        return;
    }
    
    // السماح بفتح أي نوافذ أخرى طبيعية
    %orig;
}
%end

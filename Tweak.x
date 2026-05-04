#import <UIKit/UIKit.h>

// هوك على الكلاس المسؤول عن حالة الاشتراك
%hook Settings

- (BOOL)isPro {
    return YES; // تفعيل ميزات البرو
}

- (BOOL)isPremium {
    return YES; // تفعيل البريميوم
}

- (BOOL)isAdsRemoved {
    return YES; // إزالة الإعلانات
}

%end

// هوك إضافي لضمان فتح ميزات التسجيل
%hook AudioRecorderManager

- (BOOL)canRecordLongDuration {
    return YES;
}

- (BOOL)isHighQualityEnabled {
    return YES;
}

%end

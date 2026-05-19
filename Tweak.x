#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <stdlib.h>

// 1. حدد إحداثيات الدائرة الأساسية هنا
#define BASE_LATITUDE 33.3128   
#define BASE_LONGITUDE 44.3615  

// دالة لتوليد تذبذب عشوائي صغير جداً (حتى يبدو الموقع حقيقي 100% للسيرفر)
double getJitter() {
    // توليد رقم عشوائي صغير جداً بين -0.00005 و +0.00005
    return ((double)arc4random_uniform(100) - 50.0) / 1000000.0;
}

// 🍏 اعتراض كلاس الموقع الرئيسي
%hook CLLocation

- (CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D fakeCoord;
    // إضافة التذبذب العشوائي للإحداثيات الأصلية
    fakeCoord.latitude = BASE_LATITUDE + getJitter();
    fakeCoord.longitude = BASE_LONGITUDE + getJitter();
    return fakeCoord;
}

// تخطي فحص دقة الـ الـ GPS (تطبيقات التبصيم تطلب دقة عالية، فنثبتها على أفضل دقة)
- (CLLocationAccuracy)horizontalAccuracy {
    return 5.0; // دقة 5 أمتار (ممتازة جداً ومقبولة بالنظام)
}

- (CLLocationAccuracy)verticalAccuracy {
    return 5.0;
}

%end

// 🍏 اعتراض مدير الموقع لضمان إرسال البيانات للتطبيق فوراً وبدون انقطاع
%hook CLLocationManager

- (void)startUpdatingLocation {
    %orig;
    
    CLLocation *fakeLocation = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(BASE_LATITUDE + getJitter(), BASE_LONGITUDE + getJitter())
                                                             altitude:10.0
                                                   horizontalAccuracy:5.0
                                                     verticalAccuracy:5.0
                                                              timestamp:[NSDate date]];
    
    if ([self delegate] && [[self delegate] respondsToSelector:@selector(locationManager:didUpdateLocations:)]) {
        [[self delegate] locationManager:self didUpdateLocations:@[fakeLocation]];
    }
}

%end

// 🛡️ حماية إضافية: تخطي فحص الأمان والـ Jailbreak (تمنع الكراش داخل حاضر بلس)
%hook NSFileManager

- (BOOL)fileExistsAtPath:(NSString *)path {
    // إذا كان التطبيق يبحث عن ملفات جيلبريك أو أدوات حقن، نوهمه بأنها غير موجودة
    if ([path containsString:@"Cydia"] || 
        [path containsString:@"MobileSubstrate"] || 
        [path containsString:@"Sileo"] ||
        [path containsString:@".dylib"]) {
        return NO;
    }
    return %orig;
}

%end
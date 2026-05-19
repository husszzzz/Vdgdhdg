#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <stdlib.h>

// 📍 ضع إحداثيات موقع الدائرة هنا بدقة
#define TARGET_LATITUDE 33.3128   
#define TARGET_LONGITUDE 44.3615  

// دالة لتوليد حركة عشوائية طفيفة جداً تبهر السيرفر وتوهمه بأنه GPS حقيقي
double generateJitter() {
    return ((double)arc4random_uniform(120) - 60.0) / 1000000.0;
}

%hook CLLocation

- (CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D fakeCoord;
    fakeCoord.latitude = TARGET_LATITUDE + generateJitter();
    fakeCoord.longitude = TARGET_LONGITUDE + generateJitter();
    return fakeCoord;
}

- (CLLocationAccuracy)horizontalAccuracy {
    return 5.0; // تثبيت الدقة على 5 أمتار (ممتازة ومقبولة للنظام)
}

- (CLLocationAccuracy)verticalAccuracy {
    return 5.0;
}

%end

%hook CLLocationManager

- (void)startUpdatingLocation {
    %orig;
    
    CLLocation *fakeLocation = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(TARGET_LATITUDE + generateJitter(), TARGET_LONGITUDE + generateJitter())
                                                             altitude:15.0
                                                   horizontalAccuracy:5.0
                                                     verticalAccuracy:5.0
                                                            timestamp:[NSDate date]];
    
    if ([self delegate] && [[self delegate] respondsToSelector:@selector(locationManager:didUpdateLocations:)]) {
        [[self delegate] locationManager:self didUpdateLocations:@[fakeLocation]];
    }
}

%end

// 🛡️ تخطي فحص الملفات لمنع كشف الـ Sideload والـ Dylib بداخل حاضر بلس
%hook NSFileManager

- (BOOL)fileExistsAtPath:(NSString *)path {
    if ([path containsString:@"Cydia"] || 
        [path containsString:@"MobileSubstrate"] || 
        [path containsString:@"Sileo"] ||
        [path containsString:@".dylib"] ||
        [path containsString:@"libhooker"]) {
        return NO;
    }
    return %orig;
}

%end

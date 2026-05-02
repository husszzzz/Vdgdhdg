#import <UIKit/UIKit.h>

// تعريف المتغيرات لضمان استقرار الدايليب
static UILabel *hassanyLabel;
static NSTimer *colorTimer;

@interface HassanyOverlay : NSObject
+ (void)showOverlay;
+ (void)changeColor;
@end

@implementation HassanyOverlay

+ (void)showOverlay {
    // التأكد من تشغيل الكود على الخيط الرئيسي (Main Thread) لتجنب الكراش
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIWindow *keyWindow = nil;
        
        // الطريقة الحديثة للحصول على النافذة (حل مشكلة الخطأ بالصورة)
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene* scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    for (UIWindow *window in scene.windows) {
                        if (window.isKeyWindow) {
                            keyWindow = window;
                            break;
                        }
                    }
                }
            }
        } else {
            // للطريقة القديمة إذا كان الإصدار أقل من iOS 13
            keyWindow = [UIApplication sharedApplication].keyWindow;
        }

        // إذا وجدت النافذة ولم يتم إنشاء النص مسبقاً
        if (keyWindow && !hassanyLabel) {
            // إعدادات النص (الموقع والحجم)
            // العرض هو عرض الشاشة بالكامل، والارتفاع 20
            hassanyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, keyWindow.frame.size.width, 20)];
            hassanyLabel.text = @"hassany IPA";
            hassanyLabel.font = [UIFont boldSystemFontOfSize:10]; // حجم صغير واحترافي
            hassanyLabel.textAlignment = NSTextAlignmentCenter;
            hassanyLabel.backgroundColor = [UIColor clearColor];
            
            // وضع النص في أعلى الشاشة تماماً (فوق منطقة الساعة)
            // يمكنك تغيير رقم 15 لرفعه أو تنزيله قليلاً
            hassanyLabel.center = CGPointMake(keyWindow.center.x, 15);
            
            // منع النص من اعتراض اللمسات (حتى لا يعيق استخدام التطبيق)
            hassanyLabel.userInteractionEnabled = NO;
            
            [keyWindow addSubview:hassanyLabel];
            
            // بدء مؤقت تغيير الألوان (كل نصف ثانية)
            colorTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 
                                                          target:self 
                                                        selector:@selector(changeColor) 
                                                        userInfo:nil 
                                                         repeats:YES];
        }
    });
}

+ (void)changeColor {
    if (hassanyLabel) {
        // توليد ألوان عشوائية ناعمة
        CGFloat red = (arc4random() % 255) / 255.0f;
        CGFloat green = (arc4random() % 255) / 255.0f;
        CGFloat blue = (arc4random() % 255) / 255.0f;
        
        [UIView animateWithDuration:0.4 animations:^{
            hassanyLabel.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        }];
    }
}

@end

// ==========================================
// نقطة حقن الدايليب داخل التطبيق
// ==========================================
%hook UIApplication

- (void)applicationDidBecomeActive:(id)application {
    %orig; // تنفيذ الكود الأصلي للتطبيق
    
    // تشغيل الشعار بعد ثانية ونصف لضمان استقرار الواجهة
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HassanyOverlay showOverlay];
    });
}

%end

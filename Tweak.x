#import <UIKit/UIKit.h>
// استيراد مكتبة التنبيهات المخصصة (يجب أن تكون موجودة في مشروعك)
#import "SCLAlertView.h" 

%hook AppDelegate

- (BOOL)application:(id)application didFinishLaunchingWithOptions:(id)launchOptions {
    %orig; // تنفيذ الكود الأصلي للعبة أولاً

    // --- إعدادات المظهر ---
    SCLAlertViewBuilder *builder = [SCLAlertViewBuilder new];
    // تحديد لون الأزرار والخلفية لتشبه الصورة (لون أزرق DLS)
    builder.addButtonBackgroundColor = [UIColor colorWithRed:0.20 green:0.40 blue:0.80 alpha:1.0]; // أزرق
    builder.addButtonTextColor = [UIColor whiteColor];
    builder.showAnimationType = SCLAlertViewShowAnimationFadeIn;
    
    // إنشاء التنبيه
    SCLAlertView *alert = [[SCLAlertView alloc] initWithBuilder:builder];
    
    // --- إضافة الـ Switch (زر الإخفاء) ---
    // هذا هو السطر الذي يضيف "Toggle Switch" مثل الصورة
    UISwitch *hideSwitch = [alert addSwitchViewWithLabel:@"إخفاء | HIDE"];
    
    // --- إضافة الأزرار ---
    // الزر الأزرق العريض (مثل "Our Channel")
    SCLButton *btnMoon = [alert addButton:@"موقع Moon | GitHub" actionBlock:^{
        // ضع رابط GitHub الخاص بك هنا
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/حسابك"] options:@{} completionHandler:nil];
    }];
    // تأكيد اللون الأزرق للزر
    btnMoon.backgroundColor = [UIColor colorWithRed:0.20 green:0.40 blue:0.80 alpha:1.0];

    // زر الإغلاق/الشكر (اللون الرمادي الفاتح)
    SCLButton *btnThanks = [alert addButton:@"شكراً | Thanks" validationBlock:^BOOL{
        // إذا قام المستخدم بتفعيل الـ Switch، نحفظ الخيار حتى لا تظهر الرسالة مرة أخرى
        if (hideSwitch.isOn) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Moon_Hide_Welcome"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        return YES; // إغلاق التنبيه
    } actionBlock:^{
        // لا يوجد إجراء إضافي، فقط الإغلاق
    }];
    // تحديد اللون الرمادي للزر الثاني
    btnThanks.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.0];
    btnThanks.textColor = [UIColor blackColor];


    // --- إظهار التنبيه ---
    // التأكد من عدم إظهاره إذا اختار المستخدم "إخفاء" سابقاً
    BOOL shouldHide = [[NSUserDefaults standardUserDefaults] boolForKey:@"Moon_Hide_Welcome"];
    if (!shouldHide) {
        // أيقونة المعلومات (I) بالأعلى، والعنوان، والرسالة
        [alert showInfo:nil 
                  title:@"يا هلا بيك | Welcome" 
               subTitle:@"شكراً لاستخدامك تعديلات حسين الحساني\nتابعنا للمزيد من التطبيقات والألعاب الحصرية\nموقع Moon على GitHub" 
       closeButtonTitle:nil 
               duration:0.0f];
    }

    return YES;
}

%end

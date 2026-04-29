#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>

// دالة لكتابة القيمة في الذاكرة (الحقن)
void patchAddress(uintptr_t address, int value) {
    uintptr_t remoteAddr = _dyld_get_image_vmaddr_slide(0) + address;
    *(int *)remoteAddr = value;
}

%hook UIViewController
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Moon | حسين الحساني" 
                                    message:@"أدخل عدد الجواهر المطلوب:" 
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"اكتب الرقم هنا...";
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"تفعيل" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSString *val = alert.textFields.firstObject.text;
            int gemsCount = [val intValue];
            
            // استخدام الأوفست الذي استخرجته أنت
            // ملاحظة: الأوفست غالباً يكون الجزء الأخير من العنوان (مثلاً 0x4b851d)
            // سنقوم بحقن القيمة في العنوان الذي أرسلته
            patchAddress(0x1154b851d, gemsCount);
            
            NSLog(@"Moon: تم تفعيل %d جوهرة بنجاح!", gemsCount);
        }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    });
}
%end

#import <UIKit/UIKit.h>

static __attribute__((constructor)) void alhussainiInit() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"🛡️ Alhussaini Store 🛡️"
                                                                       message:@"تم تفعيل التعديل بنجاح\nبواسطة: حسين الحسني"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"استمرار" style:UIAlertActionStyleDefault handler:nil]];
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alert animated:YES completion:nil];
    });
}

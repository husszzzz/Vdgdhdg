#import <UIKit/UIKit.h>

%hook UIButton

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    %orig;
    
    // اهتزاز لمسي ذكي
    UIImpactFeedbackGenerator *haptic = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [haptic impactOccurred];

    // تأثير التصغير والشفافية
    [UIView animateWithDuration:0.12 animations:^{
        self.transform = CGAffineTransformMakeScale(0.90, 0.90);
        self.alpha = 0.8;
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    %orig;
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1.0;
    }];
}

%end

#import <UIKit/UIKit.h>

%hook UIButton

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    %orig;
    
    // اهتزاز خفيف عند اللمس
    UIImpactFeedbackGenerator *haptic = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    [haptic impactOccurred];

    // أنيميشن التصغير
    [UIView animateWithDuration:0.1 animations:^{
        self.transform = CGAffineTransformMakeScale(0.93, 0.93);
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    %orig;
    // رجوع الحجم الطبيعي
    [UIView animateWithDuration:0.1 animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}

%end

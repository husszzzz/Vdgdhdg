#import <UIKit/UIKit.h>

%hook UILabel
- (void)setText:(NSString *)text {
    %orig(@"الحسني"); 
}
%end

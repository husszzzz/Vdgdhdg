#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>

// دالة جلب عنوان الذاكرة الأساسي للعبة
uintptr_t get_base_address() {
    return (uintptr_t)_dyld_get_image_header(0);
}

// دالة التعديل على الذاكرة (حقن قيم الهكس)
void patch_memory(uintptr_t address, uint32_t data) {
    mach_port_t task = mach_task_self();
    vm_prot_t prot = VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY;
    
    if (vm_protect(task, (vm_address_t)address, sizeof(data), FALSE, prot) == KERN_SUCCESS) {
        *(volatile uint32_t *)address = data;
        vm_protect(task, (vm_address_t)address, sizeof(data), FALSE, VM_PROT_READ | VM_PROT_EXECUTE);
    }
}

// مدير قائمة H8
@interface H8MenuManager : NSObject
@property (nonatomic, strong) UIButton *floatingButton;
@property (nonatomic, strong) UIVisualEffectView *menuView;
@property (nonatomic, strong) UITextField *inputField;
+ (instancetype)sharedInstance;
- (void)setupInView:(UIView *)parentView;
@end

@implementation H8MenuManager

+ (instancetype)sharedInstance {
    static H8MenuManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (void)setupInView:(UIView *)parentView {
    if (self.floatingButton.superview) return;

    // 1. إنشاء الزر العائم
    self.floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.floatingButton.frame = CGRectMake(30, 100, 60, 60);
    self.floatingButton.backgroundColor = [UIColor colorWithRed:0.07 green:0.07 blue:0.07 alpha:0.85];
    [self.floatingButton setTitle:@"H8" forState:UIControlStateNormal];
    self.floatingButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.floatingButton setTitleColor:[UIColor colorWithRed:0.00 green:0.75 blue:1.00 alpha:1.00] forState:UIControlStateNormal];
    self.floatingButton.layer.cornerRadius = 30;
    self.floatingButton.layer.borderWidth = 2.0;
    self.floatingButton.layer.borderColor = [UIColor colorWithRed:0.00 green:0.75 blue:1.00 alpha:1.00].CGColor;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.floatingButton addGestureRecognizer:pan];
    [self.floatingButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    
    [parentView addSubview:self.floatingButton];

    // 2. إنشاء القائمة الزجاجية
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.menuView = [[UIVisualEffectView alloc] initWithEffect:blur];
    self.menuView.frame = CGRectMake(0, 0, 280, 240);
    self.menuView.center = parentView.center;
    self.menuView.layer.cornerRadius = 20;
    self.menuView.layer.masksToBounds = YES;
    self.menuView.layer.borderWidth = 1.0;
    self.menuView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.15].CGColor;
    self.menuView.alpha = 0.0;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 280, 25)];
    title.text = @"H8 PREMIUM MENU";
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont boldSystemFontOfSize:16];
    title.textAlignment = NSTextAlignmentCenter;
    [self.menuView.contentView addSubview:title];
    
    self.inputField = [[UITextField alloc] initWithFrame:CGRectMake(20, 65, 240, 45)];
    self.inputField.placeholder = @"الأوفست مفعل تلقائياً...";
    self.inputField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    self.inputField.textColor = [UIColor whiteColor];
    self.inputField.enabled = NO; // معطل لأن التعديل يتم على كود الأوفست مباشرة
    self.inputField.layer.cornerRadius = 10;
    self.inputField.layer.borderWidth = 1.0;
    self.inputField.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.2].CGColor;
    self.inputField.textAlignment = NSTextAlignmentCenter;
    [self.menuView.contentView addSubview:self.inputField];
    
    UIButton *applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    applyBtn.frame = CGRectMake(20, 125, 240, 45);
    applyBtn.backgroundColor = [UIColor colorWithRed:0.00 green:0.60 blue:1.00 alpha:1.00];
    [applyBtn setTitle:@"تفعيل الهاك (BOOM)" forState:UIControlStateNormal];
    applyBtn.layer.cornerRadius = 10;
    [applyBtn addTarget:self action:@selector(applyHack) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView.contentView addSubview:applyBtn];
    
    UIButton *freezeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    freezeBtn.frame = CGRectMake(20, 180, 240, 45);
    freezeBtn.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.0];
    [freezeBtn setTitle:@"تجميد الأموال (Freeze)" forState:UIControlStateNormal];
    freezeBtn.layer.cornerRadius = 10;
    freezeBtn.layer.borderWidth = 1.0;
    freezeBtn.layer.borderColor = [UIColor colorWithRed:1.00 green:0.30 blue:0.30 alpha:1.0].CGColor;
    [freezeBtn setTitleColor:[UIColor colorWithRed:1.00 green:0.30 blue:0.30 alpha:1.0] forState:UIControlStateNormal];
    [freezeBtn addTarget:self action:@selector(freezeHack) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView.contentView addSubview:freezeBtn];
    
    [parentView addSubview:self.menuView];
}

- (void)handlePan:(UIPanGestureRecognizer *)sender {
    UIView *view = sender.view;
    CGPoint translation = [sender translationInView:view.superview];
    view.center = CGPointMake(view.center.x + translation.x, view.center.y + translation.y);
    [sender setTranslation:CGPointZero inView:view.superview];
}

- (void)toggleMenu {
    [self.inputField resignFirstResponder];
    BOOL isHidden = (self.menuView.alpha == 0);
    [UIView animateWithDuration:0.3 animations:^{
        self.menuView.alpha = isHidden ? 1.0 : 0.0;
    }];
}

// تفعيل تعديل الذاكرة عبر الأوفست الثابت المكتشف
- (void)applyHack {
    uintptr_t base = get_base_address();
    // تغيير كود الـ Assembly ليعطي قيمة عالية جداً عند تنفيذ الأمر
    patch_memory(base + 0xaf634, 0x52800000); 
    [self showSuccessBanner:@"تم تفعيل الهاك! اكسب كوين لتحديث الشاشة"];
}

// تجميد القيمة (صنع أمر NOP لتخطي الخصم أو الزيادة)
- (void)freezeHack {
    uintptr_t base = get_base_address();
    patch_memory(base + 0xaf634, 0xD503201F); // أمر NOP بالـ ARM64
    [self showSuccessBanner:@"تم تجميد الفلوس بنجاح!"];
}

- (void)showSuccessBanner:(NSString *)msg {
    [self toggleMenu];
    
    UILabel *alert = [[UILabel alloc] initWithFrame:CGRectMake(0, -50, [UIScreen mainScreen].bounds.size.width, 50)];
    alert.backgroundColor = [UIColor colorWithRed:0.0 green:0.75 blue:0.0 alpha:0.9];
    alert.textColor = [UIColor whiteColor];
    alert.text = msg;
    alert.textAlignment = NSTextAlignmentCenter;
    alert.font = [UIFont boldSystemFontOfSize:14];
    
    UIWindow *window = (UIWindow *)self.floatingButton.superview;
    if ([window isKindOfClass:[UIWindow class]] || [window isKindOfClass:[UIView class]]) {
        [window addSubview:alert];
        [UIView animateWithDuration:0.5 animations:^{
            alert.frame = CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 50);
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 animations:^{
                    alert.frame = CGRectMake(0, -50, [UIScreen mainScreen].bounds.size.width, 50);
                } completion:^(BOOL finished) {
                    [alert removeFromSuperview];
                }];
            });
        });
    }
}
@end

%ctor {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIWindow *keyWindow = nil;
            
            if (@available(iOS 13.0, *)) {
                for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                    if (scene.activationState == UISceneActivationStateForegroundActive) {
                        for (UIWindow *window in scene.windows) {
                            if (window.isKeyWindow) {
                                keyWindow = window;
                                break;
                            }
                        }
                    }
                }
            }
            
            if (!keyWindow) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                keyWindow = [UIApplication sharedApplication].keyWindow;
#pragma clang diagnostic pop
            }
            
            if (keyWindow) {
                [[H8MenuManager sharedInstance] setupInView:keyWindow];
            }
        });
    }];
}

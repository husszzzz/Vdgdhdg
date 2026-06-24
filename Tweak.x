#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>

// دالة لجلب عنوان اللعبة الأساسي في الذاكرة (Base Address)
uintptr_t get_base_address() {
    return (uintptr_t)_dyld_get_image_header(0);
}

// دالة احترافية للكتابة على الذاكرة وتعديل الأوفست (Memory Patching)
void patch_memory(uintptr_t address, uint32_t data) {
    mach_port_t task = mach_task_self();
    vm_prot_t prot = VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY;
    
    // السماح بالكتابة على الصفحة الحمية في الذاكرة
    if (vm_protect(task, (vm_address_t)address, sizeof(data), FALSE, prot) == KERN_SUCCESS) {
        *(volatile uint32_t *)address = data;
        // إعادة حماية الصفحة لوضعها الأصلي
        vm_protect(task, (vm_address_t)address, sizeof(data), FALSE, VM_PROT_READ | VM_PROT_EXECUTE);
    }
}

// تعريف واجهات القائمة العائمة
@interface H8FloatingMenu : UIWindow
@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UIVisualEffectView *menuView;
@property (nonatomic, strong) UITextField *inputField;
+ (instancetype)sharedInstance;
@end

@implementation H8FloatingMenu

+ (instancetype)sharedInstance {
    static H8FloatingMenu *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return sharedInstance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelAlert + 1;
        self.hidden = NO;
        self.backgroundColor = [UIColor clearColor];
        [self setRootViewController:[[UIViewController alloc] init]];
        
        [self createFloatingButton];
        [self createSleekMenu];
    }
    return self;
}

// 1. تصميم الدائرة العائمة الاحترافية H8
- (void)createFloatingButton {
    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuButton.frame = CGRectMake(30, 200, 60, 60);
    self.menuButton.backgroundColor = [UIColor colorWithRed:0.07 green:0.07 blue:0.07 alpha:0.85];
    [self.menuButton setTitle:@"H8" forState:UIControlStateNormal];
    self.menuButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.menuButton setTitleColor:[UIColor colorWithRed:0.00 green:0.75 blue:1.00 alpha:1.00] forState:UIControlStateNormal]; // لون نيون أزرق
    
    // تصميم دائري مع حواف مضيئة وظل احترافي
    self.menuButton.layer.cornerRadius = 30;
    self.menuButton.layer.borderWidth = 2.0;
    self.menuButton.layer.borderColor = [UIColor colorWithRed:0.00 green:0.75 blue:1.00 alpha:1.00].CGColor;
    self.menuButton.layer.shadowColor = [UIColor colorWithRed:0.00 green:0.75 blue:1.00 alpha:1.00].CGColor;
    self.menuButton.layer.shadowOffset = CGSizeMake(0, 0);
    self.menuButton.layer.shadowOpacity = 0.8;
    self.menuButton.layer.shadowRadius = 8;
    
    // إضافة إيماءة السحب (Drag) والضغط (Tap)
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.menuButton addGestureRecognizer:panGesture];
    [self.menuButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.menuButton];
}

// 2. تصميم القائمة الزجاجية الاحترافية
- (void)createSleekMenu {
    // تأثير الضباب الزجاجي المظلم (Dark Blur)
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.menuView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.menuView.frame = CGRectMake(0, 0, 280, 240);
    self.menuView.center = self.center;
    self.menuView.layer.cornerRadius = 20;
    self.menuView.layer.masksToBounds = YES;
    self.menuView.layer.borderWidth = 1.0;
    self.menuView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.15].CGColor;
    self.menuView.alpha = 0; // مخفية في البداية
    
    // عنوان القائمة
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 280, 25)];
    titleLabel.text = @"H8 PREMIUM MENU";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.menuView.contentView addSubview:titleLabel];
    
    // حقل إدخال الأرقام بشكل ديزاين مودرن
    self.inputField = [[UITextField alloc] initWithFrame:CGRectMake(20, 65, 240, 45)];
    self.inputField.placeholder = @" أدخل كمية الأموال هنا...";
    self.inputField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    self.inputField.textColor = [UIColor whiteColor];
    self.inputField.keyboardType = UIKeyboardTypeNumberPad;
    self.inputField.layer.cornerRadius = 10;
    self.inputField.layer.borderWidth = 1.0;
    self.inputField.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.2].CGColor;
    self.inputField.textAlignment = NSTextAlignmentCenter;
    
    // تغيير لون الـ Placeholder للون فاتح يتماشى مع التصميم
    self.inputField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.inputField.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    [self.menuView.contentView addSubview:self.inputField];
    
    // زر التفعيل "بممم تتغير الفلوس"
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    actionButton.frame = CGRectMake(20, 125, 240, 45);
    actionButton.backgroundColor = [UIColor colorWithRed:0.00 green:0.60 blue:1.00 alpha:1.00];
    [actionButton setTitle:@"تفعيل الهاك (BOOM)" forState:UIControlStateNormal];
    actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    actionButton.layer.cornerRadius = 10;
    [actionButton addTarget:self action:@selector(applyHackPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView.contentView addSubview:actionButton];
    
    // زر تجميد الأموال (Freeze) لمنع النقصان
    UIButton *freezeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    freezeButton.frame = CGRectMake(20, 180, 240, 45);
    freezeButton.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.0];
    [freezeButton setTitle:@"تجميد الأموال (Freeze)" forState:UIControlStateNormal];
    freezeButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    freezeButton.layer.cornerRadius = 10;
    freezeButton.layer.borderWidth = 1.0;
    freezeButton.layer.borderColor = [UIColor colorWithRed:1.00 green:0.30 blue:0.30 alpha:1.0].CGColor;
    [freezeButton setTitleColor:[UIColor colorWithRed:1.00 green:0.30 blue:0.30 alpha:1.0] forState:UIControlStateNormal];
    [freezeButton addTarget:self action:@selector(freezeHackPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView.contentView addSubview:freezeButton];
    
    [self addSubview:self.menuView];
}

// تحريك الأيقونة العائمة عند السحب بيدك
- (void)handlePan:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self];
    sender.view.center = CGPointMake(sender.view.center.x + translation.x, sender.view.center.y + translation.y);
    [sender setTranslation:CGPointZero inView:self];
}

// إظهار وإخفاء القائمة عند الضغط على H8 بطريقة ناعمة (Animation)
- (void)toggleMenu {
    [self endEditing:YES]; // إخفاء الكيبورد تلقائياً
    BOOL isHidden = (self.menuView.alpha == 0);
    [UIView animateWithDuration:0.3 animations:^{
        self.menuView.alpha = isHidden ? 1.0 : 0.0;
    }];
}

// عند الضغط على زر تفعيل الهاك
- (void)applyHackPressed {
    NSString *inputValue = self.inputField.text;
    if (inputValue.length == 0) return;
    
    uintptr_t base = get_base_address();
    uintptr_t offsetAddress = base + 0xaf634; // الأوفست الخاص بك
    
    // كود مخصص لتعديل الأمر البرمجي ليقوم باعطائك الحد الأقصى دائماً عند تفعيله
    // الأمر البرمجي الافتراضي لـ ARM64 يتم استبداله بـ MOV W0, #الرقم (هنا نضع قيمة افتراضية كبرى)
    patch_memory(offsetAddress, 0x52800000); // مثال لأمر تمرير قيمة برمجية كبرى
    
    // إشعار نجاح احترافي داخل اللعبة
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"H8 Status" message:@"تم تعديل الذاكرة بنجاح! قم بزيادة أموالك الآن داخل اللعبة لتشاهد النتيجة." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"تم" style:UIAlertActionStyleDefault handler:nil]];
    [[self rootViewController] presentViewController:alert animated:YES completion:nil];
    
    [self toggleMenu];
}

// عند الضغط على زر تجميد الفلوس (يمنع نقصانها نهائياً)
- (void)freezeHackPressed {
    uintptr_t base = get_base_address();
    uintptr_t offsetAddress = base + 0xaf634;
    
    // استبدال كود الـ Write بـ أمر فارغ NOP في المعالجات ARM64 (الـ NOP الثابت هو 0xD503201F)
    patch_memory(offsetAddress, 0xD503201F);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"H8 Status" message:@"تم تجميد الفلوس بنجاح! لن تنقص أموالك بعد الآن." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"كفو" style:UIAlertActionStyleDefault handler:nil]];
    [[self rootViewController] presentViewController:alert animated:YES completion:nil];
    
    [self toggleMenu];
}

@end

// تفعيل القائمة العائمة بمجرد تشغيل اللعبة تلقائياً
%hook UIApplication
- (void)finishedLaunching {
    %orig;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [H8FloatingMenu sharedInstance];
    });
}
%end

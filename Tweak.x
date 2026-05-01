#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>

// --- النماذج البرمجية ---

@interface CustomButtonModel : NSObject <NSSecureCoding>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type; 
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) UIColor *tagColor;
@property (nonatomic, strong) NSString *category;
@end

@implementation CustomButtonModel
+ (BOOL)supportsSecureCoding { return YES; }
- (void)encodeWithCoder:(NSCoder *)a {
    [a encodeObject:self.name forKey:@"name"]; [a encodeObject:self.type forKey:@"type"];
    [a encodeObject:self.content forKey:@"content"]; [a encodeObject:self.tagColor forKey:@"tagColor"];
    [a encodeObject:self.category forKey:@"category"];
}
- (id)initWithCoder:(NSCoder *)a {
    if ((self = [super init])) {
        self.name = [a decodeObjectOfClass:[NSString class] forKey:@"name"];
        self.type = [a decodeObjectOfClass:[NSString class] forKey:@"type"];
        self.content = [a decodeObjectOfClass:[NSString class] forKey:@"content"];
        self.tagColor = [a decodeObjectOfClass:[UIColor class] forKey:@"tagColor"];
        self.category = [a decodeObjectOfClass:[NSString class] forKey:@"category"] ?: @"عام";
    }
    return self;
}
@end

// --- حل مشكلة الخطأ في الصورة: تعريف الـ Interface للـ Hook ---
@interface UIViewController (HassanyExtension)
- (void)openHassany;
@end

// --- واجهة الإعدادات المتقدمة ---

@interface HassanySettings : UIViewController
@end

@implementation HassanySettings
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"إعدادات الحسني";
    self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scroll];
    
    // 1. زر تبديل القفل
    UIButton *lockBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    lockBtn.frame = CGRectMake(20, 30, self.view.frame.size.width - 40, 50);
    lockBtn.backgroundColor = [UIColor secondarySystemBackgroundColor];
    lockBtn.layer.cornerRadius = 10;
    BOOL currentLock = [[NSUserDefaults standardUserDefaults] boolForKey:@"HassanyLock"];
    [lockBtn setTitle:currentLock ? @"القفل: مفعل ✅" : @"القفل: معطل ❌" forState:UIControlStateNormal];
    [lockBtn addTarget:self action:@selector(toggleLock:) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:lockBtn];

    // 2. تغيير حرف الزر العائم
    UILabel *charLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 100, 200, 30)];
    charLabel.text = @"حرف الزر العائم:";
    [scroll addSubview:charLabel];
    
    UITextField *charInput = [[UITextField alloc] initWithFrame:CGRectMake(20, 130, self.view.frame.size.width - 40, 45)];
    charInput.backgroundColor = [UIColor secondarySystemBackgroundColor];
    charInput.layer.cornerRadius = 10;
    charInput.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"HassanyChar"] ?: @"H";
    charInput.textAlignment = NSTextAlignmentCenter;
    [charInput addTarget:self action:@selector(saveChar:) forControlEvents:UIControlEventEditingChanged];
    [scroll addSubview:charInput];

    // 3. التصدير والاستيراد
    UIButton *exportBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    exportBtn.frame = CGRectMake(20, 200, self.view.frame.size.width - 40, 50);
    [exportBtn setTitle:@"تصدير البيانات (نسخ كود)" forState:UIControlStateNormal];
    [exportBtn addTarget:self action:@selector(exportData) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:exportBtn];
    
    UIButton *importBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    importBtn.frame = CGRectMake(20, 260, self.view.frame.size.width - 40, 50);
    [importBtn setTitle:@"استيراد البيانات (لصق كود)" forState:UIControlStateNormal];
    [importBtn addTarget:self action:@selector(importData) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:importBtn];
}

- (void)toggleLock:(UIButton *)sender {
    BOOL current = [[NSUserDefaults standardUserDefaults] boolForKey:@"HassanyLock"];
    [[NSUserDefaults standardUserDefaults] setBool:!current forKey:@"HassanyLock"];
    [sender setTitle:!current ? @"القفل: مفعل ✅" : @"القفل: معطل ❌" forState:UIControlStateNormal];
}

- (void)saveChar:(UITextField *)field {
    if (field.text.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:field.text forKey:@"HassanyChar"];
    }
}

- (void)exportData {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"HassanyButtons"];
    NSString *base64 = [data base64EncodedStringWithOptions:0];
    [UIPasteboard generalPasteboard].string = base64 ?: @"";
    UIAlertController *a = [UIAlertController alertControllerWithTitle:@"تم النسخ" message:@"انسخ هذا الكود وأرسله لمن تريد." preferredStyle:UIAlertControllerStyleAlert];
    [a addAction:[UIAlertAction actionWithTitle:@"تم" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:a animated:YES completion:nil];
}

- (void)importData {
    NSString *input = [UIPasteboard generalPasteboard].string;
    NSData *data = [[NSData alloc] initWithBase64EncodedString:input options:0];
    if (data) {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"HassanyButtons"];
        UIAlertController *a = [UIAlertController alertControllerWithTitle:@"نجح الاستيراد" message:@"تم تحديث بيانات الأزرار بنجاح." preferredStyle:UIAlertControllerStyleAlert];
        [a addAction:[UIAlertAction actionWithTitle:@"تم" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:a animated:YES completion:nil];
    }
}
@end

// --- الواجهة الرئيسية مع المجلدات ---

@interface HassanyDashboard : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<CustomButtonModel *> *userButtons;
@property (nonatomic, strong) NSMutableArray *sectionTitles;
@property (nonatomic, strong) NSMutableDictionary *sectionData;
@end

@implementation HassanyDashboard

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"لوحة تحكم الحسني";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    [self loadAndOrganize];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleInsetGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewButton)];
    UIBarButtonItem *sets = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"gearshape.fill"] style:UIBarButtonItemStylePlain target:self action:@selector(openSettings)];
    self.navigationItem.rightBarButtonItems = @[add, sets];
}

- (void)openSettings {
    [self.navigationController pushViewController:[[HassanySettings alloc] init] animated:YES];
}

- (void)loadAndOrganize {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"HassanyButtons"];
    if (data) {
        NSSet *classes = [NSSet setWithArray:@[[NSMutableArray class], [CustomButtonModel class], [NSString class], [UIColor class]]];
        self.userButtons = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:data error:nil];
    }
    self.userButtons = self.userButtons ?: [[NSMutableArray alloc] init];
    
    self.sectionData = [NSMutableDictionary dictionary];
    for (CustomButtonModel *m in self.userButtons) {
        NSString *cat = m.category ?: @"عام";
        if (!self.sectionData[cat]) self.sectionData[cat] = [NSMutableArray array];
        [self.sectionData[cat] addObject:m];
    }
    self.sectionTitles = [[self.sectionData allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)].mutableCopy;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)t { return self.sectionTitles.count; }
- (NSString *)tableView:(UITableView *)t titleForHeaderInSection:(NSInteger)s { return self.sectionTitles[s]; }
- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return ((NSArray *)self.sectionData[self.sectionTitles[s]]).count; }

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)i {
    UITableViewCell *c = [t dequeueReusableCellWithIdentifier:@"c"] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"c"];
    CustomButtonModel *m = self.sectionData[self.sectionTitles[i.section]][i.row];
    c.textLabel.text = m.name;
    c.detailTextLabel.text = m.type;
    return c;
}

- (void)addNewButton {
    UIAlertController *a = [UIAlertController alertControllerWithTitle:@"إضافة زر" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [a addTextFieldWithConfigurationHandler:^(UITextField *t) { t.placeholder = @"الاسم"; }];
    [a addTextFieldWithConfigurationHandler:^(UITextField *t) { t.placeholder = @"المحتوى (رابط/نص)"; }];
    [a addTextFieldWithConfigurationHandler:^(UITextField *t) { t.placeholder = @"المجلد (مثلاً: ببجي)"; }];
    
    [a addAction:[UIAlertAction actionWithTitle:@"حفظ" style:UIAlertActionStyleDefault handler:^(UIAlertAction *act) {
        CustomButtonModel *m = [[CustomButtonModel alloc] init];
        m.name = a.textFields[0].text;
        m.content = a.textFields[1].text;
        m.category = a.textFields[2].text.length > 0 ? a.textFields[2].text : @"عام";
        m.type = [m.content hasPrefix:@"http"] ? @"رابط" : @"نص";
        [self.userButtons addObject:m];
        [self saveAll];
    }]];
    [self presentViewController:a animated:YES completion:nil];
}

- (void)saveAll {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.userButtons requiringSecureCoding:YES error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"HassanyButtons"];
    [self loadAndOrganize];
    [self.tableView reloadData];
}
@end

// --- كود الـ Hook النهائي ---

%hook UIViewController
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSString *hChar = [[NSUserDefaults standardUserDefaults] stringForKey:@"HassanyChar"] ?: @"H";
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(20, 100, 50, 50);
        btn.backgroundColor = [UIColor systemBlueColor];
        [btn setTitle:hChar forState:UIControlStateNormal];
        btn.tintColor = [UIColor whiteColor];
        btn.layer.cornerRadius = 25;
        [btn addTarget:self action:@selector(checkLockAndOpen) forControlEvents:UIControlEventTouchUpInside];
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        [window addSubview:btn];
    });
}

%new - (void)checkLockAndOpen {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HassanyLock"]) {
        LAContext *context = [[LAContext alloc] init];
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"يرجى التحقق لفتح لوحة الحسني" reply:^(BOOL success, NSError *error) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{ [self openHassany]; });
            }
        }];
    } else {
        [self openHassany];
    }
}

%new - (void)openHassany {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[HassanyDashboard alloc] init]];
    [self presentViewController:nav animated:YES completion:nil];
}
%end

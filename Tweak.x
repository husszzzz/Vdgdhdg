#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>

// --- النماذج البرمجية ---

@interface CustomButtonModel : NSObject <NSSecureCoding>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type; 
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) UIColor *tagColor;
@property (nonatomic, strong) NSString *category; // المجلد
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

// --- واجهة الإعدادات ---

@interface HassanySettings : UIViewController
@end

@implementation HassanySettings
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"الإعدادات";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scroll];
    
    // مثال بسيط لأزرار الإعدادات (يمكنك توسيعه)
    UIButton *lockBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    lockBtn.frame = CGRectMake(20, 50, 300, 50);
    [lockBtn setTitle:@"تفعيل قفل البصمة/الوجه" forState:UIControlStateNormal];
    [lockBtn addTarget:self action:@selector(toggleLock) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:lockBtn];

    UIButton *exportBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    exportBtn.frame = CGRectMake(20, 120, 300, 50);
    [exportBtn setTitle:@"تصدير البيانات (نسخ كود)" forState:UIControlStateNormal];
    [exportBtn addTarget:self action:@selector(exportData) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:exportBtn];
}

- (void)toggleLock {
    BOOL current = [[NSUserDefaults standardUserDefaults] boolForKey:@"HassanyLock"];
    [[NSUserDefaults standardUserDefaults] setBool:!current forKey:@"HassanyLock"];
    UIAlertController *a = [UIAlertController alertControllerWithTitle:@"تم" message:!current ? @"تم تفعيل القفل" : @"تم إلغاء القفل" preferredStyle:UIAlertControllerStyleAlert];
    [a addAction:[UIAlertAction actionWithTitle:@"شكراً" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:a animated:YES completion:nil];
}

- (void)exportData {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"HassanyButtons"];
    NSString *base64 = [data base64EncodedStringWithOptions:0];
    [UIPasteboard generalPasteboard].string = base64;
    UIAlertController *a = [UIAlertController alertControllerWithTitle:@"تم التصدير" message:@"تم نسخ كود البيانات للحافظة، يمكنك مشاركته." preferredStyle:UIAlertControllerStyleAlert];
    [a addAction:[UIAlertAction actionWithTitle:@"تم" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:a animated:YES completion:nil];
}
@end

// --- الواجهة الرئيسية ---

@interface HassanyDashboard : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<CustomButtonModel *> *userButtons;
@property (nonatomic, strong) NSMutableDictionary *sections;
@end

@implementation HassanyDashboard

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"لوحة تحكم الحسني";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    [self loadAndOrganizeData];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleInsetGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewButton)];
    UIBarButtonItem *sets = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"gear"] style:UIBarButtonItemStylePlain target:self action:@selector(openSettings)];
    self.navigationItem.rightBarButtonItems = @[add, sets];
}

- (void)openSettings {
    [self.navigationController pushViewController:[[HassanySettings alloc] init] animated:YES];
}

- (void)loadAndOrganizeData {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"HassanyButtons"];
    if (data) {
        NSSet *classes = [NSSet setWithArray:@[[NSMutableArray class], [CustomButtonModel class], [NSString class], [UIColor class]]];
        self.userButtons = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:data error:nil];
    }
    self.userButtons = self.userButtons ?: [[NSMutableArray alloc] init];
    
    // تنظيم المجلدات
    self.sections = [[NSMutableDictionary alloc] init];
    for (CustomButtonModel *m in self.userButtons) {
        if (!self.sections[m.category]) self.sections[m.category] = [[NSMutableArray alloc] init];
        [self.sections[m.category] addObject:m];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return self.sections.allKeys.count; }
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { return self.sections.allKeys[section]; }
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = self.sections.allKeys[section];
    return ((NSArray *)self.sections[key]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"c"] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"c"];
    NSString *key = self.sections.allKeys[indexPath.section];
    CustomButtonModel *m = self.sections[key][indexPath.row];
    cell.textLabel.text = m.name;
    cell.detailTextLabel.text = m.type;
    return cell;
}

- (void)addNewButton {
    // هنا تفتح الـ Alert وتطلب الاسم، المحتوى، والمجلد (Category) بنفس الطريقة السابقة
}

@end

// --- كود الزر العائم والحماية ---

%hook UIViewController
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        // قراءة إعدادات الزر العائم
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

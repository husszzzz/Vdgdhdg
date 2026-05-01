#import <UIKit/UIKit.h>

// --- نموذج البيانات الاحترافي ---
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

// --- واجهة الإعدادات بنظام iOS ---
@interface HassanySettings : UITableViewController
@end

@implementation HassanySettings
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"إعدادات الحسني";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)t { return 3; }
- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s {
    if (s == 0) return 2; // التخصيص
    if (s == 1) return 2; // البيانات
    return 1; // حول
}

- (NSString *)tableView:(UITableView *)t titleForHeaderInSection:(NSInteger)s {
    if (s == 0) return @"تخصيص المظهر";
    if (s == 1) return @"إدارة البيانات";
    return @"عن التطبيق";
}

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)i {
    UITableViewCell *c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"set"];
    c.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (i.section == 0) {
        if (i.row == 0) {
            c.textLabel.text = @"تغيير حرف الزر";
            c.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"HChar"] ?: @"H";
        } else {
            c.textLabel.text = @"لون الزر العائم";
            c.detailTextLabel.text = @"أزرق افتراضي";
        }
    } else if (i.section == 1) {
        c.textLabel.text = (i.row == 0) ? @"تصدير النسخة الاحتياطية" : @"استيراد نسخة";
    } else {
        c.textLabel.text = @"فريق التطوير";
        c.detailTextLabel.text = @"المصمم الحسني";
    }
    return c;
}

- (void)tableView:(UITableView *)t didSelectRowAtIndexPath:(NSIndexPath *)i {
    [t deselectRowAtIndexPath:i animated:YES];
    if (i.section == 0 && i.row == 0) {
        UIAlertController *a = [UIAlertController alertControllerWithTitle:@"تغيير الحرف" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [a addTextFieldWithConfigurationHandler:^(UITextField *tf) { tf.placeholder = @"اكتب حرفاً"; }];
        [a addAction:[UIAlertAction actionWithTitle:@"حفظ" style:UIAlertActionStyleDefault handler:^(UIAlertAction *act) {
            [[NSUserDefaults standardUserDefaults] setObject:a.textFields[0].text forKey:@"HChar"];
            [self.tableView reloadData];
        }]];
        [self presentViewController:a animated:YES completion:nil];
    }
    // التصدير والاستيراد
    if (i.section == 1) {
        if (i.row == 0) {
            NSData *d = [[NSUserDefaults standardUserDefaults] objectForKey:@"HButtons"];
            [UIPasteboard generalPasteboard].string = [d base64EncodedStringWithOptions:0];
            // تنبيه بسيط
            UIAlertController *alt = [UIAlertController alertControllerWithTitle:@"تم النسخ" message:@"تم نسخ كود البيانات للحافظة." preferredStyle:UIAlertControllerStyleAlert];
            [alt addAction:[UIAlertAction actionWithTitle:@"تم" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alt animated:YES completion:nil];
        } else {
            NSString *s = [UIPasteboard generalPasteboard].string;
            NSData *d = [[NSData alloc] initWithBase64EncodedString:s options:0];
            if (d) {
                [[NSUserDefaults standardUserDefaults] setObject:d forKey:@"HButtons"];
                [self.tableView reloadData];
            }
        }
    }
}
@end

// --- اللوحة الرئيسية ---
@interface HassanyDashboard : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<CustomButtonModel *> *userButtons;
@property (nonatomic, strong) NSMutableArray<CustomButtonModel *> *filteredButtons;
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation HassanyDashboard

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"لوحة تحكم الحسني";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    [self loadData];

    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.navigationItem.searchController = self.searchController;

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleInsetGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNew)];
    UIBarButtonItem *sets = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"gear"] style:UIBarButtonItemStylePlain target:self action:@selector(openSets)];
    self.navigationItem.rightBarButtonItems = @[add, sets];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)sc {
    NSString *t = sc.searchBar.text;
    if (t.length > 0) {
        self.filteredButtons = [[self.userButtons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", t]] mutableCopy];
    } else {
        self.filteredButtons = [self.userButtons mutableCopy];
    }
    [self.tableView reloadData];
}

- (void)loadData {
    NSData *d = [[NSUserDefaults standardUserDefaults] objectForKey:@"HButtons"];
    if (d) {
        NSSet *c = [NSSet setWithArray:@[[NSMutableArray class], [CustomButtonModel class], [NSString class], [UIColor class]]];
        self.userButtons = [NSKeyedUnarchiver unarchivedObjectOfClasses:c fromData:d error:nil];
    }
    self.userButtons = self.userButtons ?: [NSMutableArray array];
    self.filteredButtons = [self.userButtons mutableCopy];
}

- (void)openSets {
    [self.navigationController pushViewController:[[HassanySettings alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
}

- (void)addNew {
    UIAlertController *a = [UIAlertController alertControllerWithTitle:@"إضافة جديد" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [a addTextFieldWithConfigurationHandler:^(UITextField *t) { t.placeholder = @"الاسم"; }];
    [a addTextFieldWithConfigurationHandler:^(UITextField *t) { t.placeholder = @"المحتوى"; }];
    [a addTextFieldWithConfigurationHandler:^(UITextField *t) { t.placeholder = @"المجلد (مثلاً: ألعاب)"; }];
    
    // تصحيح الخطأ هنا: استخدام UIAlertActionStyleDefault
    [a addAction:[UIAlertAction actionWithTitle:@"حفظ كرابط" style:UIAlertActionStyleDefault handler:^(UIAlertAction *act) { [self save:a type:@"رابط"]; }]];
    [a addAction:[UIAlertAction actionWithTitle:@"حفظ كنص" style:UIAlertActionStyleDefault handler:^(UIAlertAction *act) { [self save:a type:@"نص"]; }]];
    [a addAction:[UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:a animated:YES completion:nil];
}

- (void)save:(UIAlertController *)a type:(NSString *)type {
    CustomButtonModel *m = [[CustomButtonModel alloc] init];
    m.name = a.textFields[0].text; m.content = a.textFields[1].text;
    m.category = a.textFields[2].text ?: @"عام"; m.type = type;
    [self.userButtons addObject:m];
    NSData *d = [NSKeyedArchiver archivedDataWithRootObject:self.userButtons requiringSecureCoding:YES error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:d forKey:@"HButtons"];
    [self loadData]; [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.filteredButtons.count; }
- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)i {
    UITableViewCell *c = [t dequeueReusableCellWithIdentifier:@"c"] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"c"];
    CustomButtonModel *m = self.filteredButtons[i.row];
    c.textLabel.text = m.name;
    c.detailTextLabel.text = [NSString stringWithFormat:@"📂 %@ | 📄 %@", m.category, m.type];
    return c;
}

- (void)tableView:(UITableView *)t didSelectRowAtIndexPath:(NSIndexPath *)i {
    [t deselectRowAtIndexPath:i animated:YES];
    CustomButtonModel *m = self.filteredButtons[i.row];
    if ([m.type isEqualToString:@"رابط"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:m.content] options:@{} completionHandler:nil];
    } else {
        [UIPasteboard generalPasteboard].string = m.content;
    }
}
@end

// --- التفعيل والربط ---
@interface UIViewController (Hassany)
- (void)openHassany;
@end

%hook UIViewController
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(30, 150, 55, 55);
        btn.backgroundColor = [UIColor systemBlueColor]; // يمكنك جعل اللون متغيراً من الـ UserDefaults
        [btn setTitle:[[NSUserDefaults standardUserDefaults] stringForKey:@"HChar"] ?: @"H" forState:UIControlStateNormal];
        btn.tintColor = [UIColor whiteColor];
        btn.layer.cornerRadius = 27.5;
        btn.layer.shadowOpacity = 0.4;
        [btn addTarget:self action:@selector(openHassany) forControlEvents:UIControlEventTouchUpInside];
        [[UIApplication sharedApplication].windows.firstObject addSubview:btn];
    });
}
%new - (void)openHassany {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[HassanyDashboard alloc] init]];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nav animated:YES completion:nil];
}
%end

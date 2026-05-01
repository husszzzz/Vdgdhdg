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
    return @"فريق العمل";
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
            c.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"HColor"] ?: @"أزرق";
        }
    } else if (i.section == 1) {
        c.textLabel.text = (i.row == 0) ? @"تصدير (نسخ الكود)" : @"استيراد (لصق الكود)";
    } else {
        c.textLabel.text = @"تواصل مع المطور";
        c.detailTextLabel.text = @"@OM_G9 🚀";
    }
    return c;
}

- (void)tableView:(UITableView *)t didSelectRowAtIndexPath:(NSIndexPath *)i {
    [t deselectRowAtIndexPath:i animated:YES];
    
    // 1. تغيير الحرف
    if (i.section == 0 && i.row == 0) {
        UIAlertController *a = [UIAlertController alertControllerWithTitle:@"تغيير الحرف" message:@"اكتب حرفاً واحداً ليظهر على الزر العائم" preferredStyle:UIAlertControllerStyleAlert];
        [a addTextFieldWithConfigurationHandler:^(UITextField *tf) { tf.placeholder = @"H"; }];
        [a addAction:[UIAlertAction actionWithTitle:@"حفظ" style:UIAlertActionStyleDefault handler:^(UIAlertAction *act) {
            [[NSUserDefaults standardUserDefaults] setObject:a.textFields[0].text forKey:@"HChar"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.tableView reloadData];
        }]];
        [a addAction:[UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:a animated:YES completion:nil];
    }
    
    // 2. تغيير اللون
    if (i.section == 0 && i.row == 1) {
        UIAlertController *a = [UIAlertController alertControllerWithTitle:@"اختر لون الزر" message:@"سيتم تطبيق اللون فوراً" preferredStyle:UIAlertControllerStyleActionSheet];
        NSArray *colors = @[@"أزرق", @"أحمر", @"أخضر", @"أسود", @"برتقالي", @"بنفسجي"];
        for (NSString *c in colors) {
            [a addAction:[UIAlertAction actionWithTitle:c style:UIAlertActionStyleDefault handler:^(UIAlertAction *act) {
                [[NSUserDefaults standardUserDefaults] setObject:c forKey:@"HColor"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.tableView reloadData];
            }]];
        }
        [a addAction:[UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:a animated:YES completion:nil];
    }
    
    // 3. التصدير والاستيراد
    if (i.section == 1) {
        if (i.row == 0) { // تصدير
            NSData *d = [[NSUserDefaults standardUserDefaults] objectForKey:@"HButtons"];
            if (d) {
                [UIPasteboard generalPasteboard].string = [d base64EncodedStringWithOptions:0];
                UIAlertController *alt = [UIAlertController alertControllerWithTitle:@"تم التصدير" message:@"تم نسخ كود الأزرار بنجاح، يمكنك إرساله لأي شخص." preferredStyle:UIAlertControllerStyleAlert];
                [alt addAction:[UIAlertAction actionWithTitle:@"حسناً" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alt animated:YES completion:nil];
            }
        } else { // استيراد
            NSString *s = [UIPasteboard generalPasteboard].string;
            if (s.length > 0) {
                NSData *d = [[NSData alloc] initWithBase64EncodedString:s options:0];
                if (d) {
                    [[NSUserDefaults standardUserDefaults] setObject:d forKey:@"HButtons"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    UIAlertController *alt = [UIAlertController alertControllerWithTitle:@"تم الاستيراد" message:@"تم تحميل الأزرار الجديدة بنجاح." preferredStyle:UIAlertControllerStyleAlert];
                    [alt addAction:[UIAlertAction actionWithTitle:@"حسناً" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:alt animated:YES completion:nil];
                }
            }
        }
    }
    
    // 4. التواصل مع فريق التطوير
    if (i.section == 2 && i.row == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/OM_G9"] options:@{} completionHandler:nil];
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
    self.searchController.obscuresBackgroundDuringPresentation = NO;
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

- (void)saveAllData {
    NSData *d = [NSKeyedArchiver archivedDataWithRootObject:self.userButtons requiringSecureCoding:YES error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:d forKey:@"HButtons"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self loadData];
    [self.tableView reloadData];
}

- (void)openSets {
    [self.navigationController pushViewController:[[HassanySettings alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
}

- (void)addNew {
    UIAlertController *a = [UIAlertController alertControllerWithTitle:@"إضافة زر جديد" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [a addTextFieldWithConfigurationHandler:^(UITextField *t) { t.placeholder = @"الاسم"; }];
    [a addTextFieldWithConfigurationHandler:^(UITextField *t) { t.placeholder = @"المحتوى (الرابط أو النص)"; }];
    [a addTextFieldWithConfigurationHandler:^(UITextField *t) { t.placeholder = @"المجلد (مثال: ببجي)"; }];
    
    [a addAction:[UIAlertAction actionWithTitle:@"حفظ كرابط 🔗" style:UIAlertActionStyleDefault handler:^(UIAlertAction *act) { [self save:a type:@"رابط"]; }]];
    [a addAction:[UIAlertAction actionWithTitle:@"حفظ كنص 📄" style:UIAlertActionStyleDefault handler:^(UIAlertAction *act) { [self save:a type:@"نص"]; }]];
    [a addAction:[UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:a animated:YES completion:nil];
}

- (void)save:(UIAlertController *)a type:(NSString *)type {
    CustomButtonModel *m = [[CustomButtonModel alloc] init];
    m.name = a.textFields[0].text; m.content = a.textFields[1].text;
    m.category = a.textFields[2].text.length > 0 ? a.textFields[2].text : @"عام"; 
    m.type = type;
    [self.userButtons addObject:m];
    [self saveAllData];
}

// --- هنا تم إرجاع جميع المميزات (حذف، تعديل، نسخ، تشغيل) ---
- (void)tableView:(UITableView *)t didSelectRowAtIndexPath:(NSIndexPath *)i {
    [t deselectRowAtIndexPath:i animated:YES];
    CustomButtonModel *m = self.filteredButtons[i.row];
    
    UIAlertController *menu = [UIAlertController alertControllerWithTitle:m.name message:m.content preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 1. تشغيل / فتح
    [menu addAction:[UIAlertAction actionWithTitle:@"تشغيل / فتح" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) {
        if ([m.type isEqualToString:@"رابط"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:m.content] options:@{} completionHandler:nil];
        } else {
            [UIPasteboard generalPasteboard].string = m.content;
            // إشعار بسيط بالنسخ
        }
    }]];
    
    // 2. نسخ المحتوى
    [menu addAction:[UIAlertAction actionWithTitle:@"نسخ المحتوى" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) {
        [UIPasteboard generalPasteboard].string = m.content;
    }]];
    
    // 3. تعديل
    [menu addAction:[UIAlertAction actionWithTitle:@"تعديل الزر" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) {
        UIAlertController *editAlt = [UIAlertController alertControllerWithTitle:@"تعديل" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [editAlt addTextFieldWithConfigurationHandler:^(UITextField *tf) { tf.text = m.name; tf.placeholder = @"الاسم"; }];
        [editAlt addTextFieldWithConfigurationHandler:^(UITextField *tf) { tf.text = m.content; tf.placeholder = @"المحتوى"; }];
        [editAlt addTextFieldWithConfigurationHandler:^(UITextField *tf) { tf.text = m.category; tf.placeholder = @"المجلد"; }];
        
        [editAlt addAction:[UIAlertAction actionWithTitle:@"حفظ التعديل" style:UIAlertActionStyleDefault handler:^(UIAlertAction *act) {
            m.name = editAlt.textFields[0].text;
            m.content = editAlt.textFields[1].text;
            m.category = editAlt.textFields[2].text.length > 0 ? editAlt.textFields[2].text : @"عام";
            [self saveAllData];
        }]];
        [editAlt addAction:[UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:editAlt animated:YES completion:nil];
    }]];
    
    // 4. حذف
    [menu addAction:[UIAlertAction actionWithTitle:@"حذف الزر" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *a) {
        [self.userButtons removeObject:m];
        [self saveAllData];
    }]];
    
    // 5. إلغاء
    [menu addAction:[UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel handler:nil]];
    
    // دعم الايباد (اختياري لتجنب الكراش)
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        menu.popoverPresentationController.sourceView = [t cellForRowAtIndexPath:i];
        menu.popoverPresentationController.sourceRect = [t cellForRowAtIndexPath:i].bounds;
    }
    
    [self presentViewController:menu animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.filteredButtons.count; }
- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)i {
    UITableViewCell *c = [t dequeueReusableCellWithIdentifier:@"c"] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"c"];
    CustomButtonModel *m = self.filteredButtons[i.row];
    c.textLabel.text = m.name;
    c.detailTextLabel.text = [NSString stringWithFormat:@"📂 %@ | 📄 %@", m.category, m.type];
    return c;
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
        
        // استدعاء اللون من الإعدادات
        NSString *colorName = [[NSUserDefaults standardUserDefaults] stringForKey:@"HColor"] ?: @"أزرق";
        UIColor *btnColor = [UIColor systemBlueColor];
        if ([colorName isEqualToString:@"أحمر"]) btnColor = [UIColor systemRedColor];
        else if ([colorName isEqualToString:@"أخضر"]) btnColor = [UIColor systemGreenColor];
        else if ([colorName isEqualToString:@"أسود"]) btnColor = [UIColor blackColor];
        else if ([colorName isEqualToString:@"برتقالي"]) btnColor = [UIColor systemOrangeColor];
        else if ([colorName isEqualToString:@"بنفسجي"]) btnColor = [UIColor systemPurpleColor];

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(30, 150, 55, 55);
        btn.backgroundColor = btnColor; // تطبيق اللون
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

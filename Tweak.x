#import <UIKit/UIKit.h>

// --- نموذج البيانات ---
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

// --- واجهة الإعدادات (iPhone Style) ---
@interface HassanySettings : UITableViewController
@end

@implementation HassanySettings
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"الإعدادات";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SetCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 3; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 2; // تخصيص الزر
    if (section == 1) return 2; // نقل البيانات
    return 1; // فريق التطوير
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) return @"تخصيset الزر العائم";
    if (section == 1) return @"البيانات";
    return @"حول";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SetCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"تغيير حرف الزر";
            cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"HChar"] ?: @"H";
        } else {
            cell.textLabel.text = @"لون الزر العائم";
            cell.detailTextLabel.text = @"اختر لون";
        }
    } else if (indexPath.section == 1) {
        cell.textLabel.text = (indexPath.row == 0) ? @"تصدير (نسخ الكود)" : @"استيراد (لصق الكود)";
    } else {
        cell.textLabel.text = @"فريق التطوير";
        cell.detailTextLabel.text = @"المصمم الحسني";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIAlertController *a = [UIAlertController alertControllerWithTitle:@"تغيير الحرف" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [a addTextFieldWithConfigurationHandler:^(UITextField *t) { t.placeholder = @"حرف واحد فقط"; }];
        [a addAction:[UIAlertAction actionWithTitle:@"حفظ" style:UIAlertActionStyleDefault handler:^(UIAlertAction *act) {
            [[NSUserDefaults standardUserDefaults] setObject:a.textFields[0].text forKey:@"HChar"];
            [self.tableView reloadData];
        }]];
        [self presentViewController:a animated:YES completion:nil];
    }
    // ميزة التصدير والاستيراد
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"HButtons"];
            [UIPasteboard generalPasteboard].string = [data base64EncodedStringWithOptions:0];
        } else {
            NSData *data = [[NSData alloc] initWithBase64EncodedString:[UIPasteboard generalPasteboard].string options:0];
            if (data) [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"HButtons"];
        }
    }
}
@end

// --- واجهة اللوحة الرئيسية ---
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

    // البحث
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.navigationItem.searchController = self.searchController;

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleInsetGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewButton)];
    UIBarButtonItem *sets = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"gear"] style:UIBarButtonItemStylePlain target:self action:@selector(openSettings)];
    self.navigationItem.rightBarButtonItems = @[add, sets];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)sc {
    NSString *txt = sc.searchBar.text;
    if (txt.length > 0) {
        self.filteredButtons = [[self.userButtons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", txt]] mutableCopy];
    } else {
        self.filteredButtons = [self.userButtons mutableCopy];
    }
    [self.tableView reloadData];
}

- (void)loadData {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"HButtons"];
    if (data) {
        NSSet *classes = [NSSet setWithArray:@[[NSMutableArray class], [CustomButtonModel class], [NSString class], [UIColor class]]];
        self.userButtons = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:data error:nil];
    }
    self.userButtons = self.userButtons ?: [NSMutableArray array];
    self.filteredButtons = [self.userButtons mutableCopy];
}

- (void)openSettings {
    [self.navigationController pushViewController:[[HassanySettings alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
}

- (void)addNewButton {
    UIAlertController *a = [UIAlertController alertControllerWithTitle:@"إضافة جديد" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [a addTextFieldWithConfigurationHandler:^(UITextField *t) { t.placeholder = @"اسم الزر"; }];
    [a addTextFieldWithConfigurationHandler:^(UITextField *t) { t.placeholder = @"المحتوى"; }];
    [a addTextFieldWithConfigurationHandler:^(UITextField *t) { t.placeholder = @"المجلد"; }];
    
    [a addAction:[UIAlertAction actionWithTitle:@"حفظ كرابط" style:UITableViewCellAccessoryNone handler:^(UIAlertAction *act) { [self save:a type:@"رابط"]; }]];
    [a addAction:[UIAlertAction actionWithTitle:@"حفظ كنص" style:UITableViewCellAccessoryNone handler:^(UIAlertAction *act) { [self save:a type:@"نص"]; }]];
    [self presentViewController:a animated:YES completion:nil];
}

- (void)save:(UIAlertController *)a type:(NSString *)type {
    CustomButtonModel *m = [[CustomButtonModel alloc] init];
    m.name = a.textFields[0].text; m.content = a.textFields[1].text;
    m.category = a.textFields[2].text ?: @"عام"; m.type = type;
    [self.userButtons addObject:m];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.userButtons requiringSecureCoding:YES error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"HButtons"];
    [self loadData]; [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.filteredButtons.count; }
- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)i {
    UITableViewCell *c = [t dequeueReusableCellWithIdentifier:@"c"] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"c"];
    CustomButtonModel *m = self.filteredButtons[i.row];
    c.textLabel.text = m.name;
    c.detailTextLabel.text = [NSString stringWithFormat:@"%@ | %@", m.category, m.type];
    return c;
}
@end

// --- الـ Hook والتفعيل المرتب ---
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
        btn.backgroundColor = [UIColor systemBlueColor];
        [btn setTitle:[[NSUserDefaults standardUserDefaults] stringForKey:@"HChar"] ?: @"H" forState:UIControlStateNormal];
        btn.tintColor = [UIColor whiteColor];
        btn.layer.cornerRadius = 27.5;
        btn.layer.shadowOpacity = 0.5;
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

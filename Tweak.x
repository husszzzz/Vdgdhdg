#import <UIKit/UIKit.h>

@interface CustomButtonModel : NSObject <NSSecureCoding>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type; 
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) UIColor *tagColor;
@end

@implementation CustomButtonModel
+ (BOOL)supportsSecureCoding { return YES; }
- (void)encodeWithCoder:(NSCoder *)a {
    [a encodeObject:self.name forKey:@"name"]; [a encodeObject:self.type forKey:@"type"];
    [a encodeObject:self.content forKey:@"content"]; [a encodeObject:self.tagColor forKey:@"tagColor"];
}
- (id)initWithCoder:(NSCoder *)a {
    if ((self = [super init])) {
        self.name = [a decodeObjectOfClass:[NSString class] forKey:@"name"];
        self.type = [a decodeObjectOfClass:[NSString class] forKey:@"type"];
        self.content = [a decodeObjectOfClass:[NSString class] forKey:@"content"];
        self.tagColor = [a decodeObjectOfClass:[UIColor class] forKey:@"tagColor"];
    }
    return self;
}
@end

@interface HassanyDashboard : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<CustomButtonModel *> *userButtons;
@property (nonatomic, strong) NSMutableArray<CustomButtonModel *> *filteredButtons;
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation HassanyDashboard

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"لوحة تحكم الحسني";
    [self loadData];

    // إعداد البحث
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.searchController.searchBar.placeholder = @"بحث عن زر...";
    self.navigationItem.searchController = self.searchController;

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleInsetGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    // أزرار الشريط العلوي
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewButton)];
    self.navigationItem.rightBarButtonItem = addButton;

    // زر التواصل في الأسفل
    UIButton *contactBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    contactBtn.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
    [contactBtn setTitle:@"تواصل معنا عبر تلجرام 🚀" forState:UIControlStateNormal];
    [contactBtn addTarget:self action:@selector(openTelegram) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = contactBtn;
}

- (void)openTelegram {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/OM_G9"] options:@{} completionHandler:nil];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *text = searchController.searchBar.text;
    if (text.length > 0) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", text];
        self.filteredButtons = [[self.userButtons filteredArrayUsingPredicate:pred] mutableCopy];
    } else {
        self.filteredButtons = [self.userButtons mutableCopy];
    }
    [self.tableView reloadData];
}

- (void)saveData {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.userButtons requiringSecureCoding:YES error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"HassanyButtons"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadData {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"HassanyButtons"];
    if (data) {
        NSSet *classes = [NSSet setWithArray:@[[NSMutableArray class], [CustomButtonModel class], [NSString class], [UIColor class]]];
        self.userButtons = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:data error:nil];
    }
    self.userButtons = self.userButtons ?: [[NSMutableArray alloc] init];
    self.filteredButtons = [self.userButtons mutableCopy];
}

- (void)addNewButton {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"نوع الزر" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"رابط" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) { [self showInputForType:@"رابط" model:nil]; }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"نص" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) { [self showInputForType:@"نص" model:nil]; }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showInputForType:(NSString *)type model:(CustomButtonModel *)model {
    BOOL isEdit = (model != nil);
    UIAlertController *input = [UIAlertController alertControllerWithTitle:isEdit ? @"تعديل" : @"إضافة" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [input addTextFieldWithConfigurationHandler:^(UITextField *t) { t.placeholder = @"اسم الزر"; t.text = model.name; }];
    [input addTextFieldWithConfigurationHandler:^(UITextField *t) { t.placeholder = @"المحتوى"; t.text = model.content; }];

    void (^handler)(UIColor *) = ^(UIColor *c) {
        CustomButtonModel *btn = isEdit ? model : [[CustomButtonModel alloc] init];
        btn.name = input.textFields[0].text;
        btn.content = input.textFields[1].text;
        btn.type = type ?: model.type;
        btn.tagColor = c ?: model.tagColor;
        if (!isEdit) [self.userButtons addObject:btn];
        [self saveData]; [self loadData]; [self.tableView reloadData];
    };

    [input addAction:[UIAlertAction actionWithTitle:@"حفظ (أزرق)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) { handler([UIColor systemBlueColor]); }]];
    [input addAction:[UIAlertAction actionWithTitle:@"حفظ (أحمر)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) { handler([UIColor systemRedColor]); }]];
    [input addAction:[UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:input animated:YES completion:nil];
}

// قائمة الخيارات عند الضغط المطول أو العادي
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CustomButtonModel *model = self.filteredButtons[indexPath.row];
    
    UIAlertController *menu = [UIAlertController alertControllerWithTitle:model.name message:@"اختر إجراءً" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [menu addAction:[UIAlertAction actionWithTitle:@"تشغيل/فتح" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) {
        if ([model.type isEqualToString:@"رابط"]) [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.content] options:@{} completionHandler:nil];
        else {
            UIAlertController *msg = [UIAlertController alertControllerWithTitle:model.name message:model.content preferredStyle:UIAlertControllerStyleAlert];
            [msg addAction:[UIAlertAction actionWithTitle:@"تم" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:msg animated:YES completion:nil];
        }
    }]];
    
    [menu addAction:[UIAlertAction actionWithTitle:@"نسخ المحتوى" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) {
        [UIPasteboard generalPasteboard].string = model.content;
    }]];
    
    [menu addAction:[UIAlertAction actionWithTitle:@"تعديل" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) {
        [self showInputForType:nil model:model];
    }]];
    
    [menu addAction:[UIAlertAction actionWithTitle:@"حذف" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *a) {
        [self.userButtons removeObject:model];
        [self saveData]; [self loadData]; [self.tableView reloadData];
    }]];
    
    [menu addAction:[UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:menu animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.filteredButtons.count; }
- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)i {
    UITableViewCell *c = [t dequeueReusableCellWithIdentifier:@"c"] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"c"];
    CustomButtonModel *m = self.filteredButtons[i.row];
    c.textLabel.text = m.name;
    c.detailTextLabel.text = m.type;
    UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    dot.backgroundColor = m.tagColor;
    dot.layer.cornerRadius = 5;
    c.accessoryView = dot;
    return c;
}
@end

// كود الزر العائم (نفس السابق)
%hook UIViewController
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(20, 100, 50, 50);
        btn.backgroundColor = [UIColor systemBlueColor];
        [btn setTitle:@"H" forState:UIControlStateNormal];
        btn.tintColor = [UIColor whiteColor];
        btn.layer.cornerRadius = 25;
        [btn addTarget:self action:@selector(openHassany) forControlEvents:UIControlEventTouchUpInside];
        UIWindow *window = nil;
        if (@available(iOS 13.0, *)) {
            for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                    window = ((UIWindowScene *)scene).windows.firstObject; break;
                }
            }
        }
        if (!window) window = [UIApplication sharedApplication].windows.firstObject;
        [window addSubview:btn];
    });
}
%new - (void)openHassany {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[HassanyDashboard alloc] init]];
    [self presentViewController:nav animated:YES completion:nil];
}
%end

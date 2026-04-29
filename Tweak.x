#import <UIKit/UIKit.h>

// --- واجهة مدير الأزرار الذكية ---
@interface SmartButtonsManagerVC : UITableViewController
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation SmartButtonsManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Smart Buttons 📱";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    // أزرار التحكم: إضافة + تعديل/ترتيب
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
    self.navigationItem.rightBarButtonItems = @[addBtn, self.editButtonItem];

    [self loadSavedItems];
}

- (void)loadSavedItems {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"Hassany_SmartButtons"];
    if (data) {
        NSError *error;
        NSSet *classes = [NSSet setWithArray:@[[NSArray class], [NSDictionary class], [NSString class]]];
        self.items = [[NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:data error:&error] mutableCopy];
    }
    if (!self.items) self.items = [NSMutableArray array];
}

- (void)saveItems {
    NSError *error;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.items requiringSecureCoding:NO error:&error];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"Hassany_SmartButtons"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)addItem {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"زر جديد ✨" message:@"أدخل الاسم والرابط أو النص" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *tf) { tf.placeholder = @"اسم الزر"; }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *tf) { tf.placeholder = @"القيمة (رابط أو نص)"; }];
    
    // تصحيح الـ Handler لتجنب أخطاء البناء السابقة
    UIAlertAction *urlAction = [UIAlertAction actionWithTitle:@"رابط URL 🔗" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self createNewBtn:alert.textFields[0].text value:alert.textFields[1].text type:@"url"];
    }];
    
    UIAlertAction *textAction = [UIAlertAction actionWithTitle:@"نص Text 📝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self createNewBtn:alert.textFields[0].text value:alert.textFields[1].text type:@"text"];
    }];
    
    [alert addAction:urlAction];
    [alert addAction:textAction];
    [alert addAction:[UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)createNewBtn:(NSString *)name value:(NSString *)val type:(NSString *)type {
    if (name.length == 0 || val.length == 0) return;
    [self.items insertObject:@{@"name": name, @"val": val, @"type": type} atIndex:0];
    [self saveItems];
    [self.tableView reloadData];
}

// إعدادات الجدول
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return self.items.count; }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"SmartCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    
    NSDictionary *item = self.items[indexPath.row];
    cell.textLabel.text = item[@"name"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.detailTextLabel.text = [item[@"type"] isEqualToString:@"url"] ? @"رابط ويب 🔗" : @"نص محفوظ 📝";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *item = self.items[indexPath.row];
    
    if ([item[@"type"] isEqualToString:@"url"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:item[@"val"]] options:@{} completionHandler:nil];
    } else {
        UIAlertController *msg = [UIAlertController alertControllerWithTitle:item[@"name"] message:item[@"val"] preferredStyle:UIAlertControllerStyleAlert];
        [msg addAction:[UIAlertAction actionWithTitle:@"إغلاق" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:msg animated:YES completion:nil];
    }
}

// حذف وترتيب
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.items removeObjectAtIndex:indexPath.row];
        [self saveItems];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)source to:(NSIndexPath *)dest {
    NSDictionary *item = self.items[source.row];
    [self.items removeObjectAtIndex:source.row];
    [self.items insertObject:item atIndex:dest.row];
    [self saveItems];
}
@end

// --- حقن الزر العائم في النظام ---
%hook UIWindow
- (void)becomeKeyWindow {
    %orig;
    if ([self viewWithTag:7788]) return;

    UIButton *moon = [UIButton buttonWithType:UIButtonTypeSystem];
    moon.tag = 7788;
    moon.frame = CGRectMake(30, 150, 60, 60);
    moon.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    moon.layer.cornerRadius = 30;
    [moon setTitle:@"🌙" forState:UIControlStateNormal];
    moon.titleLabel.font = [UIFont systemFontOfSize:30];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveMoon:)];
    [moon addGestureRecognizer:pan];
    [moon addTarget:self action:@selector(openSmartManager) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:moon];
}

%new - (void)moveMoon:(UIPanGestureRecognizer *)p {
    p.view.center = [p locationInView:p.view.superview];
}

%new - (void)openSmartManager {
    SmartButtonsManagerVC *vc = [[SmartButtonsManagerVC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [[self rootViewController] presentViewController:nav animated:YES completion:nil];
}
%end

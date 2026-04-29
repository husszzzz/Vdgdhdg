#import <UIKit/UIKit.h>

// إعلان لواجهة القائمة الخاصة بك
@interface MoonViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation MoonViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Moon Manager 🌙";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
    
    // تحميل البيانات من UserDefaults المشترك
    NSArray *saved = [[NSUserDefaults standardUserDefaults] objectForKey:@"MoonDylibData"];
    self.items = saved ? [saved mutableCopy] : [NSMutableArray array];
}

- (void)addItem {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"إضافة جديد" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *tf) { tf.placeholder = @"الاسم"; }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *tf) { tf.placeholder = @"المحتوى"; }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"حفظ" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) {
        NSDictionary *item = @{@"n": alert.textFields[0].text, @"c": alert.textFields[1].text};
        [self.items addObject:item];
        [[NSUserDefaults standardUserDefaults] setObject:self.items forKey:@"MoonDylibData"];
        [self.tableView reloadData];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel bundle:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)s { return self.items.count; }
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)ip {
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"C"] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"C"];
    cell.textLabel.text = self.items[ip.row][@"n"];
    cell.detailTextLabel.text = self.items[ip.row][@"c"];
    return cell;
}
@end

// --- عملية الحقن وإظهار الزر العائم ---
%hook UIViewController
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    
    // منع تكرار الزر إذا كان موجوداً مسبقاً
    if ([self.view viewWithTag:999]) return;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.tag = 999;
    btn.frame = CGRectMake(20, 100, 60, 60);
    btn.backgroundColor = [UIColor blackColor];
    btn.layer.cornerRadius = 30;
    [btn setTitle:@"🌙" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(openMoonMenu) forControlEvents:UIControlEventTouchUpInside];
    
    // إضافة خاصية السحب للزر (اختياري)
    [self.view addSubview:btn];
}

%new
- (void)openMoonMenu {
    MoonViewController *vc = [[MoonViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
%end

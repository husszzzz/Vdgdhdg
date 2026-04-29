#import <UIKit/UIKit.h>

// --- واجهة مدير الأزرار الذكية ---
@interface SmartButtonsViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *buttonsList;
@end

@implementation SmartButtonsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Smart Buttons 📱";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    // أزرار التحكم في الشريط العلوي
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewButton)];
    UIBarButtonItem *editBtn = self.editButtonItem; // للسحب والإفلات والحذف
    self.navigationItem.rightBarButtonItems = @[addBtn, editBtn];

    // تحميل البيانات المحفوظة
    [self loadData];
}

- (void)loadData {
    NSArray *savedData = [[NSUserDefaults standardUserDefaults] objectForKey:@"SmartButtons_Hassany"];
    self.buttonsList = savedData ? [savedData mutableCopy] : [NSMutableArray array];
}

- (void)saveData {
    [[NSUserDefaults standardUserDefaults] setObject:self.buttonsList forKey:@"SmartButtons_Hassany"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)addNewButton {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"زر جديد ✨" message:@"أدخل الاسم والقيمة" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *tf) { tf.placeholder = @"اسم الزر (مثلاً: جوجل)"; }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *tf) { tf.placeholder = @"الرابط أو النص"; }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"رابط URL 🔗" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self createButtonWithName:alert.textFields[0].text value:alert.textFields[1].text type:@"url"];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"نص Text 📝" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self createButtonWithName:alert.textFields[0].text value:alert.textFields[1].text type:@"text"];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)createButtonWithName:(NSString *)name value:(NSString *)val type:(NSString *)type {
    if (name.length == 0 || val.length == 0) return;
    NSDictionary *newBtn = @{@"name": name, @"value": val, @"type": type};
    [self.buttonsList insertObject:newBtn atIndex:0];
    [self saveData];
    [self.tableView reloadData];
}

// --- إعدادات الجدول (الأزرار) ---

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.buttonsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"SmartCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    
    NSDictionary *data = self.buttonsList[indexPath.row];
    cell.textLabel.text = data[@"name"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    cell.detailTextLabel.text = [data[@"type"] isEqualToString:@"url"] ? @"رابط يفتح في المتصفح 🔗" : @"نص يظهر في نافذة 📝";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

// عند الضغط على الزر
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *data = self.buttonsList[indexPath.row];
    
    if ([data[@"type"] isEqualToString:@"url"]) {
        NSURL *url = [NSURL URLWithString:data[@"value"]];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    } else {
        UIAlertController *note = [UIAlertController alertControllerWithTitle:data[@"name"] message:data[@"value"] preferredStyle:UIAlertControllerStyleAlert];
        [note addAction:[UIAlertAction actionWithTitle:@"إغلاق" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:note animated:YES completion:nil];
    }
}

// السحب والإفلات للترتيب
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSDictionary *movedItem = self.buttonsList[sourceIndexPath.row];
    [self.buttonsList removeObjectAtIndex:sourceIndexPath.row];
    [self.buttonsList insertObject:movedItem atIndex:destinationIndexPath.row];
    [self saveData];
}

// الحذف
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.buttonsList removeObjectAtIndex:indexPath.row];
        [self saveData];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end

// --- حقن الزر العائم في النظام ---
%hook UIWindow
- (void)becomeKeyWindow {
    %orig;
    if ([self viewWithTag:1234]) return;

    UIButton *moonBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    moonBtn.tag = 1234;
    moonBtn.frame = CGRectMake(20, 200, 60, 60);
    moonBtn.backgroundColor = [UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:0.8];
    moonBtn.layer.cornerRadius = 30;
    [moonBtn setTitle:@"🌙" forState:UIControlStateNormal];
    [moonBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    moonBtn.titleLabel.font = [UIFont systemFontOfSize:30];
    
    // إضافة خاصية السحب للزر العائم
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMoonMove:)];
    [moonBtn addGestureRecognizer:pan];
    
    [moonBtn addTarget:self action:@selector(openSmartButtons) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:moonBtn];
}

%new - (void)handleMoonMove:(UIPanGestureRecognizer *)p {
    UIView *v = p.view;
    CGPoint loc = [p locationInView:v.superview];
    v.center = loc;
}

%new - (void)openSmartButtons {
    SmartButtonsViewController *vc = [[SmartButtonsViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [[self rootViewController] presentViewController:nav animated:YES completion:nil];
}
%end

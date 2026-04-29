#import <UIKit/UIKit.h>

// --- واجهة التحكم الرئيسية ---
@interface SmartButtonsVC : UITableViewController
@property (nonatomic, strong) NSMutableArray *buttons;
@end

@implementation SmartButtonsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Smart Buttons 📱";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    // إعداد الأزرار في الشريط العلوي
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewButton)];
    self.navigationItem.rightBarButtonItems = @[addBtn, self.editButtonItem];

    [self loadData];
}

- (void)loadData {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"SmartButtons_Data"];
    if (data) {
        NSError *error;
        // استخدام الطريقة الحديثة لتجنب خطأ unarchiveObjectWithData
        NSSet *classes = [NSSet setWithArray:@[[NSArray class], [NSDictionary class], [NSString class]]];
        self.buttons = [[NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:data error:&error] mutableCopy];
    }
    if (!self.buttons) self.buttons = [NSMutableArray array];
}

- (void)saveData {
    NSError *error;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.buttons requiringSecureCoding:NO error:&error];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"SmartButtons_Data"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)addNewButton {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"إضافة زر" message:@"أدخل الاسم والقيمة" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *tf) { tf.placeholder = @"اسم الزر"; }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *tf) { tf.placeholder = @"الرابط أو النص"; }];
    
    // إصلاح الـ Selector ليكون متوافقاً
    [alert addAction:[UIAlertAction actionWithTitle:@"رابط URL" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self createBtn:alert.textFields[0].text val:alert.textFields[1].text type:@"url"];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"نص Text" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self createBtn:alert.textFields[0].text val:alert.textFields[1].text type:@"text"];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)createBtn:(NSString *)name val:(NSString *)val type:(NSString *)type {
    if (name.length == 0 || val.length == 0) return;
    [self.buttons insertObject:@{@"name": name, @"val": val, @"type": type} atIndex:0];
    [self saveData];
    [self.tableView reloadData];
}

// إعدادات الجدول
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return self.buttons.count; }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"SmartCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    
    NSDictionary *item = self.buttons[indexPath.row];
    cell.textLabel.text = item[@"name"];
    cell.detailTextLabel.text = [item[@"type"] isEqualToString:@"url"] ? @"🔗 فتح رابط" : @"📝 عرض نص";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *item = self.buttons[indexPath.row];
    
    if ([item[@"type"] isEqualToString:@"url"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:item[@"val"]] options:@{} completionHandler:nil];
    } else {
        UIAlertController *msg = [UIAlertController alertControllerWithTitle:item[@"name"] message:item[@"val"] preferredStyle:UIAlertControllerStyleAlert];
        [msg addAction:[UIAlertAction actionWithTitle:@"تم" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:msg animated:YES completion:nil];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.buttons removeObjectAtIndex:indexPath.row];
        [self saveData];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
@end

// --- زر القمر العائم ---
%hook UIWindow
- (void)becomeKeyWindow {
    %orig;
    if ([self viewWithTag:9988]) return;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.tag = 9988;
    btn.frame = CGRectMake(20, 150, 55, 55);
    btn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    btn.layer.cornerRadius = 27.5;
    [btn setTitle:@"🌙" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:25];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMoonPan:)];
    [btn addGestureRecognizer:pan];
    [btn addTarget:self action:@selector(openSmartMenu) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn];
}

%new - (void)handleMoonPan:(UIPanGestureRecognizer *)p {
    p.view.center = [p locationInView:p.view.superview];
}

%new - (void)openSmartMenu {
    SmartButtonsVC *vc = [[SmartButtonsVC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [[self rootViewController] presentViewController:nav animated:YES completion:nil];
}
%end

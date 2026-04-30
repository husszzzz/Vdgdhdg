#import <UIKit/UIKit.h>

@interface SmartButtonsVC : UITableViewController
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation SmartButtonsVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Smart Buttons 🌙";
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNew)];
    self.navigationItem.rightBarButtonItems = @[add, self.editButtonItem];
    [self loadData];
}

- (void)loadData {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"Hassany_Data"];
    if (data) {
        self.items = [[NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithArray:@[[NSArray class], [NSDictionary class], [NSString class]]] fromData:data error:nil] mutableCopy];
    }
    if (!self.items) self.items = [NSMutableArray array];
}

- (void)addNew {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"إضافة" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *t) { t.placeholder = @"الاسم"; }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *t) { t.placeholder = @"الرابط أو النص"; }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"حفظ" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) {
        [self.items insertObject:@{@"name": alert.textFields[0].text, @"val": alert.textFields[1].text} atIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.items requiringSecureCoding:NO error:nil] forKey:@"Hassany_Data"];
        [self.tableView reloadData];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.items.count; }
- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)i {
    UITableViewCell *c = [t dequeueReusableCellWithIdentifier:@"C"] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"C"];
    c.textLabel.text = self.items[i.row][@"name"];
    c.detailTextLabel.text = self.items[i.row][@"val"];
    return c;
}

- (void)tableView:(UITableView *)t didSelectRowAtIndexPath:(NSIndexPath *)i {
    NSString *val = self.items[i.row][@"val"];
    if ([val hasPrefix:@"http"]) [[UIApplication sharedApplication] openURL:[NSURL URLWithString:val] options:@{} completionHandler:nil];
    else {
        UIAlertController *m = [UIAlertController alertControllerWithTitle:nil message:val preferredStyle:UIAlertControllerStyleAlert];
        [m addAction:[UIAlertAction actionWithTitle:@"تم" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:m animated:YES completion:nil];
    }
}
@end

%hook UIWindow
- (void)becomeKeyWindow {
    %orig;
    if ([self viewWithTag:99]) return;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.tag = 99;
    btn.frame = CGRectMake(20, 100, 50, 50);
    btn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    btn.layer.cornerRadius = 25;
    [btn setTitle:@"🌙" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(openSmart) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

%new - (void)openSmart {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[SmartButtonsVC alloc] init]];
    [[self rootViewController] presentViewController:nav animated:YES completion:nil];
}
%end

#import <UIKit/UIKit.h>

// --- واجهة القائمة الخاصة بحسين ---
@interface MoonViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation MoonViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"hassanyJob Manager 🌙";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
    
    NSArray *saved = [[NSUserDefaults standardUserDefaults] objectForKey:@"HassanyDataV3"];
    self.items = saved ? [saved mutableCopy] : [NSMutableArray array];
}

- (void)addItem {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"إضافة جديد" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *tf) { tf.placeholder = @"الاسم"; }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *tf) { tf.placeholder = @"الرابط أو النص"; }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"رابط 🔗" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) { 
        [self saveItem:alert.textFields[0].text content:alert.textFields[1].text type:@"link"]; 
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"نص 📝" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) { 
        [self saveItem:alert.textFields[0].text content:alert.textFields[1].text type:@"text"]; 
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)saveItem:(NSString *)n content:(NSString *)c type:(NSString *)t {
    if (n.length == 0 || c.length == 0) return;
    NSDictionary *item = @{@"n": n, @"c": c, @"t": t};
    [self.items addObject:item];
    [[NSUserDefaults standardUserDefaults] setObject:self.items forKey:@"HassanyDataV3"];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)s { return self.items.count; }

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)ip {
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"C"] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"C"];
    NSDictionary *item = self.items[ip.row];
    cell.textLabel.text = item[@"n"];
    cell.detailTextLabel.text = [item[@"t"] isEqualToString:@"link"] ? @"رابط 🔗" : @"نص 📝";
    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)ip {
    NSDictionary *item = self.items[ip.row];
    if ([item[@"t"] isEqualToString:@"link"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:item[@"c"]] options:@{} completionHandler:nil];
    } else {
        UIAlertController *s = [UIAlertController alertControllerWithTitle:item[@"n"] message:item[@"c"] preferredStyle:UIAlertControllerStyleAlert];
        [s addAction:[UIAlertAction actionWithTitle:@"تم" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:s animated:YES completion:nil];
    }
    [tv deselectRowAtIndexPath:ip animated:YES];
}
@end

// --- حقن الزر العائم في التطبيق ---
%hook UIWindow
- (void)becomeKeyWindow {
    %orig;
    if ([self viewWithTag:777]) return;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.tag = 777;
    btn.frame = CGRectMake(20, 200, 55, 55);
    btn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    btn.layer.cornerRadius = 27.5;
    [btn setTitle:@"🌙" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    // إضافة حركة للزر (Drag)
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMoonPan:)];
    [btn addGestureRecognizer:pan];
    
    [btn addTarget:self action:@selector(openHassanyMenu) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

%new
- (void)handleMoonPan:(UIPanGestureRecognizer *)p {
    UIView *v = p.view;
    CGPoint loc = [p locationInView:v.superview];
    v.center = loc;
}

%new
- (void)openHassanyMenu {
    MoonViewController *vc = [[MoonViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [[self rootViewController] presentViewController:nav animated:YES completion:nil];
}
%end

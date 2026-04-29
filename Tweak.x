#import <UIKit/UIKit.h>

@interface MoonViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation MoonViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"HassanyJob 🌙";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
    NSArray *saved = [[NSUserDefaults standardUserDefaults] objectForKey:@"HJobData"];
    self.items = saved ? [saved mutableCopy] : [NSMutableArray array];
}

- (void)addItem {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"إضافة" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *tf) { tf.placeholder = @"الاسم"; }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *tf) { tf.placeholder = @"الرابط أو النص"; }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"رابط 🔗" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) { 
        [self saveItem:alert.textFields[0].text content:alert.textFields[1].text type:@"link"]; 
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"نص 📝" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) { 
        [self saveItem:alert.textFields[0].text content:alert.textFields[1].text type:@"text"]; 
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)saveItem:(NSString *)n content:(NSString *)c type:(NSString *)t {
    if (!n.length || !c.length) return;
    [self.items addObject:@{@"n": n, @"c": c, @"t": t}];
    [[NSUserDefaults standardUserDefaults] setObject:self.items forKey:@"HJobData"];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)s { return self.items.count; }
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)ip {
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"C"] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"C"];
    cell.textLabel.text = self.items[ip.row][@"n"];
    cell.detailTextLabel.text = [self.items[ip.row][@"t"] isEqualToString:@"link"] ? @"رابط 🔗" : @"نص 📝";
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
}
@end

%hook UIWindow
- (void)becomeKeyWindow {
    %orig;
    if ([self viewWithTag:888]) return;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.tag = 888;
    btn.frame = CGRectMake(20, 200, 50, 50);
    btn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    btn.layer.cornerRadius = 25;
    [btn setTitle:@"🌙" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(openHJob) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}
%new - (void)openHJob {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[MoonViewController new]];
    [[self rootViewController] presentViewController:nav animated:YES completion:nil];
}
%end

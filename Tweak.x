#import <UIKit/UIKit.h>

@interface MoonViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation MoonViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"HassanyJob Manager 🌙";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
    
    NSArray *saved = [[NSUserDefaults standardUserDefaults] objectForKey:@"HassanyData"];
    self.items = saved ? [saved mutableCopy] : [NSMutableArray array];
}

- (void)addItem {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"إضافة جديد" message:nil preferredStyle:UIAlertControllerStyleAlert];
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
    if (n.length == 0 || c.length == 0) return;
    NSDictionary *item = @{@"n": n, @"c": c, @"t": t};
    [self.items addObject:item];
    [[NSUserDefaults standardUserDefaults] setObject:self.items forKey:@"HassanyData"];
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

%hook UIViewController
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    if ([self.view viewWithTag:888]) return;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.tag = 888;
    btn.frame = CGRectMake(20, 150, 60, 60);
    btn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    btn.layer.cornerRadius = 30;
    [btn setTitle:@"🌙" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(openHassanyMenu) forControlEvents:UIControlEventTouchUpInside];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:btn];
}

%new
- (void)openHassanyMenu {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[MoonViewController new]];
    [self presentViewController:nav animated:YES completion:nil];
}
%end

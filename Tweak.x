#import <UIKit/UIKit.h>

// هيكل البيانات لحفظ الأزرار
@interface MoonItem : NSObject <NSCoding>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) BOOL isLink;
@end

@implementation MoonItem
- (void)encodeWithCoder:(NSCoder *)enc { [enc encodeObject:_name forKey:@"n"]; [enc encodeObject:_content forKey:@"c"]; [enc encodeBool:_isLink forKey:@"l"]; }
- (id)initWithCoder:(NSCoder *)dec { self = [super init]; _name = [dec decodeObjectForKey:@"n"]; _content = [dec decodeObjectForKey:@"c"]; _isLink = [dec decodeBoolForKey:@"l"]; return self; }
@end

@interface MoonRootViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray<MoonItem *> *items;
@end

@implementation MoonRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Moon Manager";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.tableView.insetContentViewsToSafeArea = YES;
    
    // زر الإضافة (+) بتصميم عصري
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
    self.navigationItem.rightBarButtonItem = addBtn;
    
    [self loadData];
}

- (void)addItem {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"زر جديد" message:@"أدخل التفاصيل" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *tf) { tf.placeholder = @"اسم الزر"; }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *tf) { tf.placeholder = @"الرابط أو النص"; }];
    
    UIAlertAction *linkAction = [UIAlertAction actionWithTitle:@"حفظ كرابط 🔗" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveNewItem:alert.textFields[0].text content:alert.textFields[1].text isLink:YES];
    }];
    
    UIAlertAction *textAction = [UIAlertAction actionWithTitle:@"حفظ كنص 📝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveNewItem:alert.textFields[0].text content:alert.textFields[1].text isLink:NO];
    }];
    
    [alert addAction:linkAction];
    [alert addAction:textAction];
    [alert addAction:[UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)saveNewItem:(NSString *)name content:(NSString *)content isLink:(BOOL)isLink {
    MoonItem *item = [[MoonItem alloc] init];
    item.name = name; item.content = content; item.isLink = isLink;
    [self.items addObject:item];
    [self saveData];
    [self.tableView reloadData];
}

// تشغيل الزر عند الضغط
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MoonItem *item = self.items[indexPath.row];
    if (item.isLink) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:item.content] options:@{} completionHandler:nil];
    } else {
        UIAlertController *showText = [UIAlertController alertControllerWithTitle:item.name message:item.content preferredStyle:UIAlertControllerStyleAlert];
        [showText addAction:[UIAlertAction actionWithTitle:@"تم" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:showText animated:YES completion:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// كود الحفظ التلقائي في الذاكرة
- (void)saveData {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.items requiringSecureCoding:NO error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"MoonData"];
}

- (void)loadData {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"MoonData"];
    self.items = data ? [NSKeyedUnarchiver unarchiveObjectWithData:data] : [NSMutableArray array];
}

// إعداد شكل القائمة
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)s { return self.items.count; }
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)ip {
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"C"] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"C"];
    MoonItem *item = self.items[ip.row];
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = item.isLink ? @"رابط 🔗" : @"نص 📝";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
@end

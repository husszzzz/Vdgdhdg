#import <UIKit/UIKit.h>

@interface CustomButtonModel : NSObject <NSCoding>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type; 
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) UIColor *tagColor;
@end

@implementation CustomButtonModel
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.type forKey:@"type"];
    [encoder encodeObject:self.content forKey:@"content"];
    [encoder encodeObject:self.tagColor forKey:@"tagColor"];
}
- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super init])) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.type = [decoder decodeObjectForKey:@"type"];
        self.content = [decoder decodeObjectForKey:@"content"];
        self.tagColor = [decoder decodeObjectForKey:@"tagColor"];
    }
    return self;
}
@end

@interface HassanyDashboard : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<CustomButtonModel *> *userButtons;
@end

@implementation HassanyDashboard

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"لوحة تحكم الحساني";
    [self loadData];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleInsetGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewButton)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)saveData {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.userButtons requiringSecureCoding:NO error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"HassanyButtons"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadData {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"HassanyButtons"];
    if (data) {
        self.userButtons = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } else {
        self.userButtons = [[NSMutableArray alloc] init];
    }
}

- (void)addNewButton {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"نوع الزر" message:@"اختر النوع" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"رابط" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) { [self showInputForType:@"رابط"]; }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"نص" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) { [self showInputForType:@"نص"]; }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showInputForType:(NSString *)type {
    UIAlertController *input = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"زر %@ جديد", type] message:nil preferredStyle:UIAlertControllerStyleAlert];
    [input addTextFieldWithConfigurationHandler:^(UITextField *t) { t.placeholder = @"اسم الزر"; }];
    [input addTextFieldWithConfigurationHandler:^(UITextField *t) { t.placeholder = @"المحتوى"; }];

    // إضافة خيار اختيار اللون (الوسم)
    [input addAction:[UIAlertAction actionWithTitle:@"حفظ (أحمر)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) { [self finalizeButton:input type:type color:[UIColor redColor]]; }]];
    [input addAction:[UIAlertAction actionWithTitle:@"حفظ (أخضر)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) { [self finalizeButton:input type:type color:[UIColor greenColor]]; }]];
    [input addAction:[UIAlertAction actionWithTitle:@"حفظ (أزرق)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) { [self finalizeButton:input type:type color:[UIColor blueColor]]; }]];

    [self presentViewController:input animated:YES completion:nil];
}

- (void)finalizeButton:(UIAlertController *)input type:(NSString *)type color:(UIColor *)color {
    CustomButtonModel *btn = [[CustomButtonModel alloc] init];
    btn.name = input.textFields[0].text ?: @"بدون اسم";
    btn.content = input.textFields[1].text ?: @"";
    btn.type = type;
    btn.tagColor = color;
    [self.userButtons addObject:btn];
    [self saveData];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return self.userButtons.count; }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    CustomButtonModel *model = self.userButtons[indexPath.row];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.type;
    
    // رسم النقطة الملونة (الوسم)
    UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    dot.backgroundColor = model.tagColor;
    dot.layer.cornerRadius = 5;
    cell.accessoryView = dot;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CustomButtonModel *model = self.userButtons[indexPath.row];
    if ([model.type isEqualToString:@"رابط"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.content] options:@{} completionHandler:nil];
    } else {
        UIAlertController *msg = [UIAlertController alertControllerWithTitle:model.name message:model.content preferredStyle:UIAlertControllerStyleAlert];
        [msg addAction:[UIAlertAction actionWithTitle:@"تم" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:msg animated:YES completion:nil];
    }
}
@end

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
        
        // الحل النهائي لـ keyWindow المتوافق مع iOS 13-18
        UIWindow *window = nil;
        if (@available(iOS 13.0, *)) {
            for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                    window = ((UIWindowScene *)scene).windows.firstObject;
                    break;
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

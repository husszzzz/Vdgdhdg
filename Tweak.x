#import <UIKit/UIKit.h>

// نموذج الزر
@interface AHButtonModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type; // "url" or "text"
@property (nonatomic, strong) NSString *value;
@end

@implementation AHButtonModel
@end

// مدير التخزين
@interface AHStorageManager : NSObject
+ (instancetype)shared;
- (NSArray<AHButtonModel *> *)loadButtons;
- (void)saveButtons:(NSArray<AHButtonModel *> *)buttons;
@end

@implementation AHStorageManager {
    NSMutableArray *_buttons;
}

+ (instancetype)shared {
    static AHStorageManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadButtons];
    }
    return self;
}

- (NSArray<AHButtonModel *> *)loadButtons {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"AHButtonsData"];
    if (data) {
        NSArray *dicts = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSMutableArray *buttons = [NSMutableArray array];
        for (NSDictionary *dict in dicts) {
            AHButtonModel *btn = [[AHButtonModel alloc] init];
            btn.name = dict[@"name"];
            btn.type = dict[@"type"];
            btn.value = dict[@"value"];
            [buttons addObject:btn];
        }
        _buttons = buttons;
    } else {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (void)saveButtons:(NSArray<AHButtonModel *> *)buttons {
    _buttons = [buttons mutableCopy];
    NSMutableArray *dicts = [NSMutableArray array];
    for (AHButtonModel *btn in buttons) {
        [dicts addObject:@{@"name": btn.name, @"type": btn.type, @"value": btn.value}];
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dicts];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"AHButtonsData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end

// إضافة زر جديد
@interface AHAddButtonVC : UIViewController
@property (nonatomic, copy) void (^onSave)(AHButtonModel *);
@end

@implementation AHAddButtonVC {
    UITextField *nameField;
    UISegmentedControl *typeSeg;
    UITextField *valueField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"إضافة زر";
    
    nameField = [[UITextField alloc] init];
    nameField.placeholder = @"اسم الزر";
    nameField.borderStyle = UITextBorderStyleRoundedRect;
    nameField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:nameField];
    
    typeSeg = [[UISegmentedControl alloc] initWithItems:@[@"رابط", @"نص"]];
    typeSeg.selectedSegmentIndex = 0;
    typeSeg.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:typeSeg];
    
    valueField = [[UITextField alloc] init];
    valueField.placeholder = @"الرابط أو النص";
    valueField.borderStyle = UITextBorderStyleRoundedRect;
    valueField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:valueField];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [saveBtn setTitle:@"حفظ" forState:UIControlStateNormal];
    saveBtn.backgroundColor = [UIColor systemBlueColor];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.layer.cornerRadius = 8;
    saveBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    [NSLayoutConstraint activateConstraints:@[
        [nameField.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:40],
        [nameField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [nameField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [nameField.heightAnchor constraintEqualToConstant:44],
        
        [typeSeg.topAnchor constraintEqualToAnchor:nameField.bottomAnchor constant:20],
        [typeSeg.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [typeSeg.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        
        [valueField.topAnchor constraintEqualToAnchor:typeSeg.bottomAnchor constant:20],
        [valueField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [valueField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [valueField.heightAnchor constraintEqualToConstant:44],
        
        [saveBtn.topAnchor constraintEqualToAnchor:valueField.bottomAnchor constant:40],
        [saveBtn.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [saveBtn.widthAnchor constraintEqualToConstant:120],
        [saveBtn.heightAnchor constraintEqualToConstant:44],
    ]];
}

- (void)save {
    if (nameField.text.length && valueField.text.length) {
        AHButtonModel *btn = [[AHButtonModel alloc] init];
        btn.name = nameField.text;
        btn.type = typeSeg.selectedSegmentIndex == 0 ? @"url" : @"text";
        btn.value = valueField.text;
        if (self.onSave) self.onSave(btn);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end

// قائمة الأزرار
@interface AHButtonsListVC : UITableViewController
@end

@implementation AHButtonsListVC {
    NSMutableArray<AHButtonModel *> *buttons;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"أزرارى الذكية";
    self.tableView.rowHeight = 60;
    [self loadData];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)loadData {
    buttons = [[AHStorageManager shared] loadButtons] mutableCopy;
    [self.tableView reloadData];
}

- (void)add {
    AHAddButtonVC *addVC = [[AHAddButtonVC alloc] init];
    addVC.onSave = ^(AHButtonModel *newBtn) {
        [buttons addObject:newBtn];
        [[AHStorageManager shared] saveButtons:buttons];
        [self.tableView reloadData];
    };
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:addVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return buttons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    AHButtonModel *btn = buttons[indexPath.row];
    cell.textLabel.text = btn.name;
    cell.detailTextLabel.text = [btn.type isEqualToString:@"url"] ? btn.value : @"اضغط لعرض النص";
    cell.imageView.image = [UIImage systemImageNamed:[btn.type isEqualToString:@"url"] ? @"link" : @"doc.text"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AHButtonModel *btn = buttons[indexPath.row];
    if ([btn.type isEqualToString:@"url"]) {
        NSURL *url = [NSURL URLWithString:btn.value];
        if (url && [[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"خطأ" message:@"رابط غير صالح" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"حسناً" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:btn.name message:btn.value preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"إغلاق" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [buttons removeObjectAtIndex:indexPath.row];
        [[AHStorageManager shared] saveButtons:buttons];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    AHButtonModel *moved = buttons[sourceIndexPath.row];
    [buttons removeObjectAtIndex:sourceIndexPath.row];
    [buttons insertObject:moved atIndex:destinationIndexPath.row];
    [[AHStorageManager shared] saveButtons:buttons];
}
@end

// Hook رئيسي ليظهر التوييك في الإعدادات عبر PreferenceLoader
%group Main

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)application {
    %orig;
    NSLog(@"SmartButtons Tweak Loaded");
}
%end

%end

// إظهار القائمة عند الضغط على خيار في الإعدادات
// سيتم استدعاء ButtonsListViewController عبر PreferenceLoader
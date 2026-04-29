#import <UIKit/UIKit.h>

// نموذج الزر
@interface SBButtonModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type; // "url" or "text"
@property (nonatomic, strong) NSString *value;
@end

@implementation SBButtonModel
@end

// مدير التخزين
@interface SBStorageManager : NSObject
+ (instancetype)shared;
- (NSArray<SBButtonModel *> *)loadButtons;
- (void)saveButtons:(NSArray<SBButtonModel *> *)buttons;
@end

@implementation SBStorageManager {
    NSMutableArray *_buttons;
}

+ (instancetype)shared {
    static SBStorageManager *instance = nil;
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

- (NSArray<SBButtonModel *> *)loadButtons {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"SmartButtonsData"];
    if (data) {
        NSArray *dicts = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSMutableArray *buttons = [NSMutableArray array];
        for (NSDictionary *dict in dicts) {
            SBButtonModel *btn = [[SBButtonModel alloc] init];
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

- (void)saveButtons:(NSArray<SBButtonModel *> *)buttons {
    _buttons = [buttons mutableCopy];
    NSMutableArray *dicts = [NSMutableArray array];
    for (SBButtonModel *btn in buttons) {
        [dicts addObject:@{@"name": btn.name, @"type": btn.type, @"value": btn.value}];
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dicts];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"SmartButtonsData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end

// نافذة الإضافة
@interface AddButtonViewController : UIViewController
@property (nonatomic, copy) void (^onSave)(SBButtonModel *);
@end

@implementation AddButtonViewController {
    UITextField *nameField;
    UISegmentedControl *typeSeg;
    UITextField *valueField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"إضافة زر جديد";
    
    // اسم الزر
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"اسم الزر:";
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:nameLabel];
    
    nameField = [[UITextField alloc] init];
    nameField.placeholder = @"مثال: يوتيوب";
    nameField.borderStyle = UITextBorderStyleRoundedRect;
    nameField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:nameField];
    
    // نوع الزر
    UILabel *typeLabel = [[UILabel alloc] init];
    typeLabel.text = @"نوع الزر:";
    typeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:typeLabel];
    
    typeSeg = [[UISegmentedControl alloc] initWithItems:@[@"رابط", @"نص"]];
    typeSeg.selectedSegmentIndex = 0;
    typeSeg.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:typeSeg];
    
    // قيمة الزر
    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.text = @"القيمة:";
    valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:valueLabel];
    
    valueField = [[UITextField alloc] init];
    valueField.placeholder = @"رابط أو نص";
    valueField.borderStyle = UITextBorderStyleRoundedRect;
    valueField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:valueField];
    
    // زر الحفظ
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [saveBtn setTitle:@"حفظ" forState:UIControlStateNormal];
    saveBtn.backgroundColor = [UIColor systemBlueColor];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.layer.cornerRadius = 10;
    saveBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [saveBtn addTarget:self action:@selector(saveTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    // قيود Auto Layout
    [NSLayoutConstraint activateConstraints:@[
        [nameLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20],
        [nameLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [nameField.topAnchor constraintEqualToAnchor:nameLabel.bottomAnchor constant:8],
        [nameField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [nameField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        
        [typeLabel.topAnchor constraintEqualToAnchor:nameField.bottomAnchor constant:20],
        [typeLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [typeSeg.topAnchor constraintEqualToAnchor:typeLabel.bottomAnchor constant:8],
        [typeSeg.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [typeSeg.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        
        [valueLabel.topAnchor constraintEqualToAnchor:typeSeg.bottomAnchor constant:20],
        [valueLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [valueField.topAnchor constraintEqualToAnchor:valueLabel.bottomAnchor constant:8],
        [valueField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [valueField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        
        [saveBtn.topAnchor constraintEqualToAnchor:valueField.bottomAnchor constant:40],
        [saveBtn.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [saveBtn.widthAnchor constraintEqualToConstant:150],
        [saveBtn.heightAnchor constraintEqualToConstant:50],
    ]];
}

- (void)saveTapped {
    if (nameField.text.length == 0 || valueField.text.length == 0) return;
    
    SBButtonModel *newBtn = [[SBButtonModel alloc] init];
    newBtn.name = nameField.text;
    newBtn.type = typeSeg.selectedSegmentIndex == 0 ? @"url" : @"text";
    newBtn.value = valueField.text;
    
    if (self.onSave) self.onSave(newBtn);
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

// القائمة الرئيسية للأزرار
@interface ButtonsListViewController : UITableViewController
@end

@implementation ButtonsListViewController {
    NSMutableArray<SBButtonModel *> *buttons;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"أزرارى الذكية";
    self.tableView.rowHeight = 70;
    [self loadData];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButton)];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)loadData {
    buttons = [[SBStorageManager shared] loadButtons] mutableCopy;
    [self.tableView reloadData];
}

- (void)addButton {
    AddButtonViewController *addVC = [[AddButtonViewController alloc] init];
    addVC.onSave = ^(SBButtonModel *newBtn) {
        [buttons addObject:newBtn];
        [[SBStorageManager shared] saveButtons:buttons];
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
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    SBButtonModel *btn = buttons[indexPath.row];
    cell.textLabel.text = btn.name;
    cell.detailTextLabel.text = [btn.type isEqualToString:@"url"] ? btn.value : @"نص عادي";
    cell.imageView.image = [UIImage systemImageNamed:[btn.type isEqualToString:@"url"] ? @"link" : @"doc.text"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SBButtonModel *btn = buttons[indexPath.row];
    
    if ([btn.type isEqualToString:@"url"]) {
        NSURL *url = [NSURL URLWithString:btn.value];
        if (url && [[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"خطأ" message:@"الرابط غير صالح" preferredStyle:UIAlertControllerStyleAlert];
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
        [[SBStorageManager shared] saveButtons:buttons];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    SBButtonModel *moved = buttons[sourceIndexPath.row];
    [buttons removeObjectAtIndex:sourceIndexPath.row];
    [buttons insertObject:moved atIndex:destinationIndexPath.row];
    [[SBStorageManager shared] saveButtons:buttons];
}
@end

// Hook القائمة الرئيسية للتوييك (إضافة أيقونة في الإعدادات)
%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application {
    %orig;
    // يمكن إضافة أيقونة في الشاشة الرئيسية عبر CydiaSubstrate لكن الأفضل استخدام PreferenceLoader
}

%end

// إضافة للتوييك خيار في الإعدادات عبر PreferenceLoader
// ضع ملف SmartButtons.plist في layout/System/Library/PreferenceLoader/Preferences/
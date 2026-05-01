#import <UIKit/UIKit.h>

// نموذج البيانات مع دعم الحفظ (Coding)
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
@property (nonatomic, strong) UIColor *selectedColor;
@end

@implementation HassanyDashboard

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"لوحة تحكم الحساني";
    self.selectedColor = [UIColor grayColor]; // اللون الافتراضي

    [self loadData]; // تحميل البيانات المحفوظة

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleInsetGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewButton)];
    self.navigationItem.rightBarButtonItem = addButton;
}

// دالة الحفظ الدائم
- (void)saveData {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.userButtons requiringSecureCoding:NO error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"HassanyButtons"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// دالة التحميل
- (void)loadData {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"HassanyButtons"];
    if (data) {
        self.userButtons = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } else {
        self.userButtons = [[NSMutableArray alloc] init];
    }
}

- (void)addNewButton {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"إضافة زر" message:@"اختر تفاصيل الزر واللون" preferredStyle:UIAlertControllerStyleActionSheet];

    // خيار الرابط
    [alert addAction:[UIAlertAction actionWithTitle:@"إضافة رابط" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showInputForType:@"رابط"];
    }]];

    // خيار النص
    [alert addAction:[UIAlertAction actionWithTitle:@"إضافة نص" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showInputForType:@"نص"];
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showInputForType:(NSString *)type {
    UIAlertController *input = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"جديد: %@", type] message:@"أدخل البيانات" preferredStyle:UIAlertControllerStyleAlert];
    
    [input addTextFieldWithConfigurationHandler:^(UITextField *t) { t.placeholder = @"اسم الزر"; }];
    [input addTextFieldWithConfigurationHandler:^(UITextField *t) { t.placeholder = ( [type isEqualToString:@"رابط"] ? @"أدخل الرابط (http://...)" : @"أدخل النص" ); }];

    // إضافة خيارات الألوان (الوسم)
    NSArray *colors = @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor orangeColor], [UIColor purpleColor]];
    NSArray *colorNames = @[@"أحمر", @"أخضر", @"أزرق", @"برتقالي", @"بنفسجي"];

    [input addAction:[UIAlertAction actionWithTitle:@"حفظ" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        CustomButtonModel *btn = [[CustomButtonModel alloc] init];
        btn.name = input.textFields[0].text;
        btn.content = input.textFields[1].text;
        btn.type = type;
        btn.tagColor = self.selectedColor;
        
        [self.userButtons addObject:btn];
        [self saveData]; // حفظ فور الإضافة
        [self.tableView reloadData];
    }]];

    [self presentViewController:input animated:YES completion:nil];
}

// إعداد شكل الجدول (الوسم الملون)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    CustomButtonModel *model = self.userButtons[indexPath.row];
    
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.type;
    
    // إنشاء الوسم الملون (النقطة)
    UIView *tagView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    tagView.backgroundColor = model.tagColor;
    tagView.layer.cornerRadius = 6;
    cell.accessoryView = tagView; // تظهر جهة اليمين
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return self.userButtons.count; }
@end

// كود الحقن (نفس السابق مع زر الحسين العائم)
%hook UIViewController
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(20, 100, 50, 50);
        btn.backgroundColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
        [btn setTitle:@"H" forState:UIControlStateNormal];
        btn.tintColor = [UIColor whiteColor];
        btn.layer.cornerRadius = 25;
        [btn addTarget:self action:@selector(openHassany) forControlEvents:UIControlEventTouchUpInside];
        [[UIApplication sharedApplication].keyWindow addSubview:btn];
    });
}
%new - (void)openHassany {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[HassanyDashboard alloc] init]];
    [self presentViewController:nav animated:YES completion:nil];
}
%end

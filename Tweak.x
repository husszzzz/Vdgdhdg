#import <UIKit/UIKit.h>

// نموذج لبيانات الزر
@interface CustomButtonModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type; 
@property (nonatomic, strong) NSString *content;
@end
@implementation CustomButtonModel
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
    self.userButtons = [[NSMutableArray alloc] init];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleInsetGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewButton)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)addNewButton {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"زر جديد" message:@"أدخل تفاصيل الزر" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *t) { t.placeholder = @"اسم الزر"; }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *t) { t.placeholder = @"النوع (رابط أو نص)"; }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *t) { t.placeholder = @"المحتوى"; }];

    [alert addAction:[UIAlertAction actionWithTitle:@"إضافة" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        CustomButtonModel *newBtn = [[CustomButtonModel alloc] init];
        newBtn.name = alert.textFields[0].text ?: @"بدون اسم";
        newBtn.type = alert.textFields[1].text ?: @"نص";
        newBtn.content = alert.textFields[2].text ?: @"";
        [self.userButtons addObject:newBtn];
        [self.tableView reloadData];
    }]];
    
    // تصحيح الخطأ هنا: حذف bundle:nil
    [alert addAction:[UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return self.userButtons.count; }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    CustomButtonModel *model = self.userButtons[indexPath.row];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"النوع: %@", model.type];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CustomButtonModel *model = self.userButtons[indexPath.row];
    
    if ([model.type containsString:@"رابط"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.content] options:@{} completionHandler:nil];
    } else {
        UIAlertController *show = [UIAlertController alertControllerWithTitle:model.name message:model.content preferredStyle:UIAlertControllerStyleAlert];
        [show addAction:[UIAlertAction actionWithTitle:@"تم" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:show animated:YES completion:nil];
    }
}
@end

%hook UIViewController
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        UIButton *mainBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        mainBtn.frame = CGRectMake(20, 100, 60, 60);
        [mainBtn setTitle:@"H" forState:UIControlStateNormal];
        mainBtn.backgroundColor = [UIColor systemBlueColor];
        mainBtn.tintColor = [UIColor whiteColor];
        mainBtn.layer.cornerRadius = 30;
        [mainBtn addTarget:self action:@selector(openHassanyMenu) forControlEvents:UIControlEventTouchUpInside];
        
        // تصحيح مشكلة keyWindow لتعمل على iOS 13+ و iOS 18
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
        [window addSubview:mainBtn];
    });
}

%new
- (void)openHassanyMenu {
    HassanyDashboard *vc = [[HassanyDashboard alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
%end

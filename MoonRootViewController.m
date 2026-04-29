#import <UIKit/UIKit.h>

// واجهة التطبيق والـ AppDelegate
@interface MoonAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@end

@interface MoonRootViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation MoonAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    MoonRootViewController *rootVC = [[MoonRootViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootVC];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}
@end

@implementation MoonRootViewController
// هنا تضع كود الأزرار الذي أعطيتك إياه سابقاً
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Moon Manager";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
    self.navigationItem.rightBarButtonItem = addBtn;
    self.items = [NSMutableArray array];
}

- (void)addItem {
    // كود إضافة زر (رابط أو نص)
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)s { return self.items.count; }
@end

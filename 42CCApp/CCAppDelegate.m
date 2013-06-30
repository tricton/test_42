#import "CCAppDelegate.h"
#import "CCMe.h"
#import "FBLoginView+session.h"

@implementation CCAppDelegate

@synthesize tabBarController, session, loginController, friendsPage, mainPage, loginView, friendPage, goBackToFriendsList, aboutPage;

-(BOOL) application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:self.session];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.mainPage = [[CCMainPage alloc] init];
    self.friendsPage = [[FBFriendPickerViewController alloc] init];
    self.friendsPage.allowsMultipleSelection = NO;
    self.friendsPage.delegate = self;
    self.friendPage = [[CCFriendPage alloc] init];
    self.aboutPage = [[CCAboutPage alloc] init];
    self.loginController = [[CCFBLogin alloc] init];
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.delegate = self;
    [self switchToTableOfFriendsTab];
    self.loginView = (FBLoginView *)[loginController.view viewWithTag:30];
    if ([self.loginView session].isOpen){
        self.window.rootViewController = self.tabBarController;
    }else{
        self.window.rootViewController = self.loginController;
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

-(void) tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController{
    if (viewController == friendsPage){
        [self.friendsPage loadData];
        if (![self.mainPage isIntenetConnectionAvailable]){
            [self.mainPage showAlertWithoutInternet];;
        }
    }
    [self switchToTableOfFriendsTab];
}

-(void) friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker
{
    id<FBGraphUser> selectedFriend;
    for (id<FBGraphUser> friend in friendPicker.selection){
        selectedFriend = friend;
    }
    NSString *friendID = [NSString stringWithFormat:@"https://www.facebook.com/profile.php?id=%@", selectedFriend.id];
    NSURL *friendURL = [NSURL URLWithString:friendID];
    self.friendPage.friendURL = friendURL;
    if (selectedFriend){
        [self switchToSelectedFriendTab];   
    }
}

-(void) switchToSelectedFriendTab
{
    [self.tabBarController setViewControllers:@[self.mainPage, self.friendPage, self.aboutPage]];
    [self appointmentAssetsToTabBar];
}

-(void) switchToTableOfFriendsTab
{
    [self.tabBarController setViewControllers:@[self.mainPage, self.friendsPage, self.aboutPage]];
    [self appointmentAssetsToTabBar];
}

-(void) appointmentAssetsToTabBar
{
    NSArray *titles = @[@"Me", @"Friends", @"About"];
    for (int tab=0; tab<[self.tabBarController.viewControllers count]; tab++){
        UITabBarItem *mainTab = self.tabBarController.tabBar.items[tab];
        mainTab.image = [UIImage imageNamed:titles[tab]];
        mainTab.title = titles[tab];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application{
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
}

-(void) openLoginApp
{
    [self.window setRootViewController:tabBarController];
}

-(void) closeLoginApp
{
    [[loginView session] closeAndClearTokenInformation];
    [self.window setRootViewController:loginController];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application{
}

@end

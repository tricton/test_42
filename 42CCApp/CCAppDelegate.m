#import "CCAppDelegate.h"
#import "CCMe.h"
#import "CCAboutPage.h"
#import "FBLoginView+session.h"

@implementation CCAppDelegate

@synthesize tabBarController, session, loginController, friendsPage;

-(BOOL) application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation{
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:self.session];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    mainPage = [[CCMainPage alloc] init];
    self.friendsPage = [[FBFriendPickerViewController alloc] init];
    self.friendsPage.delegate = self;

    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(140, 0, 180, 30)];
    searchBar.barStyle = UIBarStyleBlackTranslucent;
    searchBar.delegate = self;
    searchBar.tag = 80;
    searchBar.showsCancelButton = YES;
    [self.friendsPage.view addSubview:searchBar];
    CCAboutPage *aboutPage = [[CCAboutPage alloc] init];
    loginController = [[CCFBLogin alloc] init];
    
    [self saveAbout];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.delegate = self;
    [self.tabBarController setViewControllers: @[mainPage, friendsPage, aboutPage]];
    
    NSArray *titles = @[@"Me", @"Friends", @"About"];
    for (int tab=0; tab<[self.tabBarController.viewControllers count]; tab++){
        UITabBarItem *mainTab = self.tabBarController.tabBar.items[tab];
        mainTab.image = [UIImage imageNamed:titles[tab]];
        mainTab.title = titles[tab];
    }
    
    loginView = (FBLoginView *)[loginController.view viewWithTag:30];
    if ([loginView session].isOpen){
        self.window.rootViewController = self.tabBarController;
    }else{
        self.window.rootViewController = loginController;
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    searchText = searchBar.text;
    [searchBar resignFirstResponder];
    [self.friendsPage updateView];
}

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

-(BOOL) friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                 shouldIncludeUser:(id<FBGraphUser>)user{
    if (searchText && ![searchText isEqualToString:@"1"]){
        NSRange result = [user.name rangeOfString:searchText
                                          options:NSCaseInsensitiveSearch];
        if (result.location != NSNotFound){
            return YES;
        }else{
            return NO;
        }
    }else{
        return YES;
    }
    return YES;
}

-(void) saveAbout{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"about"]){
        [[NSUserDefaults standardUserDefaults] setObject:@"Напишите о себе"
                                                  forKey:@"about"];
    }
}

-(void) tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController{
    if (viewController == friendsPage){
        [self.friendsPage loadData];
        if (![mainPage isIntenetConnectionAvailable]){
            [mainPage showAlertWithoutInternet];;
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application{
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
}

-(void) openLoginApp{
    NSString *isFirstLaunch = [[NSUserDefaults standardUserDefaults] objectForKey:@"FirstLogInKey"];
    if ([isFirstLaunch isEqualToString:@"LoadNewData"]){
        [self.window setRootViewController:tabBarController];
        [[NSUserDefaults standardUserDefaults] setObject:@"UseOldData"
                                                  forKey:@"FirstLogInKey"];
    }else if ([isFirstLaunch isEqualToString:@"UseOldData"]){
        [self.window setRootViewController:tabBarController];
    }
}

-(void) closeLoginApp{
    [[NSUserDefaults standardUserDefaults] setObject:@"LoadNewData"
                                              forKey:@"FirstLogInKey"];
    [[loginView session] closeAndClearTokenInformation];
    [self.window setRootViewController:loginController];
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application{
}

@end

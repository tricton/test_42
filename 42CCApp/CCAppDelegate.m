#import "CCAppDelegate.h"
#import "CCMe.h"
#import "CCMainPage.h"
#import "CCAboutPage.h"
#import <FacebookSDK/FBSessionTokenCachingStrategy.h>
#import "FBLoginView+session.h"

@implementation CCAppDelegate

@synthesize tabBarController, session, loginController;

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
    
//    [self loadDataFromBase];
    
    CCMainPage *mainPage = [[CCMainPage alloc] init];
    CCAboutPage *aboutPage = [[CCAboutPage alloc] init];
    loginController = [[CCFBLogin alloc] init];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.delegate = self;
    [self.tabBarController setViewControllers: @[mainPage, aboutPage]];
    
    NSArray *titles = @[@"Me", @"About"];
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

#import "CCAppDelegate.h"
#import "CCMe.h"
#import "CCAboutPage.h"
#import <FacebookSDK/FBSessionTokenCachingStrategy.h>
#import "FBLoginView+session.h"

@implementation CCAppDelegate

@synthesize tabBarController, session, loginController, mainPage;

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
    CCAboutPage *aboutPage = [[CCAboutPage alloc] init];
    loginController = [[CCFBLogin alloc] init];
    
//    [self saveAbout];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.delegate = self;
    [self.tabBarController setViewControllers: @[mainPage, aboutPage]];
    
    NSArray *tab = self.tabBarController.viewControllers;
    NSLog(@"%i",[tab count]);
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
    [self.window setRootViewController:tabBarController];
}

-(void) closeLoginApp{
    [[loginView session] closeAndClearTokenInformation];
    [self.window setRootViewController:loginController];
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application{
}

@end

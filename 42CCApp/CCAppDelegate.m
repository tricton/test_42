#import "CCAppDelegate.h"
#import "CCMe.h"
#import "CCMainPage.h"
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
    loginController = [[CCFBLogin alloc] init];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.delegate = self;
    [self.tabBarController setViewControllers: @[mainPage]];
    
    UITabBarItem *mainTab = self.tabBarController.tabBar.items[0];
    mainTab.image = [UIImage imageNamed:@"me"];
    mainTab.title = @"About";
    
    FBLoginView *loginView = (FBLoginView *)[loginController.view viewWithTag:30];
    if ([loginView session].isOpen){
        self.window.rootViewController = self.tabBarController;
    }else{
        self.window.rootViewController = loginController;
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

//-(FMResultSet *) loadDataFromBase{
//    NSFileManager *fManager = [NSFileManager defaultManager];
//    NSString *workingPath = [self getPathToDatabase];
//    [fManager fileExistsAtPath:workingPath];
//    NSString *fileFromBundle = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"42base.sqlite"];
//    [fManager copyItemAtPath:fileFromBundle
//                      toPath:workingPath
//                       error:nil];
//    FMDatabase *db = [FMDatabase databaseWithPath:[self getPathToDatabase]];
//    [db open];
//    FMResultSet *result = [db executeQuery:@"SELECT * FROM myData"];
//    if ([result next]){
//        [CCMe myData].name = [result stringForColumn:@"name"];
//        [CCMe myData].surName = [result stringForColumn:@"surName"];
//        [CCMe myData].birthDay = [result stringForColumn:@"birthDay"];
//        [CCMe myData].biography = [result stringForColumn:@"biography"];
//        [CCMe myData].address = [result stringForColumn:@"address"];
//        [CCMe myData].phone = [result stringForColumn:@"phone"];
//        [CCMe myData].coordinates = [result stringForColumn:@"coordinates"];
//        [CCMe myData].email = [result stringForColumn:@"email"];
//        [CCMe myData].myPhoto = [UIImage imageWithData:[result dataForColumn:@"photo"]];
//    }
//    return result;
//}

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
    [self.window setRootViewController:loginController];
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application{
}

@end

#import "CCFBLogin.h"
#import "CCAppDelegate.h"

@implementation CCFBLogin

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [loginButton setTitle:@"Log In"
//                 forState:UIControlStateNormal];
//    loginButton.frame = CGRectMake(110, 20, 100, 50);
//    loginButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
//    loginButton.tag = 30;
//    [loginButton addTarget:self
//                    action:@selector(performLogin)
//          forControlEvents:UIControlEventTouchUpInside];
    FBLoginView *loginButton = [[FBLoginView alloc] initWithFrame:CGRectMake(80, 20, 160, 50)];
    loginButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    loginButton.tag = 30;
    loginButton.delegate = self;
    [self.view addSubview:loginButton];
}

//-(void) performLogin{
//    CCAppDelegate *_appDelegate = appDelegate;
//    if (![appDelegate session].isOpen){
//        if (_appDelegate.session.state != FBSessionStateCreated){
//            _appDelegate.session = [[FBSession alloc] init];
//        }
//        [_appDelegate.session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error){}];
//    }else{
//        [_appDelegate.session closeAndClearTokenInformation];
//    }
//}

-(void) loginViewShowingLoggedInUser:(FBLoginView *)loginView{
    [appDelegate openLoginApp];
}

-(void) loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    [appDelegate closeLoginApp];
}

-(void) loginView:(FBLoginView *)loginView
      handleError:(NSError *)error{
    NSString *alertMessage, *alertTitle;
    if (error.fberrorShouldNotifyUser) {
        alertTitle = @"Something Went Wrong";
        alertMessage = error.fberrorUserMessage;
    } else if (error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    } else if (error.fberrorCategory == FBErrorCategoryUserCancelled) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Do You want to log in again?";
    } else {
        alertTitle  = @"Unknown Error";
        alertMessage = @"Error. Please try again later.";
    }
    if (alertMessage) {
        UIAlertView *loginAlertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                                message:alertMessage
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:@"NO", nil];
        loginAlertView.delegate = self;
        [loginAlertView show];
    }
}

-(void)    alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        exit(0);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

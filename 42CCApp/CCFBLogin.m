#import "CCFBLogin.h"
#import "CCAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@interface CCFBLogin ()

@end

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
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginButton setTitle:@"Log In"
                 forState:UIControlStateNormal];
    loginButton.frame = CGRectMake(110, 20, 100, 50);
    loginButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    loginButton.tag = 30;
    [loginButton addTarget:self
                    action:@selector(performLogin)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
}

-(void) performLogin{
    [appDelegate openLoginApp];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

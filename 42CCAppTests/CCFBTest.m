#import "Kiwi.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CCFBLogin.h"
#import "CCAppDelegate.h"

#define appDelegate (CCAppDelegate *)[[UIApplication sharedApplication] delegate]

SPEC_BEGIN(FB_checking)

describe(@"After application start controller CCFBLogin must be active", ^{
    __block UIViewController *currentController = [appDelegate window].rootViewController;
    context(@"CCFBLogin should not give the  user go further inside appllication", ^{
        it(@"Further using of application user should get after login", ^{
            [[currentController should] beKindOfClass:[CCFBLogin class]];
        });
        it(@"CCFBlogin should present button for authentificate in facebook", ^{
            UIButton *loginButton = (UIButton *)[currentController.view viewWithTag:30];
            [loginButton shouldNotBeNil];
            [[loginButton should] receive:@selector(performLogin)];
        });
    });
});

SPEC_END
#import "Kiwi.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CCFBLogin.h"
#import "CCAppDelegate.h"

#define appDelegate (CCAppDelegate *)[[UIApplication sharedApplication] delegate]

SPEC_BEGIN(FB_checking)

describe(@"After application start controller CCFBLogin must be active", ^{
    __block UIViewController *currentController = [appDelegate tabBarController].presentedViewController;
    context(@"CCFBLogin should not give the  user go further inside appllication", ^{
        it(@"Further using of application user should get after login", ^{
            [[currentController should] beKindOfClass:[CCFBLogin class]];
        });
    });
});

SPEC_END
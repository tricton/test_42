#import "Kiwi.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CCFBLogin.h"
#import "CCAppDelegate.h"
#import <FacebookSDK/FBSessionTokenCachingStrategy.h>
#import <FacebookSDK/FBLoginView.h>
#import "FBLoginView+LIttlePatch.h"

#define appDelegate (CCAppDelegate *)[[UIApplication sharedApplication] delegate]

SPEC_BEGIN(FB_checking)

describe(@"After application start controller CCFBLogin must be active", ^{
    __block CCFBLogin *currentController = (CCFBLogin *)[appDelegate window].rootViewController;
    context(@"CCFBLogin should not give the  user go further inside appllication", ^{
        it(@"Further using of application user should get after login", ^{
            [[currentController should] beKindOfClass:[CCFBLogin class]];
        });
        it(@"CCFBlogin should present button for authentificate in facebook. After pressing button sholud launch another app to log in to FB", ^{
            UIView *loginButton = (UIButton *)[currentController.view viewWithTag:30];
            [[loginButton should] beKindOfClass:[FBLoginView class]];
            [[theValue([appDelegate session].isOpen) should] equal:theValue(YES)];
        });
        it(@"App must have a token to store it inside to further user login", ^{
            FBSessionTokenCachingStrategy *tokenCache = [[FBSessionTokenCachingStrategy alloc] initWithUserDefaultTokenInformationKeyName:nil];
            [[[[tokenCache fetchFBAccessTokenData] dictionary] objectForKey:@"com.facebook.sdk:TokenInformationTokenKey"] shouldNotBeNil];
        });
    });
});

SPEC_END
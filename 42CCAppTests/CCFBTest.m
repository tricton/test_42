#import "Kiwi.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CCFBLogin.h"
#import "CCAppDelegate.h"
#import <FacebookSDK/FBSessionTokenCachingStrategy.h>
#import <FacebookSDK/FBLoginView.h>
#import "FBLoginView+session.h"

#define appDelegate (CCAppDelegate *)[[UIApplication sharedApplication] delegate]

SPEC_BEGIN(FB_checking)

describe(@"After application start controller CCFBLogin must be active", ^{
    context(@"CCFBLogin should not give the  user go further inside appllication", ^{
        __block CCFBLogin *currentController = (CCFBLogin *)[appDelegate loginController];
        it(@"Further using of application user should get after login", ^{
            [[currentController should] beKindOfClass:[CCFBLogin class]];
        });
        it(@"CCFBlogin should present button for authentificate in facebook.", ^{
            UIView *loginButton = (UIButton *)[currentController.view viewWithTag:30];
            [[loginButton should] beKindOfClass:[FBLoginView class]];
        });
        it(@"Session to FB should be open to get token. App should not enter to further work with it without login to facebook. App must have a token to store it inside to further user login", ^{
            FBLoginView *loginView = (FBLoginView *)[currentController.view viewWithTag:30];
            FBSessionTokenCachingStrategy *tokenCache = [[FBSessionTokenCachingStrategy alloc] initWithUserDefaultTokenInformationKeyName:nil];
            if ([loginView session].isOpen){
                [[theValue([loginView session].isOpen) should] equal:theValue(YES)];
                [[[[tokenCache fetchFBAccessTokenData] dictionary] objectForKey:@"com.facebook.sdk:TokenInformationTokenKey"] shouldNotBeNil];
                [[[appDelegate window].rootViewController should] equal:[appDelegate tabBarController]];
            }
        });
        it(@"", ^{

            
        });
    });
});

SPEC_END
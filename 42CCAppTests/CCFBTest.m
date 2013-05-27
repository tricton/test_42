#import "Kiwi.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CCFBLogin.h"
#import "CCAppDelegate.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "CCMainPage.h"
#import "CCMe.h"
#import "FBProfilePictureView+getImage.h"

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
            FBSessionTokenCachingStrategy *tokenCache = [[FBSessionTokenCachingStrategy alloc] initWithUserDefaultTokenInformationKeyName:nil];
            if ([FBSession activeSession].isOpen){
                [[theValue([FBSession activeSession].isOpen) should] equal:theValue(YES)];
                [[[[tokenCache fetchFBAccessTokenData] dictionary] objectForKey:@"com.facebook.sdk:TokenInformationTokenKey"] shouldNotBeNil];
                [[[appDelegate window].rootViewController should] equal:[appDelegate tabBarController]];
            } 
        });
        context(@"Data from FB profile should stored in database", ^{
            it(@"Propertys in CCMe should conform to appropropriate propertys in FBGraphUser", ^{
                __block NSDictionary *userInfo;
                if (FBSession.activeSession.isOpen) {
                    [[FBRequest requestForMe] startWithCompletionHandler:
                     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                         if (!error) {
                             userInfo = user;
                         }
                     }];
                }
                [[expectFutureValue([CCMe myData].name) shouldEventuallyBeforeTimingOutAfter(3.0)] equal:[userInfo objectForKey:@"first_name"]];
                [[expectFutureValue([CCMe myData].surName) shouldEventuallyBeforeTimingOutAfter(3.0)] equal:[userInfo objectForKey:@"last_name"]];
                [[expectFutureValue([CCMe myData].birthDay) shouldEventuallyBeforeTimingOutAfter(3.0)] equal:[userInfo objectForKey:@"birthday"]];
                [[expectFutureValue([CCMe myData].biography) shouldEventuallyBeforeTimingOutAfter(3.0)] equal:[userInfo objectForKey:@"bio"]];
                [[expectFutureValue([CCMe myData].address) shouldEventuallyBeforeTimingOutAfter(3.0)] equal:[userInfo objectForKey:@"link"]];
                [[expectFutureValue([CCMe myData].phone) shouldEventuallyBeforeTimingOutAfter(3.0)] equal:[userInfo objectForKey:@"devices"]];
                [[expectFutureValue([CCMe myData].coordinates) shouldEventuallyBeforeTimingOutAfter(3.0)] equal:[userInfo objectForKey:@"location"]];
                [[expectFutureValue([CCMe myData].email) shouldEventuallyBeforeTimingOutAfter(3.0)] equal:[userInfo objectForKey:@"email"]];
                FBProfilePictureView *pictureView = [[FBProfilePictureView alloc] initWithProfileID:[userInfo objectForKey:@"id"]
                                                                                    pictureCropping:FBProfilePictureCroppingOriginal];
                [[expectFutureValue([CCMe myData].myPhoto) shouldEventuallyBeforeTimingOutAfter(3.0)] equal:[pictureView imageView].image];


            });
        });
    });
});

SPEC_END
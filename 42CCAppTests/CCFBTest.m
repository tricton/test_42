#import "Kiwi.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CCFBLogin.h"
#import "CCAppDelegate.h"
//#import <FacebookSDK/FBSessionTokenCachingStrategy.h>
//#import <FacebookSDK/FBLoginView.h>
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
                    [[[CCMe myData].name should] equal:[userInfo objectForKey:@"first_name"]];
                    [[[CCMe myData].surName should] equal:[userInfo objectForKey:@"last_name"]];
                    [[[CCMe myData].birthDay should] equal:[userInfo objectForKey:@"birthday"]];
                    [[[CCMe myData].biography should] equal:[userInfo objectForKey:@"bio"]];
                    [[[CCMe myData].address should] equal:[userInfo objectForKey:@"link"]];
                    [[[CCMe myData].phone should] equal:[userInfo objectForKey:@"devices"]];
                    [[[CCMe myData].coordinates should] equal:[userInfo objectForKey:@"location"]];
                    [[[CCMe myData].email should] equal:[userInfo objectForKey:@"email"]];
                    FBProfilePictureView *pictureView = [[FBProfilePictureView alloc] initWithProfileID:[userInfo objectForKey:@"id"]
                                                                                        pictureCropping:FBProfilePictureCroppingOriginal];
                    [[[CCMe myData].myPhoto should] equal:[pictureView imageView].image];

                

                
            });
        });
    });
});

SPEC_END
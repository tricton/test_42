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
        __block CCMainPage *mainPage = (CCMainPage *)[appDelegate tabBarController].viewControllers[0];
        it(@"Further using of application user should get after login", ^{
            [[currentController should] beKindOfClass:[CCFBLogin class]];
        });
        it(@"CCFBlogin should present button for authentificate in facebook.", ^{
            UIView *loginButton = (UIButton *)[currentController.view viewWithTag:30];
            [[loginButton should] beKindOfClass:[FBLoginView class]];
        });
        it(@"Session to FB should be open to get token. App should not enter to further work with it without login to facebook. App must have a token to store it inside to further user login. Token should save to local storage if session is open", ^{
            FBSessionTokenCachingStrategy *tokenCache = [[FBSessionTokenCachingStrategy alloc] initWithUserDefaultTokenInformationKeyName:nil];
            if ([FBSession activeSession].isOpen){
                [[theValue([FBSession activeSession].isOpen) should] equal:theValue(YES)];
                [[[[tokenCache fetchFBAccessTokenData] dictionary] objectForKey:@"com.facebook.sdk:TokenInformationTokenKey"] shouldNotBeNil];
                NSDictionary *localToken = [NSDictionary dictionaryWithContentsOfFile:[mainPage getPathToDatabase:@"token"]];
                [[[localToken objectForKey:@"com.facebook.sdk:TokenInformationTokenKey" ] should] equal:[[[tokenCache fetchFBAccessTokenData] dictionary] objectForKey:@"com.facebook.sdk:TokenInformationTokenKey"]];
                [[[appDelegate window].rootViewController should] equal:[appDelegate tabBarController]];
            } 
        });
        context(@"Data from FB profile should stored in database", ^{
            it(@"Propertys in CCMe should conform to appropropriate propertys in FBGraphUser.", ^{
                __block NSDictionary *userInfo;
                if ([FBSession activeSession].isOpen) {
                    [mainPage loadDataFromMyPage];
                    [[FBRequest requestForMe] startWithCompletionHandler:
                     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                         if (!error) {
                             userInfo = user;
                             FMDatabase *db = [FMDatabase databaseWithPath:[mainPage getPathToDatabase:@"42base.sqlite"]];
                             [db open];
                             NSArray *results = [NSMutableArray array];
                             FMResultSet *result = [db executeQuery:@"SELECT * FROM FBData"];
                             if ([result next]){
                                 NSString *name = [NSString stringWithFormat:@"%@ %@", [result stringForColumn:@"name"], [result stringForColumn:@"surName"]];
                                 NSString *birthday = [result stringForColumn:@"birthday"];
                                 NSString *gender = [result stringForColumn:@"biography"];
                                 NSString *contact = [result stringForColumn:@"contact"];
                                 results = @[name, birthday, gender, contact];
                             }
                             for(int field=0; field<4; field++){
                                 UITextView *infoField = (UITextView *)[mainPage.view viewWithTag:field+10];
                                 [[theValue(infoField.editable) should] equal:theValue(YES)];
                                 NSString *text = infoField.text;
                                 [[text should] equal:results[field]];
                             }
                         }
                     }];
                }
                [[expectFutureValue(userInfo) shouldEventuallyBeforeTimingOutAfter(3.0)] shouldNotBeNil];
            });
        });
        it(@"We should have internet to work with app", ^{
            if ([mainPage isIntenetConnectionAvailable])
                [[theValue([mainPage isIntenetConnectionAvailable]) should] equal:theValue(YES)];
        });
    });
});

SPEC_END
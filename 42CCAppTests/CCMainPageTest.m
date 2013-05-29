#import "Kiwi.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "CCAppDelegate.h"
#import "CCMe.h"
#import "CCMainPage.h"
#import "CCAboutPage.h"
#import "CCFriendsPage.h"

#define appDelegate (CCAppDelegate *)[[UIApplication sharedApplication] delegate]

SPEC_BEGIN(startApp)

describe(@"Application should create a FMDB entity to work with database", ^{
    __block NSArray *controllers = [appDelegate tabBarController].viewControllers;
    __block CCMainPage *mainPage = (CCMainPage *)controllers[0];
    __block CCFriendsPage *friendsPage = (CCFriendsPage *)controllers[1];
    __block CCAboutPage *aboutPage = (CCAboutPage *)controllers[2];
    __block FMDatabase *db = [FMDatabase databaseWithPath:[mainPage getPathToDatabase:@"42base.sqlite"]];
    context(@"Entity of FMDB must read database from file", ^{
        [db open];
        it(@" Database file must have one row with data",^{
            [db shouldNotBeNil];
        });
    });
    context(@"TabBar controller must appear on the screen with three tabs", ^{
        FMDatabase *db = [FMDatabase databaseWithPath:[mainPage getPathToDatabase:@"42base.sqlite"]];
        [db open];
        it(@"Main view controller should be add to tab bar controller's array. Tab bar should have picture and title",^{
            [[theValue([controllers count]) should] equal:theValue(3)];
            for (int tab=0; tab<[controllers count]; tab++){
                UITabBarItem *item = [appDelegate tabBarController].tabBar.items[tab];
                [controllers[tab] shouldNotBeNil];
                [item.title shouldNotBeNil];
                [item.image shouldNotBeNil];
            }
        });
        it(@"Fields with data should be editable on main page", ^{
            NSMutableArray *results = [NSMutableArray array];
            FMResultSet *result = [db executeQuery:@"SELECT * FROM FBData"];
            if ([result next]){
                [results addObject:[NSString stringWithFormat:@"%@ %@", [result stringForColumn:@"name"], [result stringForColumn:@"surName"]]];
                [results addObject:[result stringForColumn:@"birthday"]];
                [results addObject:[result stringForColumn:@"biography"]];
                [results addObject:[result stringForColumn:@"contact"]];
            }
            for(int field=0; field<4; field++){
                UITextView *infoField = (UITextView *)[mainPage.view viewWithTag:field+10];
                [[theValue(infoField.editable) should] equal:theValue(YES)];
                NSString *text = infoField.text;
                [[text should] equal:results[field]];
            }
        });
        it(@"On third tab should be UITextView", ^{
            UITextView *aboutField = (UITextView *)[aboutPage.view viewWithTag:50];
            [aboutField shouldNotBeNil];
            NSString *about = [[NSUserDefaults standardUserDefaults] objectForKey:@"about"];
            [[aboutField.text should] equal:about];
        });
        it(@"On second tab should present table view with friends", ^{
            [friendsPage allocatingFriendsViewController];
            [[friendsPage friendPickerController] shouldNotBeNil];
            id delegate = [friendsPage friendPickerController];
            [delegate shouldNotBeNil];

        });
        it(@"On second page should present spinner as splash screen for show loading process", ^{
            UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)[friendsPage.view viewWithTag:70];
            [spinner shouldNotBeNil];
        
        });
    });
});

SPEC_END

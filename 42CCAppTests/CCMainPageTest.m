#import "Kiwi.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "CCAppDelegate.h"
#import "CCMe.h"
#import "CCMainPage.h"

#define appDelegate (CCAppDelegate *)[[UIApplication sharedApplication] delegate]

SPEC_BEGIN(startApp)

describe(@"Application should create a FMDB entity to work with database", ^{
    __block CCMainPage *mainPage = (CCMainPage *) [appDelegate tabBarController].viewControllers[0];
    __block FMDatabase *db = [FMDatabase databaseWithPath:[mainPage getPathToDatabase]];
    context(@"Entity of FMDB must read database from file", ^{
        [db open];
        it(@" Database file must have one row with data",^{
            [db shouldNotBeNil];
            [[mainPage loadDataFromMyPage] shouldNotBeNil];
        });
        it(@"Allfields for entity CCMe should not be nil", ^{
            [[CCMe myData].name shouldNotBeNil];
            [[CCMe myData].surName shouldNotBeNil];
            [[CCMe myData].birthDay shouldNotBeNil];
            [[CCMe myData].biography shouldNotBeNil];
            [[CCMe myData].contact shouldNotBeNil];
            [[CCMe myData].myPhoto shouldNotBeNil];
        });
        it(@"All fields for entity CCMe should be filled by appropriate data from database", ^{
            if ([[mainPage loadDataFromMyPage] next]){
                [[[CCMe myData].name should] equal:[[mainPage loadDataFromMyPage] stringForColumn:@"name"]];
                [[[CCMe myData].surName should] equal:[[mainPage loadDataFromMyPage] stringForColumn:@"surName"]] ;
                [[[CCMe myData].birthDay should] equal:[[mainPage loadDataFromMyPage] stringForColumn:@"birthDay"]];
                [[[CCMe myData].biography should] equal:[[mainPage loadDataFromMyPage] stringForColumn:@"biography"]];
                [[[CCMe myData].contact should] equal:[[mainPage loadDataFromMyPage] stringForColumn:@"contact"]];
                [[[CCMe myData].myPhoto should] equal:[[mainPage loadDataFromMyPage] dataForColumn:@"photo"]];
            }
        });
    });
    context(@"TabBar controller must appear on the screen with one tab - Main", ^{
        __block NSArray *controllers = [appDelegate tabBarController].viewControllers;
        UITabBarItem *item = [appDelegate tabBarController].tabBar.items[0];
        it(@"Main view controller should be add to tab bar controller's array. Tab bar should have picture and title",^{
            [controllers[0] shouldNotBeNil];
            [item.title shouldNotBeNil];
            [item.image shouldNotBeNil];
        });
    });
});

SPEC_END

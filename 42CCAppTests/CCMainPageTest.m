#import "Kiwi.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "CCAppDelegate.h"
#import "CCMe.h"

#define appDelegate (CCAppDelegate *)[[UIApplication sharedApplication] delegate]

SPEC_BEGIN(startApp)

describe(@"Application should create a FMDB entity to work with database", ^{
    __block FMDatabase *db = [FMDatabase databaseWithPath:[appDelegate getPathToDatabase]];
    context(@"Entity of FMDB must read database from file", ^{
        [db open];
        it(@" Database file must have one row with data",^{
            [db shouldNotBeNil];
            [[appDelegate loadDataFromBase] shouldNotBeNil];
        });
        it(@"Allfields for entity CCMe should not be nil", ^{
            [[CCMe myData].name shouldNotBeNil];
            [[CCMe myData].surName shouldNotBeNil];
            [[CCMe myData].birthDay shouldNotBeNil];
            [[CCMe myData].biography shouldNotBeNil];
            [[CCMe myData].address shouldNotBeNil];
            [[CCMe myData].phone shouldNotBeNil];
            [[CCMe myData].coordinates shouldNotBeNil];
            [[CCMe myData].email shouldNotBeNil];
            [[CCMe myData].myPhoto shouldNotBeNil];
        });
        it(@"All fields for entity CCMe should be filled by appropriate data from database", ^{
            if ([[appDelegate loadDataFromBase] next]){
                [[[CCMe myData].name should] equal:[[appDelegate loadDataFromBase] stringForColumn:@"name"]];
                [[[CCMe myData].surName should] equal:[[appDelegate loadDataFromBase] stringForColumn:@"surName"]] ;
                [[[CCMe myData].birthDay should] equal:[[appDelegate loadDataFromBase] stringForColumn:@"birthDay"]];
                [[[CCMe myData].biography should] equal:[[appDelegate loadDataFromBase] stringForColumn:@"biography"]];
                [[[CCMe myData].address should] equal:[[appDelegate loadDataFromBase] stringForColumn:@"address"]];
                [[[CCMe myData].phone should] equal:[[appDelegate loadDataFromBase] stringForColumn:@"phone"]];
                [[[CCMe myData].coordinates should] equal:[[appDelegate loadDataFromBase] stringForColumn:@"coordinates"]];
                [[[CCMe myData].email should] equal:[[appDelegate loadDataFromBase] stringForColumn:@"email"]];
                [[[CCMe myData].myPhoto should] equal:[UIImage imageWithData:[[appDelegate loadDataFromBase] dataForColumn:@"photo"]]];
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

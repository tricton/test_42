#import "Kiwi.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "CCAppDelegate.h"
#import "CCMe.h"

#define appDelegate (CCAppDelegate *)[UIApplication sharedApplication].delegate

SPEC_BEGIN(startApp)

describe(@"Application should create a FMDB entity to work with database", ^{
    __block FMDatabase *db = [FMDatabase databaseWithPath:[appDelegate getPathToDatabase]];
    context(@"Entity of FMDB must read database from file", ^{
        [db open];
        it(@" Database file must have one row with data",^{
            [db shouldNotBeNil];
        });
        it(@"All fields for entity CCMe should be filled by appropriate data from database", ^{
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
    });
    context(@"TabBar controller must appear on the screen with one tab - Main", ^{
        __block NSArray *controllers = [appDelegate tabBarController].viewControllers;
        it(@"Main view controller should be add to tab bar controller's array",^{
            [controllers[0] shouldNotBeNil];
        });
    });
});

SPEC_END

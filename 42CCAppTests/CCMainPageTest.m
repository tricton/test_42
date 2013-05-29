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
    __block FMDatabase *db = [FMDatabase databaseWithPath:[mainPage getPathToDatabase:@"42base.sqlite"]];
    context(@"Entity of FMDB must read database from file", ^{
        [db open];
        it(@" Database file must have one row with data",^{
            [db shouldNotBeNil];
        });
    });
    context(@"TabBar controller must appear on the screen with one tab - Main", ^{
        __block NSArray *controllers = [appDelegate tabBarController].viewControllers;
        UITabBarItem *item = [appDelegate tabBarController].tabBar.items[0];
        FMDatabase *db = [FMDatabase databaseWithPath:[mainPage getPathToDatabase:@"42base.sqlite"]];
        [db open];
        __block FMResultSet *result = [db executeQuery:@"SELECT * FROM FBData"];
        it(@"Main view controller should be add to tab bar controller's array. Tab bar should have picture and title",^{
            [controllers[0] shouldNotBeNil];
            [item.title shouldNotBeNil];
            [item.image shouldNotBeNil];
        });
        it(@"Fields with data should be editable", ^{
            NSMutableArray *results = [NSMutableArray array];
            if ([result next]){
                [results addObject:[NSString stringWithFormat:@"%@ %@", [result stringForColumn:@"name"], [result stringForColumn:@"surName"]]];
                [results addObject:[result stringForColumn:@"birthday"]];
                [results addObject:[result stringForColumn:@"biography"]];
                [results addObject:[result stringForColumn:@"contact"]];
            }
            for(int field=0; field<4; field++){
                UITextView *infoField = (UITextView *)[mainPage.view viewWithTag:field+10];
                [[theValue(infoField.editable) should] equal:theValue(YES)];
                [[infoField.text should] equal:[results objectAtIndex:field]];
            }
        });
    });
});

SPEC_END

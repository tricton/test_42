#import "Kiwi.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "CCAppDelegate.h"

#define appDelegate (CCAppDelegate *)[UIApplication sharedApplication].delegate

SPEC_BEGIN(startApp)

describe(@"Application should create a FMDB entity to work with database", ^{
    __block FMDatabase *db = [FMDatabase databaseWithPath:[appDelegate getPathToDatabase]];
    context(@"Entity of FMDB must read database from file", ^{
        [db open];
        it(@" Database file must have one row with data", ^{
            FMResultSet *result = [db executeQuery:@"SELECT * FROM myData"];
            [result shouldNotBeNil];
        });
    });
});

SPEC_END

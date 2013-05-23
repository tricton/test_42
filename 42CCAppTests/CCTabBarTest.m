#import "Kiwi.h"
#import "CCMainPage.h"
#import "CCMe.h"
#import "CCAppDelegate.h"

#define appDelegate (CCAppDelegate *)[[UIApplication sharedApplication] delegate]

SPEC_BEGIN(create_views)

describe(@"Main page must contain my photo, bioraphy, contact data and name in 1 UIImageView and 4 UILabels available in appropriate tags", ^{
    __block CCMainPage *mainPage = [appDelegate tabBarController].viewControllers[0];
    context(@"Text of labels & UIImage propery of UIImageView should not be empty", ^{
        NSString *name = [NSString stringWithFormat:@"%@ %@", [CCMe myData].name, [CCMe myData].surName ];
        NSString *bio = [CCMe myData].biography;
        NSString *birth = [CCMe myData].birthDay;
        NSString *contacts = [NSString stringWithFormat:@"%@ \n %@ \n %@ \n if you want to see where i live - %@", [CCMe myData].address, [CCMe myData].phone, [CCMe myData].email, [CCMe myData].coordinates];
        __block NSArray *labelText = @[name, bio, birth, contacts];
        it(@"Data in object above must be equal to data from database", ^{
            for (int labelTag=0; labelTag<4; labelTag++){
                UILabel *label = (UILabel *)[mainPage.view viewWithTag:labelTag+10];
                [[label.text should] equal:labelText[labelTag]];
            }
            UIImageView *myPhoto = (UIImageView *)[mainPage.view viewWithTag:20];
            [[myPhoto.image should] equal:[CCMe myData].myPhoto];
        });
    });
});

SPEC_END
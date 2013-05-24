#import "Kiwi.h"
#import "CCMainPage.h"
#import "CCMe.h"
#import "CCAppDelegate.h"

#define appDelegate (CCAppDelegate *)[[UIApplication sharedApplication] delegate]

SPEC_BEGIN(create_views)

describe(@"Main page must contain my photo, bioraphy, contact data and name in 1 UIImageView and 4 UILabels available in appropriate tags", ^{
    
    NSArray* (^framesFromViews)(UIViewController *controller) = ^NSArray* (UIViewController * controller){
        UIImageView *myPhotoPortrait = (UIImageView *)[controller.view viewWithTag:20];
        NSValue *portraitRect = [NSValue valueWithCGRect:myPhotoPortrait.frame];
        NSMutableArray *viewFrames = [NSMutableArray array];
        [viewFrames addObject:portraitRect];
        for (int labelTag=0; labelTag<4; labelTag++){
            UILabel *label = (UILabel *)[controller.view viewWithTag:labelTag+10];
            [viewFrames addObject:[NSValue valueWithCGRect:label.frame]];
        }
        return viewFrames;
    };
    
    NSArray* (^constantFramesFromViews)(UIInterfaceOrientationMask orientation) = ^NSArray* (UIInterfaceOrientationMask orientation){
        NSValue *photoFrame;
        NSValue *nameFrame;
        NSValue *birthFrame;
        NSValue *contactsFrame;
        NSValue *bioFrame;
        NSArray *framesArray = [NSArray array];
        if (orientation == UIInterfaceOrientationMaskPortrait){
            photoFrame = [NSValue valueWithCGRect:CGRectMake(96, 20, 128, 128)];
            nameFrame = [NSValue valueWithCGRect:CGRectMake(50, 160, 220, 20)];
            birthFrame = [NSValue valueWithCGRect:CGRectMake(50, 190, 220, 20)];
            contactsFrame = [NSValue valueWithCGRect:CGRectMake(20, 210, 280, 90)];
            bioFrame = [NSValue valueWithCGRect:CGRectMake(20, 310, 280, 90)];
            framesArray = @[photoFrame, nameFrame, birthFrame, contactsFrame, bioFrame];
        }
        if (orientation == UIInterfaceOrientationMaskLandscape){
            photoFrame = [NSValue valueWithCGRect:CGRectMake(20, 20, 128, 128)];
            nameFrame = [NSValue valueWithCGRect:CGRectMake(20, 160, 128, 20)];
            birthFrame = [NSValue valueWithCGRect:CGRectMake(20, 190, 128, 20)];
            contactsFrame = [NSValue valueWithCGRect:CGRectMake(170, 20, 270, 110)];
            bioFrame = [NSValue valueWithCGRect:CGRectMake(170, 120, 270, 110)];
            framesArray = @[photoFrame, nameFrame, birthFrame, contactsFrame, bioFrame];
        }
        return framesArray;
    };
    
    __block CCMainPage *mainPage = [appDelegate tabBarController].viewControllers[0];
    context(@"Text of labels & UIImage propery of UIImageView should not be empty", ^{
        NSString *name = [NSString stringWithFormat:@"%@ %@", [CCMe myData].name, [CCMe myData].surName ];
        NSString *birth = [CCMe myData].birthDay;
        NSString *bio = [CCMe myData].biography;
        NSString *contacts = [NSString stringWithFormat:@"%@ \n %@ \n %@ \n if you want to see where i live coordinates - %@", [CCMe myData].address, [CCMe myData].phone, [CCMe myData].email, [CCMe myData].coordinates];
        __block NSArray *labelText = @[name, birth, contacts, bio];
        it(@"Data in object above must be equal to data from database. ", ^{
            for (int labelTag=0; labelTag<4; labelTag++){
                UILabel *label = (UILabel *)[mainPage.view viewWithTag:labelTag+10];
                [[label.text should] equal:labelText[labelTag]];
            }
            UIImageView *myPhoto = (UIImageView *)[mainPage.view viewWithTag:20];
            [[myPhoto.image should] equal:[CCMe myData].myPhoto];
        });
        context(@"Checking the frames after rotation", ^{
            __block NSArray *viewFramesPortrait = [NSArray array];
            __block NSArray *viewFramesLandscape = [NSArray array];
            it(@"Frames of all view on main page in portrait orienation must have another coordinates than in landscape",^{
                [mainPage changeViewFrames:UIInterfaceOrientationPortrait];
                if (UIInterfaceOrientationMaskPortrait){
                    viewFramesPortrait = framesFromViews(mainPage);
                }
                [mainPage changeViewFrames:UIInterfaceOrientationLandscapeRight];
                if (UIInterfaceOrientationMaskLandscape){
                    viewFramesLandscape = framesFromViews(mainPage);
                }
                for (int frame=0; frame<5; frame++){
                    [[viewFramesPortrait[frame] shouldNot] equal:viewFramesLandscape[frame]];
                }
            });
            it(@"Frames on main view must be equal to some certain values, sracified from some requirements", ^{
                NSArray *expectedFramesPortrait = [NSArray array];
                NSArray *expectedFramesLandscape = [NSArray array];
                [mainPage changeViewFrames:UIInterfaceOrientationPortrait];
                if (UIInterfaceOrientationMaskPortrait){
                    expectedFramesPortrait = constantFramesFromViews(UIInterfaceOrientationMaskPortrait);
                    viewFramesPortrait = framesFromViews(mainPage);
                }
                [mainPage changeViewFrames:UIInterfaceOrientationLandscapeRight];
                if (UIInterfaceOrientationMaskLandscape){
                    expectedFramesLandscape = constantFramesFromViews(UIInterfaceOrientationMaskLandscape);
                    viewFramesLandscape = framesFromViews(mainPage);
                }
                for (int frame=0; frame<5; frame++){
                    [[viewFramesPortrait[frame] should] equal:expectedFramesPortrait[frame]];
                    [[viewFramesLandscape[frame] should] equal:expectedFramesLandscape[frame]];
                }
            });
        });
    });
});

SPEC_END

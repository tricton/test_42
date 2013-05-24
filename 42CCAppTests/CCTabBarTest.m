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
        it(@"Frames of all view on main page in portrait orienation must have another coordinates than in landscape",^{
            NSMutableArray *viewFramesPortrait = [NSMutableArray array];
            NSMutableArray *viewFramesLandscape = [NSMutableArray array];
            NSValue *portraitRect;
            NSValue *landscapeRect;
            [mainPage changeViewFrames:UIInterfaceOrientationPortrait];
            if (UIInterfaceOrientationMaskPortrait){
                UIImageView *myPhotoPortrait = (UIImageView *)[mainPage.view viewWithTag:20];
                portraitRect = [NSValue valueWithCGRect:myPhotoPortrait.frame];
                for (int labelTag=0; labelTag<4; labelTag++){
                    UILabel *label = (UILabel *)[mainPage.view viewWithTag:labelTag+10];
                    [viewFramesPortrait addObject:[NSValue valueWithCGRect:label.frame]];
                }
            }
            [mainPage changeViewFrames:UIInterfaceOrientationLandscapeRight];
            if (UIInterfaceOrientationMaskLandscape){
                UIImageView *myPhotoLandscape = (UIImageView *)[mainPage.view viewWithTag:20];
                landscapeRect = [NSValue valueWithCGRect:myPhotoLandscape.frame];
                for (int labelTag=0; labelTag<4; labelTag++){
                    UILabel *label = (UILabel *)[mainPage.view viewWithTag:labelTag+10];
                    [viewFramesLandscape addObject:[NSValue valueWithCGRect:label.frame]];
                }   
            }
            [[portraitRect shouldNot] equal:landscapeRect];
            for (int frame=0; frame<4; frame++){
                [[viewFramesPortrait[frame] shouldNot] equal:viewFramesLandscape[frame]];
            }
        });
        it(@"Frames on main view must be equal to some certain values, sracified from some requirements", ^{
            NSMutableArray *viewFramesPortrait = [NSMutableArray array];
            NSMutableArray *viewFramesLandscape = [NSMutableArray array];
            NSValue *portraitRect;
            NSValue *landscapeRect;
            NSValue *photoFrame;
            NSValue *nameFrame;
            NSValue *birthFrame;
            NSValue *contactsFrame;
            NSValue *bioFrame;
            NSArray *expectedFramesPortrait = [NSArray array];
            NSArray *expectedFramesLandscape = [NSArray array];
            [mainPage changeViewFrames:UIInterfaceOrientationPortrait];
            if (UIInterfaceOrientationMaskPortrait){
                photoFrame = [NSValue valueWithCGRect:CGRectMake(96, 20, 128, 128)];
                nameFrame = [NSValue valueWithCGRect:CGRectMake(50, 160, 220, 20)];
                birthFrame = [NSValue valueWithCGRect:CGRectMake(50, 190, 220, 20)];
                contactsFrame = [NSValue valueWithCGRect:CGRectMake(20, 210, 280, 80)];
                bioFrame = [NSValue valueWithCGRect:CGRectMake(20, 300, 280, 100)];
                expectedFramesPortrait = @[photoFrame, nameFrame, birthFrame, contactsFrame, bioFrame];
                UIImageView *myPhotoPortrait = (UIImageView *)[mainPage.view viewWithTag:20];
                portraitRect = [NSValue valueWithCGRect:myPhotoPortrait.frame];
                for (int labelTag=0; labelTag<4; labelTag++){
                    UILabel *label = (UILabel *)[mainPage.view viewWithTag:labelTag+10];
                    [viewFramesPortrait addObject:[NSValue valueWithCGRect:label.frame]];
                }
                [viewFramesPortrait insertObject:landscapeRect
                                          atIndex:0];
            }
            [mainPage changeViewFrames:UIInterfaceOrientationLandscapeRight];
            if (UIInterfaceOrientationMaskLandscape){
                photoFrame = [NSValue valueWithCGRect:CGRectMake(20, 20, 128, 128)];
                nameFrame = [NSValue valueWithCGRect:CGRectMake(20, 160, 128, 20)];
                birthFrame = [NSValue valueWithCGRect:CGRectMake(20, 190, 128, 20)];
                contactsFrame = [NSValue valueWithCGRect:CGRectMake(170, 20, 270, 80)];
                bioFrame = [NSValue valueWithCGRect:CGRectMake(170, 110, 270, 130)];
                expectedFramesLandscape = @[photoFrame, nameFrame, birthFrame, contactsFrame, bioFrame];
                UIImageView *myPhotoLandscape = (UIImageView *)[mainPage.view viewWithTag:20];
                landscapeRect = [NSValue valueWithCGRect:myPhotoLandscape.frame];
                for (int labelTag=0; labelTag<4; labelTag++){
                    UILabel *label = (UILabel *)[mainPage.view viewWithTag:labelTag+10];
                    [viewFramesLandscape addObject:[NSValue valueWithCGRect:label.frame]];
                }
                    [viewFramesLandscape insertObject:landscapeRect
                                              atIndex:0];
            }
            for (int frame=0; frame<5; frame++){
                [[viewFramesPortrait[frame] shouldNot] equal:expectedFramesPortrait[frame]];
                [[viewFramesLandscape[frame] shouldNot] equal:expectedFramesLandscape[frame]];
            }

        });
    });
});

SPEC_END
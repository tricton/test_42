//
//  CCMainPage.m
//  42CCApp
//
//  Created by Mykola Kamysh on 23.05.13.
//  Copyright (c) 2013 Mykola Kamysh. All rights reserved.
//

#import "CCMainPage.h"
#import "CCMe.h"

@implementation CCMainPage

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    NSString *name = [NSString stringWithFormat:@"%@ %@", [CCMe myData].name, [CCMe myData].surName ];
    NSString *birth = [CCMe myData].birthDay;
    NSString *bio = [CCMe myData].biography;
    NSString *contacts = [NSString stringWithFormat:@"%@ \n %@ \n %@ \n if you want to see where i live coordinates - %@", [CCMe myData].address, [CCMe myData].phone, [CCMe myData].email, [CCMe myData].coordinates];
    NSArray *labelText = @[name, birth, contacts, bio];
    for (int label=0; label<[labelText count]; label++){
        UILabel *infoLabel = [[UILabel alloc] init/*WithFrame:CGRectMake(10, 150+label*60, 300, 50)*/];
        infoLabel.text = labelText[label];
        infoLabel.tag = label+10;
        [infoLabel sizeToFit];
        infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        infoLabel.numberOfLines = 20;
        [self.view addSubview:infoLabel];
    }
    UIImageView *myPhoto = [[UIImageView alloc] initWithImage:[CCMe myData].myPhoto];
//    myPhoto.frame = CGRectMake(106, 10, 128, 128);
    myPhoto.tag = 20;
    [self.view addSubview:myPhoto];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication]. statusBarOrientation;
    [self changeViewFrames:orientation];
}

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration{
    [self changeViewFrames:toInterfaceOrientation];
}

-(void) changeViewFrames:(UIInterfaceOrientation) orientation{
    UIImageView *myPhoto = (UIImageView *)[self.view viewWithTag:20];
    if (UIInterfaceOrientationIsPortrait(orientation)){
        myPhoto.frame = CGRectMake(106, 10, 128, 128);
        for (int label=0; label<4; label++){
            UILabel *infoLabel = (UILabel *)[self.view viewWithTag:label+10];
            infoLabel.frame = CGRectMake(10, 150+label*60, 300, 50);
        }
    }else{
        myPhoto.frame = CGRectMake(10, 10, 128, 128);
        for (int label=0; label<4; label++){
            UILabel *infoLabel = (UILabel *)[self.view viewWithTag:label+10];
            if (label < 2){
                infoLabel.frame = CGRectMake(10, 140+label*60, 300, 50);
            }else{
                infoLabel.frame = CGRectMake(150, (label-2)*160, 330, 150);
            }
        }
    }
}

@end

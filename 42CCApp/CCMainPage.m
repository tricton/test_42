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
        UILabel *infoLabel = [[UILabel alloc] init];
        infoLabel.text = labelText[label];
        infoLabel.tag = label+10;
        [infoLabel sizeToFit];
        infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        infoLabel.numberOfLines = 20;
        [self.view addSubview:infoLabel];
    }
    UIImageView *myPhoto = [[UIImageView alloc] initWithImage:[CCMe myData].myPhoto];
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
        myPhoto.frame = CGRectMake(96, 20, 128, 128);
        for (int label=0; label<4; label++){
            UILabel *infoLabel = (UILabel *)[self.view viewWithTag:label+10];
            if (label<2){
                infoLabel.frame = CGRectMake(50, 160+label*30, 220, 20);
            }else{
                infoLabel.frame = CGRectMake(20, 210+(label-2)*100, 280, 90);
            }
        }
    }else{        
        myPhoto.frame = CGRectMake(20, 20, 128, 128);
        for (int label=0; label<4; label++){
            UILabel *infoLabel = (UILabel *)[self.view viewWithTag:label+10];
            if (label < 2){
                infoLabel.frame = CGRectMake(20, 160+label*30, 128, 20);
            }else{
                infoLabel.frame = CGRectMake(170, 20+(label-2)*100, 270, 110);
            }
        }
    }
}

@end

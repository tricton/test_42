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
    NSString *contacts = [NSString stringWithFormat:@"%@ \n %@ \n %@ \n if you want to see where i live - %@", [CCMe myData].address, [CCMe myData].phone, [CCMe myData].email, [CCMe myData].coordinates];
    NSArray *labelText = @[name, bio, birth, contacts];
    for (int label=0; label<[labelText count]; label++){
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 150+label*60, 300, 50)];
        infoLabel.text = labelText[label];
        infoLabel.tag = label+10;
        [self.view addSubview:infoLabel];
    }
    UIImageView *myPhoto = [[UIImageView alloc] initWithImage:[CCMe myData].myPhoto];
    myPhoto.frame = CGRectMake(106, 10, 128, 128);
    myPhoto.tag = 20;
    [self.view addSubview:myPhoto];
}

@end

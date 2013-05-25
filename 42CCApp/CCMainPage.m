#import "CCMainPage.h"
#import "CCMe.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CCFBLogin.h"

@interface CCMainPage (){

}

@end

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
        infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        infoLabel.numberOfLines = 0;
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
            float font =[self sizeOfFont:infoLabel];
            infoLabel.font = [UIFont systemFontOfSize:font];
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
            infoLabel.font = [UIFont systemFontOfSize:[self sizeOfFont:infoLabel]];
            NSLog(@"%f", [self sizeOfFont:infoLabel]);
        }
    }
}

-(float) sizeOfFont:(UILabel *) label{
    float fontSize = label.font.pointSize;
    while ([self dicrementFont:label]) {
        fontSize--;
        label.font = [UIFont systemFontOfSize:fontSize];
    }
    return fontSize;
}

-(BOOL) dicrementFont:(UILabel *) label{
    float fontSize = label.font.pointSize;
    CGSize needSize = [label.text sizeWithFont:[UIFont systemFontOfSize:fontSize]
                             constrainedToSize:CGSizeMake(label.frame.size.width, 10000)
                                 lineBreakMode:NSLineBreakByWordWrapping];
    int needNumberOfLines = needSize.height/fontSize;
    int realNumberOfLines = label.frame.size.height/fontSize;
    if (realNumberOfLines<needNumberOfLines){
        return YES;
    }else{
        return NO;
    }
}

@end

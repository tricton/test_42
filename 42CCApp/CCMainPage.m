#import "CCMainPage.h"
#import "CCMe.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CCFBLogin.h"
#import "FMDatabase.h"
#import "CCAppDelegate.h"
#import "FBProfilePictureView+getImage.h"

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
    
//    NSString *name = [NSString stringWithFormat:@"%@ %@", [CCMe myData].name, [CCMe myData].surName ];
//    NSString *birth = [CCMe myData].birthDay;
//    NSString *bio = [CCMe myData].biography;
//    NSString *contacts = [CCMe myData].contact;
//    NSArray *labelText = @[name, birth, contacts, bio];
    for (int label=0; label<4; label++){
        UILabel *infoLabel = [[UILabel alloc] init];
        infoLabel.tag = label+10;
        infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        infoLabel.numberOfLines = 0;
        [self.view addSubview:infoLabel];
    }
    UIImageView *myPhoto = [[UIImageView alloc] init];
//     WithImage:[CCMe myData].myPhoto];
    myPhoto.tag = 20;
    [self.view addSubview:myPhoto];    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication]. statusBarOrientation;
    [self changeViewFrames:orientation];
}

-(void) viewWillAppear:(BOOL)animated{
    [self loadDataFromMyPage];
}

-(FMResultSet *) loadDataFromMyPage{
    NSFileManager *fManager = [NSFileManager defaultManager];
    NSString *workingPath = [self getPathToDatabase];
    [fManager fileExistsAtPath:workingPath];
    NSString *fileFromBundle = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"42base.sqlite"];
    [fManager copyItemAtPath:fileFromBundle
                      toPath:workingPath
                       error:nil];
    FMDatabase *db = [FMDatabase databaseWithPath:[self getPathToDatabase]];
    [db open];
    __block FMResultSet *result;
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 [db executeUpdate:@"DELETE FROM FBData"];
                 FBProfilePictureView *pictureView = [[FBProfilePictureView alloc] initWithProfileID:[user objectForKey:@"id"]
                                                                                     pictureCropping:FBProfilePictureCroppingOriginal];
                 [db executeUpdate:@"insert into FBData (name, surName, biography, contact, birthday, photo) values (?,?,?,?,?,?)", [user objectForKey:@"first_name"], [user objectForKey:@"last_name"], [user objectForKey:@"bio"], [user objectForKey:@"email"], [user objectForKey:@"birthday"], [pictureView imageView].image];
                 result = [db executeQuery:@"SELECT * FROM FBData"];
                 if ([result next]){
                     [CCMe myData].name = [result stringForColumn:@"name"];
                     [CCMe myData].surName = [result stringForColumn:@"surName"];
                     [CCMe myData].birthDay = [result stringForColumn:@"birthday"];
                     [CCMe myData].biography = [result stringForColumn:@"biography"];
                     [CCMe myData].contact = [result stringForColumn:@"contact"];
                     [CCMe myData].myPhoto = [UIImage imageWithData:[result dataForColumn:@"photo"]];
                 }
             }
         }];
    }
    return result;
}

-(NSString *) getPathToDatabase{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = paths[0];
    return [path stringByAppendingPathComponent:@"42base.sqlite"];
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

-(void) saveDataFromFB{

}


@end

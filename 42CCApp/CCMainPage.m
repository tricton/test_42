#import "CCMainPage.h"
#import "CCMe.h"
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
    UIButton *logOutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    logOutButton.tag = 40;
    [logOutButton setTitle:@"Log Out"
                  forState:UIControlStateNormal];
    [logOutButton addTarget:appDelegate
                     action:@selector(closeLoginApp)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logOutButton];
    for (int label=0; label<4; label++){
        UILabel *infoLabel = [[UILabel alloc] init];
        infoLabel.tag = label+10;
        infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        infoLabel.numberOfLines = 0;
        [self.view addSubview:infoLabel];
    }
    UIImageView *myPhoto = [[UIImageView alloc] init];
    myPhoto.tag = 20;
    [self.view addSubview:myPhoto];    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication]. statusBarOrientation;
    [self changeViewFrames:orientation];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(putDataToFields)
                                                 name:@"Download done"
                                               object:nil];
}

-(void) viewWillAppear:(BOOL)animated{
    [self loadDataFromMyPage];
}

-(BOOL) isIntenetConnectionAvailable{
    reachability = [Reachability reachabilityForInternetConnection];
    BOOL is = !reachability.isConnectionRequired;
    return is;
}


-(void) putDataToFields{
    FMDatabase *db = [FMDatabase databaseWithPath:[self getPathToDatabase:@"42base.sqlite"]];
    [db open];
    FMResultSet *result = [db executeQuery:@"SELECT * FROM FBData"];
    if ([result next]){
        [CCMe myData].name = [result stringForColumn:@"name"];
        [CCMe myData].surName = [result stringForColumn:@"surName"];
        [CCMe myData].birthDay = [result stringForColumn:@"birthday"];
        [CCMe myData].biography = [result stringForColumn:@"biography"];
        [CCMe myData].contact = [result stringForColumn:@"contact"];
        [CCMe myData].myPhoto = [UIImage imageWithData:[result dataForColumn:@"photo"]];
    }
    NSMutableArray *labelText = [NSMutableArray array];
    NSString *name = [NSString stringWithFormat:@"%@ %@", [CCMe myData].name, [CCMe myData].surName ];
    if (name){
        [labelText addObject:name];
    }else{
        [labelText addObject:@""];
    }
    NSString *birth = [CCMe myData].birthDay;
    if (birth){
        [labelText addObject:birth];
    }else{
        [labelText addObject:@""];
    }
    NSString *bio = [CCMe myData].biography;
    if (bio){
        [labelText addObject:bio];
    }else{
        [labelText addObject:@""];
    }
    NSString *contact = [CCMe myData].contact;
    if (contact){
        [labelText addObject:contact];
    }else{
        [labelText addObject:@""];
    }
    for (int labelTag=0; labelTag<4; labelTag++){
        UILabel *label = (UILabel *)[self.view viewWithTag:labelTag+10];
        label.text = labelText[labelTag];
    }
    UIImageView *myPhoto = (UIImageView *)[self.view viewWithTag:20];
    myPhoto.image = [CCMe myData].myPhoto;
}

-(void) loadDataFromMyPage{
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:@"FirstLogInKey"];
    NSFileManager *fManager = [NSFileManager defaultManager];
    NSString *workingPath = [self getPathToDatabase:@"42base.sqlite"];
    [fManager fileExistsAtPath:workingPath];
    NSString *fileFromBundle = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"42base.sqlite"];
    [fManager copyItemAtPath:fileFromBundle
                      toPath:workingPath
                       error:nil];
    FMDatabase *db = [FMDatabase databaseWithPath:[self getPathToDatabase:@"42base.sqlite"]];
    [db open];
    if ([key isEqualToString:@"LoadNewData"]){
        if (FBSession.activeSession.isOpen) {
            if ([self isIntenetConnectionAvailable]){
            [[FBRequest requestForMe] startWithCompletionHandler:
             ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                 if (!error) {
                     [db executeUpdate:@"DELETE FROM FBData"];
                     FBProfilePictureView *pictureView = [[FBProfilePictureView alloc] initWithProfileID:user.id
                                                                                         pictureCropping:FBProfilePictureCroppingOriginal];
                     UIImageView *imageView = nil;
                     for (id obj in [pictureView subviews]){
                         if ([obj isMemberOfClass:[UIImageView class]]){
                             imageView = (UIImageView *)obj;
                         }
                     }
                     NSData *pic = UIImagePNGRepresentation(imageView.image);
                     [db executeUpdate:@"insert into FBData (name, surName, biography, contact, birthday, photo) values (?,?,?,?,?,?)", [user objectForKey:@"first_name"], [user objectForKey:@"last_name"], [user objectForKey:@"bio"], [user objectForKey:@"email"], [user objectForKey:@"birthday"], pic];
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"Download done"
                                                                         object:nil];
                 }
             }];
            FBSessionTokenCachingStrategy *tokenCache = [[FBSessionTokenCachingStrategy alloc] initWithUserDefaultTokenInformationKeyName:nil];
            NSDictionary *localToken = [[tokenCache fetchFBAccessTokenData] dictionary];
            [localToken writeToFile:[self getPathToDatabase:@"token"]
                         atomically:YES];
            }else{
                [[[UIAlertView alloc] initWithTitle:@"No internet"
                                            message:@"Find Wifi or Cellular internet"
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
            }
        }
    }else if ([key isEqualToString:@"UseOldData"]){
        [self putDataToFields];
    }
}

-(NSString *) getPathToDatabase:(NSString *) string{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = paths[0];
    return [path stringByAppendingPathComponent:string];
}

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration{
    [self changeViewFrames:toInterfaceOrientation];
}

-(void) changeViewFrames:(UIInterfaceOrientation) orientation{
    UIImageView *myPhoto = (UIImageView *)[self.view viewWithTag:20];
    UIButton *logOutButton = (UIButton *)[self.view viewWithTag:40];
    if (UIInterfaceOrientationIsPortrait(orientation)){
        myPhoto.frame = CGRectMake(96, 20, 128, 128);
        logOutButton.frame = CGRectMake(0, 0, 80, 40);
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
        logOutButton.frame = CGRectMake(0, 150, 80, 40);
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

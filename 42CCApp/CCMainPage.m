#import "CCMainPage.h"
#import "CCMe.h"
#import "CCFBLogin.h"
#import "FMDatabase.h"
#import "CCAppDelegate.h"
#import "FBProfilePictureView+getImage.h"
#import "FBLoginView+session.h"

@interface CCMainPage (){

}

@end

@implementation CCMainPage

@synthesize isFirstLaunch;

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
        UITextView *infoLabel = [[UITextView alloc] init];
        infoLabel.tag = label+10;
        infoLabel.returnKeyType = UIReturnKeyDone;
        infoLabel.delegate = self;
        [self.view addSubview:infoLabel];
    }
    UIImageView *myPhoto = [[UIImageView alloc] init];
    myPhoto.tag = 20;
    [self.view addSubview:myPhoto];    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication]. statusBarOrientation;
    [self changeViewFrames:orientation];
//    [self checkUserChange];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(putDataToFields)
//                                                 name:@"Download done"
//                                               object:nil];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self checkUserChange];
    [self loadDataFromMyPage];
}

//Проверка сменился ли  токен пользователя
-(void) checkUserChange
{
    NSString *tokenFileName = [self getPathToDatabase:@"token"];
    NSDictionary *localToken = [NSDictionary dictionaryWithContentsOfFile:tokenFileName];
    __block NSString *tokenAsIt = [localToken objectForKey:@"com.facebook.sdk:TokenInformationTokenKey"];
    isFirstLaunch = NO;
    if ([self isIntenetConnectionAvailable]){
        FBSessionTokenCachingStrategy *tokenCache = [[FBSessionTokenCachingStrategy alloc] initWithUserDefaultTokenInformationKeyName:nil];
        localToken = [[tokenCache fetchFBAccessTokenData] dictionary];
        NSString *tokenCompareString = [localToken objectForKey:@"com.facebook.sdk:TokenInformationTokenKey"];
        if (![tokenAsIt isEqualToString:tokenCompareString]){
            isFirstLaunch = YES;
        }
        [localToken writeToFile:tokenFileName
                     atomically:YES];
    }else{
        [self showAlertWithoutInternet];
    }
}

//Проверка доступности интернета
-(BOOL) isIntenetConnectionAvailable{
    reachability = [Reachability reachabilityForInternetConnection];
    BOOL is = !reachability.isConnectionRequired;
    return is;
}

//Загрузка данных из БД в программу
-(void) putDataToFields
{
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
    NSString *name = [NSString stringWithFormat:@"%@ %@", [CCMe myData].name, [CCMe myData].surName ];
    if (!name){
        name = @"";
    }
    NSString *birth = [CCMe myData].birthDay;
    if (!birth){
        birth = @"";
    }
    NSString *gender = [CCMe myData].biography;
    if (!gender){
        gender = @"";
    }else{
        if([gender isEqualToString:@"male"]){
            gender = @"Мужик";
        }else if ([gender isEqualToString:@"female"]){
            gender = @"Женщина";
        }
    }
    NSString *contact = [CCMe myData].contact;
    if (!contact){
        contact = @"";
    }
    NSArray *labelText = @[name, birth, gender, contact];
    
    for (int labelTag=0; labelTag<4; labelTag++){
        UITextView *label = (UITextView *)[self.view viewWithTag:labelTag+10];
        label.text = labelText[labelTag];
    }
    UIImageView *myPhoto = (UIImageView *)[self.view viewWithTag:20];
    myPhoto.image = [CCMe myData].myPhoto;
}

//Загрузка данных из странички ФБ
-(void) loadDataFromMyPage
{
    NSFileManager *fManager = [NSFileManager defaultManager];
    NSString *workingPath = [self getPathToDatabase:@"42base.sqlite"];
    [fManager fileExistsAtPath:workingPath];
    NSString *fileFromBundle = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"42base.sqlite"];
    [fManager copyItemAtPath:fileFromBundle
                      toPath:workingPath
                       error:nil];
    if (!isFirstLaunch){
        [self putDataToFields];
    }else{
        FBLoginView *loginView = (FBLoginView *)[[appDelegate loginController].view viewWithTag:30];
        if ([loginView session].isOpen) {
            if ([self isIntenetConnectionAvailable]){
                __block UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                spinner.tag = 70;
                spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
                spinner.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
                [self.view addSubview:spinner];
                [spinner startAnimating];
                [[FBRequest requestForMe] startWithCompletionHandler:
                 ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                     if (!error) {
                         NSDictionary *localToken = [NSDictionary dictionaryWithContentsOfFile:[self getPathToDatabase:@"token"]];
                         NSString *tokenAsIt = [localToken objectForKey:@"com.facebook.sdk:TokenInformationTokenKey"];
                         [self updateDBwithUserData:user
                                       andUserToken:tokenAsIt];
                         [spinner stopAnimating];
                     }
                 }];
            }else{
                [self showAlertWithoutInternet];
            }
        }
    }
}

//загрузка данных в БД из ФБ
-(void) updateDBwithUserData:(NSDictionary<FBGraphUser> *) user
                andUserToken:(NSString *) token
{
    NSString *pictureLinkHeader = @"https://graph.facebook.com/me/?access_token=";
    NSString *pictureLinklEnd = @"&fields=picture";
    NSString *finalLink = [NSString stringWithFormat:@"%@%@%@", pictureLinkHeader, token, pictureLinklEnd];
    NSData *myData = [NSData dataWithContentsOfURL:[NSURL URLWithString:finalLink]];
    NSDictionary *dictResult = [NSJSONSerialization JSONObjectWithData:myData
                                                               options:kNilOptions
                                                                 error:nil];;
    NSString *pictureUrl = [[[dictResult objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
    NSData *pic = [NSData dataWithContentsOfURL:[NSURL URLWithString:pictureUrl]];
    NSString *name = [user objectForKey:@"first_name"];
    if (!name){
        name = @"";
    }
    NSString *surName = [user objectForKey:@"last_name"];
    if (!surName){
        surName = @"";
    }
    NSString *birth = [user objectForKey:@"birthday"];
    if (!birth){
        birth = @"";
    }
    NSString *gender = [user objectForKey:@"gender"];
    if (!gender){
        gender = @"";
    }
    NSString *contact = [[user objectForKey:@"hometown"] objectForKey:@"name"];
    if (!contact){
        contact = @"";
    }
    FMDatabase *db = [FMDatabase databaseWithPath:[self getPathToDatabase:@"42base.sqlite"]];
    [db open];
    [db executeUpdate:@"DELETE FROM FBData"];
    [db executeUpdate:@"insert into FBData (name, surName, biography, contact, birthday, photo) values (?,?,?,?,?,?)", name, surName, gender, contact, birth, pic];
    [self putDataToFields];
}

//нет инета - показываем алерт
-(void) showAlertWithoutInternet
{
    [[[UIAlertView alloc] initWithTitle:@"No internet"
                                message:@"Find Wifi or Cellular internet"
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

//Генерируем строку для сохранения данных
-(NSString *) getPathToDatabase:(NSString *) string
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = paths[0];
    return [path stringByAppendingPathComponent:string];
}

//отработка поворота экрана
-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    [self changeViewFrames:toInterfaceOrientation];
}

//Изменение фреймов вьюх на экране
-(void) changeViewFrames:(UIInterfaceOrientation) orientation
{
    UIImageView *myPhoto = (UIImageView *)[self.view viewWithTag:20];
    UIButton *logOutButton = (UIButton *)[self.view viewWithTag:40];
    if (UIInterfaceOrientationIsPortrait(orientation)){
        myPhoto.frame = CGRectMake(96, 20, 128, 128);
        logOutButton.frame = CGRectMake(0, 0, 80, 20);
        for (int label=0; label<4; label++){
            UITextView *infoLabel = (UITextView *)[self.view viewWithTag:label+10];
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
        logOutButton.frame = CGRectMake(0, 0, 80, 20);
        for (int label=0; label<4; label++){
            UITextView *infoLabel = (UITextView *)[self.view viewWithTag:label+10];
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

//уменьшаем шрифт до нужного размера, чтобы всё вслезло в поле
-(float) sizeOfFont:(UITextView *) label
{
    float fontSize = label.font.pointSize;
    while ([self dicrementFont:label]) {
        fontSize--;
        label.font = [UIFont systemFontOfSize:fontSize];
    }
    return fontSize;
}

//проверка - влезает ли шрифт
-(BOOL) dicrementFont:(UITextView *) label
{
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

//мониторинг нажатия кнопки Ентер
-(BOOL)         textView:(UITextView *)textView
 shouldChangeTextInRange:(NSRange)range
         replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        [self saveDataFromFB];
    }
    return YES;
}

//сохранение данных из полей в БД
-(void) saveDataFromFB
{
    NSMutableArray *texts = [NSMutableArray array];
    for (int label=0; label<4; label++){
        UITextView *infoLabel = (UITextView *)[self.view viewWithTag:label+10];
        [texts addObject:infoLabel.text];
    }
    NSArray *names = [texts[0] componentsSeparatedByString:@" "];
    FMDatabase *db = [FMDatabase databaseWithPath:[self getPathToDatabase:@"42base.sqlite"]];
    [db open];
    [db executeUpdate:@"UPDATE FBData SET name=?, surName=?, birthday=?, biography=?, contact=?", names[0], names [1], texts[1], texts[2], texts[3]];
    
}

@end

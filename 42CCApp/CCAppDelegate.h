//
//  CCAppDelegate.h
//  42CCApp
//
//  Created by Mykola Kamysh on 23.05.13.
//  Copyright (c) 2013 Mykola Kamysh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CCFBLogin.h"
#import "CCMainPage.h"

@interface CCAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, FBFriendPickerDelegate, UISearchBarDelegate>{
    FBLoginView *loginView;
    CCMainPage *mainPage;
    NSString *searchText;
}

@property (strong, nonatomic) UIWindow           *window;
@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) FBSession          *session;
@property (nonatomic, strong) CCFBLogin          *loginController;
@property (nonatomic, strong) FBFriendPickerViewController *friendsPage;

-(void) openLoginApp;
-(void) closeLoginApp;

@end

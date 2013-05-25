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

@interface CCAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow           *window;
@property (nonatomic, strong) UITabBarController *tabBarController;
//@property (nonatomic)         BOOL                inBackground;
@property (nonatomic, strong) FBSession          *session;

-(NSString *) getPathToDatabase;
-(FMResultSet *) loadDataFromBase;
-(void) openLoginApp;

@end

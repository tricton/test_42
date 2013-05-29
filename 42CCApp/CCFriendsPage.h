//
//  CCFriendsPage.h
//  42CCApp
//
//  Created by Mykola Kamysh on 29.05.13.
//  Copyright (c) 2013 Mykola Kamysh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface CCFriendsPage : UIViewController <FBFriendPickerDelegate>

@property (nonatomic, strong) FBFriendPickerViewController *friendPickerController;

-(void) allocatingFriendsViewController;

@end

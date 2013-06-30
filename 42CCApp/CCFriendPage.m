//
//  CCFriendPage.m
//  42CCApp
//
//  Created by Mykola Kamysh on 30.06.13.
//  Copyright (c) 2013 Mykola Kamysh. All rights reserved.
//

#import "CCFriendPage.h"
#import "CCAppDelegate.h"

@interface CCFriendPage ()

@end

@implementation CCFriendPage

@synthesize friendURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect friendPageRect = CGRectMake(0, 40, 320, self.view.frame.size.height-110);
    UIWebView *friendPage = [[UIWebView alloc] init];
    friendPage.frame = friendPageRect;
    friendPage.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    NSURLRequest *friendRequest = [NSURLRequest requestWithURL:friendURL];
    [friendPage loadRequest:friendRequest];
    [self.view addSubview:friendPage];
    UIButton *goBackToFriendsList = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [goBackToFriendsList setTitle:@"Назад"
                         forState:UIControlStateNormal];
    [goBackToFriendsList addTarget:self
                            action:@selector(hideFriend)
                  forControlEvents:UIControlEventTouchUpInside];
    goBackToFriendsList.frame = CGRectMake(0, 0, 320, 40);
    goBackToFriendsList.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:goBackToFriendsList];
}

- (void) hideFriend
{
    [appDelegate switchToTableOfFriendsTab];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

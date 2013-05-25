//
//  CCFBLogin.m
//  42CCApp
//
//  Created by Mykola Kamysh on 25.05.13.
//  Copyright (c) 2013 Mykola Kamysh. All rights reserved.
//

#import "CCFBLogin.h"

@interface CCFBLogin ()

@end

@implementation CCFBLogin

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
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginButton setTitle:@"Log In"
                 forState:UIControlStateNormal];
    loginButton.frame = CGRectMake(110, 20, 100, 50);
    loginButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    loginButton.tag = 30;
    [loginButton addTarget:self
                    action:@selector(performLogin)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
}

-(void) performLogin{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

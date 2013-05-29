//
//  CCFriendsPage.m
//  42CCApp
//
//  Created by Mykola Kamysh on 29.05.13.
//  Copyright (c) 2013 Mykola Kamysh. All rights reserved.
//

#import "CCFriendsPage.h"

@interface CCFriendsPage ()

@end

@implementation CCFriendsPage

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
    UITableView *friendsTableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                                 style:UITableViewStylePlain];
    friendsTableView.tag = 60;
    [self.view addSubview:friendsTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  CCAboutPage.m
//  42CCApp
//
//  Created by Mykola Kamysh on 29.05.13.
//  Copyright (c) 2013 Mykola Kamysh. All rights reserved.
//

#import "CCAboutPage.h"

@interface CCAboutPage ()

@end

@implementation CCAboutPage

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
    UITextView *aboutView = [[UITextView alloc] initWithFrame:self.view.bounds];
    aboutView.tag = 50;
    [self.view addSubview:aboutView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

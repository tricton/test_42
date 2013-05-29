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
    aboutView.delegate = self;
    aboutView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    aboutView.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"about"];
    [self.view addSubview:aboutView];
}

-(BOOL)         textView:(UITextView *)textView
 shouldChangeTextInRange:(NSRange)range
         replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
    }
    return YES;
}
-(void) saveAboutData:(NSString *) text{
    [[NSUserDefaults standardUserDefaults] setObject:text
                                              forKey:@"about"];
}

-(BOOL) textViewShouldEndEditing:(UITextView *)textView{
    [self saveAboutData:textView.text];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

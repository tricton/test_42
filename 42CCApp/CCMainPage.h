//
//  CCMainPage.h
//  42CCApp
//
//  Created by Mykola Kamysh on 23.05.13.
//  Copyright (c) 2013 Mykola Kamysh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Reachability.h"

@interface CCMainPage : UIViewController <FBUserSettingsDelegate, UITextViewDelegate, UITextFieldDelegate>{
    Reachability *reachability;
}

-(void) changeViewFrames:(UIInterfaceOrientation) orientation;
-(void) saveDataFromFB;
-(NSString *) getPathToDatabase:(NSString *) string;
-(void) loadDataFromMyPage;
-(BOOL) isIntenetConnectionAvailable;

@end

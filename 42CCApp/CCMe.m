//
//  CCMe.m
//  42CCApp
//
//  Created by Mykola Kamysh on 23.05.13.
//  Copyright (c) 2013 Mykola Kamysh. All rights reserved.
//

#import "CCMe.h"

@implementation CCMe

@synthesize name, surName, birthDay,biography, contact, myPhoto;

+(CCMe *) myData{
    static CCMe *me = nil;
    static dispatch_once_t once_token;
    dispatch_once (&once_token, ^{
        me = [[super alloc] init];
    });
    return me;
}

@end

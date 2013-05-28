//
//  CCMe.h
//  42CCApp
//
//  Created by Mykola Kamysh on 23.05.13.
//  Copyright (c) 2013 Mykola Kamysh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCMe : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *surName;
@property (nonatomic, strong) NSString *birthDay;
@property (nonatomic, strong) NSString *biography;
@property (nonatomic, strong) NSString *contact;
@property (nonatomic, strong) UIImage *myPhoto;

+(CCMe *) myData;

@end

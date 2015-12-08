//
//  UserInfo.m
//  WhitePonyWeather
//
//  Created by Vokie on 11/14/15.
//  Copyright © 2015 vokie. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

+ (instancetype)sharedUserInfo {
    static UserInfo *sharedUserInfo = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedUserInfo = [[self alloc] init];
    });
    return sharedUserInfo;
}

@end

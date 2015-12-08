//
//  UserInfo.h
//  WhitePonyWeather
//
//  Created by Vokie on 11/14/15.
//  Copyright © 2015 vokie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

+ (instancetype)sharedUserInfo;

@property(retain, nonatomic)NSNumber *lat;
@property(retain, nonatomic)NSNumber *lon;

@end

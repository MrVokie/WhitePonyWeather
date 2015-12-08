//
//  SysModel.h
//  WhitePonyWeather
//
//  Created by Vokie on 9/3/15.
//  Copyright (c) 2015 vokie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SysModel : NSObject
@property NSString *country;       //国家代码
@property NSString *id;
@property NSString *message;
@property NSString *sunrise;   //太阳升起时间
@property NSString *sunset;    //太阳落下时间
@property NSString *type;
@end

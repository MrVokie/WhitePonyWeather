//
//  CurrentWeatherModelOne.h
//  WhitePonyWeather
//
//  Created by Vokie on 9/3/15.
//  Copyright (c) 2015 vokie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainModel.h"
#import "SysModel.h"
#import "CoordModel.h"
#import "CloudsModel.h"
#import "WindModel.h"

@interface CurrentWeatherModelOne : NSObject
@property NSString *base;
@property NSString *name;   //城市名
@property NSString *id;  //城市id

@property NSString *cod;
@property NSString *dt;
@property NSString *visibility;

@property MainModel *main;
@property SysModel *sys;
@property CloudsModel *clouds;
@property CoordModel *coord;
@property WindModel *wind;
@property NSArray *weather;
@end

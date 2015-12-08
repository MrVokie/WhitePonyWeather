//
//  WeatherModel.h
//  WhitePonyWeather
//
//  Created by Vokie on 9/3/15.
//  Copyright (c) 2015 vokie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherModel : NSObject
@property NSString *desc; //薄雾
@property NSString *icon;         //气候的图标id
@property NSString *idx;           //气候条件idx
@property NSString *main;        //天气情况集合

@end

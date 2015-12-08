//
//  WeatherModel.m
//  WhitePonyWeather
//
//  Created by Vokie on 9/3/15.
//  Copyright (c) 2015 vokie. All rights reserved.
//

#import "WeatherModel.h"

@implementation WeatherModel

+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"desc":@"description", @"idx":@"id"};
}

@end

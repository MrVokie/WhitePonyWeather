//
//  ForecastWeatherModel.h
//  WhitePonyWeather
//
//  Created by Vokie on 11/14/15.
//  Copyright © 2015 vokie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TemperatureModel, WeatherModel;

@interface ForecastWeatherModel : NSObject

@property (retain, nonatomic) NSString *clouds;

@property (retain, nonatomic) NSString *dt;

@property (retain, nonatomic) NSString *humidity;

@property (retain, nonatomic) NSString *pressure;

@property (retain, nonatomic) NSString *speed;

@property (retain, nonatomic) TemperatureModel *temp;

@property (retain, nonatomic) NSArray *weather;

@end

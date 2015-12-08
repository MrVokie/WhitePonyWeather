//
//  LanguageConvertManager.h
//  WhitePonyWeather
//
//  Created by ci123 on 15/11/12.
//  Copyright © 2015年 vokie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeatherModel;
@interface LanguageConvertManager : NSObject

+ (instancetype)sharedManager;

- (NSString *)getWindLevel:(NSString *)speed;

- (NSString *)getWeatherDescription:(WeatherModel *)model;

- (NSString *)getFormatWithCloudLevel:(NSString *)cloud;

- (NSString *)getFormatWithHumid:(NSString *)humidity Pressure:(NSString *)pressure;

@end

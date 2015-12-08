//
//  LanguageConvertManager.m
//  WhitePonyWeather
//
//  Created by ci123 on 15/11/12.
//  Copyright © 2015年 vokie. All rights reserved.
//

#import "LanguageConvertManager.h"
#import "WeatherModel.h"

@implementation LanguageConvertManager

+ (instancetype)sharedManager {
    static LanguageConvertManager *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSString *)getWindLevel:(NSString *)speed {
    //当前风速
    NSString *windDesc = @"";
    switch ([speed integerValue]) {
        case 0:
            windDesc = @"基本无风";
            break;
        case 1:
            windDesc = @"微风";
            break;
        case 2:
            windDesc = @"轻风";
            break;
        case 3:
            windDesc = @"略微和风";
            break;
        case 4:
            windDesc = @"和风";
            break;
        case 5:
            windDesc = @"疾风";
            break;
        case 6:
            windDesc = @"强风";
            break;
        case 7:
            windDesc = @"大风";
            break;
        case 8:
            windDesc = @"暴风";
            break;
        case 9:
            windDesc = @"狂风";
            break;
        case 10:
            windDesc = @"台风";
            break;
        case 11:
            windDesc = @"飓风";
            break;
        case 12:
            windDesc = @"超强飓风";
            break;
        default:
            windDesc = @"未知风速";
            break;
    }
    return windDesc;
}

- (NSString *)getWeatherDescription:(WeatherModel *)model{
    NSInteger weatherID = [model.idx integerValue];
    NSString *string = @"";
    switch (weatherID) {
        case 200:
            string  = @"雷鸣小雨"; //thunderstorm with light rain
            break;
        case 201:
            string  = @"雷阵雨"; //thunderstorm with rain
            break;
        case 300:
            string  = @"绵绵细雨"; //light intensity drizzle
            break;
        case 500:
            string  = @"零星小雨"; //light rain
            break;
        case 501:
            string  = @"中雨"; //moderate rain
            break;
        case 502:
            string  = @"暴雨"; //heavy intensity rain
            break;
        case 600:
            string  = @"小雪"; //light snow
            break;
        case 601:
            string  = @"雪"; //snow
            break;
        case 701:
            string  = @"薄雾少云"; //mist
            break;
        case 721:
            string  = @"阴霾多云"; //haze
            break;
        case 800:
            string  = @"天空晴朗"; //sky is clear
            break;
        case 801:
            string  = @"天高云淡"; //few clouds
            break;
        case 802:
            string  = @"少量云朵"; //scattered clouds
            break;
        case 803:
            string  = @"晴转多云"; //broken clouds
            break;
        case 804:
            string  = @"乌云密布"; //overcast clouds
            break;
            
        default:
            string = [NSString stringWithFormat:@"%ld %@",weatherID, model.desc];
            break;
    }
    return string;
}

- (NSString *)getFormatWithCloudLevel:(NSString *)cloud{
    return [NSString stringWithFormat:@"云朵量:%@%%",cloud];
}

- (NSString *)getFormatWithHumid:(NSString *)humidity Pressure:(NSString *)pressure{
    return [NSString stringWithFormat:@"湿度:%@%% 大气压:%@百帕", humidity, pressure];
}

@end

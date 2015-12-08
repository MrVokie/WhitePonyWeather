//
//  WeatherInfoView.m
//  WhitePonyWeather
//
//  Created by Vokie on 11/14/15.
//  Copyright © 2015 vokie. All rights reserved.
//

#import "WeatherInfoView.h"
#import "ForecastWeatherModel.h"
#import "WeatherModel.h"
#import "LanguageConvertManager.h"
#import "TemperatureModel.h"


@implementation WeatherInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)updateUIWithModel:(ForecastWeatherModel *)model {
    self.timeLabel.text = [self convertTimeStamp:[model.dt integerValue]];
    self.weatherLabel.text = [[LanguageConvertManager sharedManager]getWeatherDescription:(WeatherModel *)([model.weather firstObject])];
    self.tempLabel.text = [NSString stringWithFormat:@"最高温度:%.1f°C   最低温度:%.1f°C", [model.temp.max floatValue], [model.temp.min floatValue]];
}

- (NSString *)convertTimeStamp:(NSUInteger) dt{
    NSDate *now = [NSDate dateWithTimeIntervalSince1970:dt];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateCom= [calendar components:unitFlags fromDate:now];
    long y = [dateCom year];
    long m = [dateCom month];
    long d = [dateCom day];
    return [NSString stringWithFormat:@"%ld年%ld月%ld日", y, m, d];
}

@end

//
//  WeatherInfoView.h
//  WhitePonyWeather
//
//  Created by Vokie on 11/14/15.
//  Copyright © 2015 vokie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ForecastWeatherModel;
@interface WeatherInfoView : UIView
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;

@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

- (void)updateUIWithModel:(ForecastWeatherModel *)model;
@end

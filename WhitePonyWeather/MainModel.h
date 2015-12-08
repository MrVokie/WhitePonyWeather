//
//  MainModel.h
//  WhitePonyWeather
//
//  Created by Vokie on 9/3/15.
//  Copyright (c) 2015 vokie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainModel : NSObject

@property NSString *humidity;      //湿度
@property NSString *pressure;      //大气压强
@property NSString *temp;          //当前温度
@property NSString *temp_max;      //最高温度
@property NSString *temp_min;      //最低温度

@end

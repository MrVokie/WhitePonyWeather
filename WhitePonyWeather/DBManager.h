//
//  DBManager.h
//  WhitePonyWeather
//
//  Created by ci123 on 15/11/17.
//  Copyright © 2015年 vokie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

+ (instancetype)sharedManager;

- (void)initDataBase;

- (void)createTables;

- (void)insertCityName:(NSString *)cityName latitude:(NSString *)lat longtitude:(NSString *)lon;

- (NSMutableArray *)queryWithSQL:(NSString *)string;

@end

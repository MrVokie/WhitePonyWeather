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

- (void)updateWithSQL:(NSString *)string;

- (NSMutableArray *)queryWithSQL:(NSString *)string;

@end

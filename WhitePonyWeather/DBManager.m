//
//  DBManager.m
//  WhitePonyWeather
//
//  Created by ci123 on 15/11/17.
//  Copyright © 2015年 vokie. All rights reserved.
//

#import "DBManager.h"
#import "FMDB.h"

@interface DBManager ()

@property FMDatabase *db;

@end


@implementation DBManager

+ (instancetype)sharedManager {
    static DBManager *dbManager;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        dbManager = [[DBManager alloc] init];
    });
    
    return dbManager;
}

- (void)initDataBase {
    //1.获得数据库文件的路径,若不存在，则创建数据库
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sqliteName=[documentPath stringByAppendingPathComponent:@"location.db"];
    NSLog(@">>> %@", sqliteName);
    self.db = [FMDatabase databaseWithPath:sqliteName];
    if (![self.db open]) {
        NSSLog(@"Could not open db.");
        return ;
    }
    
    [self createTables];
}

- (void)createTables {
    if ([self.db open]) {
        NSArray *array = @[
                           @"CREATE TABLE IF NOT EXISTS location (name text NOT NULL UNIQUE, lat double, lon double);",
                           @"CREATE TABLE IF NOT EXISTS defaultlocation (name text NOT NULL UNIQUE, lat double, lon double);"
                           ];
        
        for (NSString *sqlString in array) {
            BOOL result = [self.db executeUpdate:sqlString];
            if (result) {
                NSSLog(@"创表成功");
            }else{
                NSSLog(@"创表失败");
            }
        }
        
        //插入默认城市的经纬度信息。
        [self insertDefaultCityIntoTable];
    }
}

//查询
- (NSMutableArray *)queryWithSQL:(NSString *)string {
    // 1.执行查询语句
    FMResultSet *resultSet = [self.db executeQuery:string];
    NSMutableArray *mArray = [NSMutableArray array];
    // 2.遍历结果
    while ([resultSet next]) {
        NSString *cityName = [resultSet stringForColumn:@"name"];
        CGFloat lat = [resultSet doubleForColumn:@"lat"];
        CGFloat lon = [resultSet doubleForColumn:@"lon"];
        NSSLog(@"SQL >>>>>   %@  |  %f  |  %f", cityName, lat, lon);
        [mArray addObject:@{@"name":cityName, @"lat":@(lat), @"lon":@(lon)}];
    }
    [resultSet close];
    return mArray;
}


- (void)insertCityName:(NSString *)cityName latitude:(NSString *)lat longtitude:(NSString *)lon {
    [self.db executeUpdate:@"insert into defaultlocation(name, lat, lon) values(?, ?, ?)", cityName, lat, lon];
}

- (void)insertDefaultCityIntoTable {
    NSArray *array = [self queryWithSQL:@"select * from defaultlocation"];
    
    if (!array.count) {
        NSArray *array = @[
                           @[@"北京市",@"39.91", @"116.31"],
                           @[@"上海市",@"31.12", @"121.11"],
                           @[@"合肥市",@"31.52", @"117.17"]
                           ];
        for (NSArray *cityInfo in array) {
            [self insertCityName:cityInfo[0] latitude:cityInfo[1] longtitude:cityInfo[2]];
        }
        
    }
}


@end

//
//  WonderfulActivityViewController.h
//  WhitePonyWeather
//
//  Created by ci123 on 15/9/8.
//  Copyright (c) 2015年 vokie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WonderfulActivityViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property NSArray *cellDataList;

@property (weak, nonatomic) IBOutlet UITableView *activityTableView;

@property NSMutableArray *cellHeightArray;

- (void)downloadAtIndex:(NSInteger)pIndex;
@end

//
//  LeftViewController.h
//  WhitePonyWeather
//
//  Created by ci123 on 15/8/25.
//  Copyright (c) 2015年 vokie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *sideTableView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property NSArray *cellArrayData;

@end

//
//  ChartGraphViewController.h
//  WhitePonyWeather
//
//  Created by ci123 on 15/10/13.
//  Copyright © 2015年 vokie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMSimpleLineGraphView.h"

@interface ChartGraphViewController : UIViewController <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@property (retain, nonatomic) BEMSimpleLineGraphView *myGraph;

@property (strong, nonatomic) NSMutableArray *arrayOfValues;
@property (strong, nonatomic) NSMutableArray *arrayOfDates;

@end

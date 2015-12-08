//
//  TwoCellStyleActivity.h
//  WhitePonyWeather
//
//  Created by ci123 on 15/9/24.
//  Copyright © 2015年 vokie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwoCellStyleActivity : UITableViewCell

@property UILabel *mTitle;
@property UIScrollView *horizonScrollView;

- (void)initWidgetFrameWithCellData:(NSDictionary *)pDict rowIndex:(NSInteger)pIndex;

+ (CGFloat)cellHeightWithDict:(NSDictionary *)pDict;

@end

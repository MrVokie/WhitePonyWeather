//
//  OneCellStyleActivity.h
//  WhitePonyWeather
//
//  Created by ci123 on 15/9/8.
//  Copyright (c) 2015年 vokie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WonderfulActivityViewController;

@interface OneCellStyleActivity : UITableViewCell

@property UIView *bgView;
@property UIImageView *img;
@property UILabel *title;
@property UILabel *content;
@property UIButton *button;

- (void)initWidgetFrameWithCellData:(NSDictionary *)pDict rowIndex:(NSInteger)pIndex;

+ (CGFloat)cellHeightWithDict:(NSDictionary *)pDict;

@property WonderfulActivityViewController *superViewController;

@end

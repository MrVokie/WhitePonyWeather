//
//  TwoCellStyleActivity.m
//  WhitePonyWeather
//
//  Created by ci123 on 15/9/24.
//  Copyright © 2015年 vokie. All rights reserved.
//

#import "TwoCellStyleActivity.h"

#define PADDING 8

#define IMAGEWIDTH APP_SCREEN_WIDTH / 3

@implementation TwoCellStyleActivity


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self createWidgets];
    }
    
    return self;
}

- (void)createWidgets{
    _mTitle = [[UILabel alloc]init];
    _mTitle.font = [UIFont systemFontOfSize:14];
    _mTitle.numberOfLines = 1;
    [self addSubview:_mTitle];
    
    _horizonScrollView = [[UIScrollView alloc]init];
    _horizonScrollView.scrollEnabled = YES;
    _horizonScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_horizonScrollView];
}

//控件大小位置的定义
- (void)initWidgetFrameWithCellData:(NSDictionary *)pDict rowIndex:(NSInteger)pIndex{
    NSArray *imageArray = pDict[@"imageArray"];
    CGFloat startX = 10.0;
    CGFloat imgWidth = APP_SCREEN_WIDTH / 3;
    
    _mTitle.text = pDict[@"title"];

    _mTitle.frame = CGRectMake(startX, 0, APP_SCREEN_WIDTH, 30);
    
    _horizonScrollView.frame = CGRectMake(0, 30,  APP_SCREEN_WIDTH, imgWidth);
    
    for (NSDictionary *imgDict in imageArray) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(startX, 0, imgWidth, imgWidth)];
        [imgView setImage:[UIImage imageNamed:imgDict[@"imgName"]]];
        [imgView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        imgView.contentMode =  UIViewContentModeScaleAspectFill;
        imgView.layer.masksToBounds = YES;
        [_horizonScrollView addSubview:imgView];
        
        startX = startX + imgWidth + PADDING;
    }
    
    _horizonScrollView.contentSize = CGSizeMake(startX, imgWidth);

}

+ (CGFloat)cellHeightWithDict:(NSDictionary *)pDict {
    return 30 + IMAGEWIDTH + 12;
}

@end

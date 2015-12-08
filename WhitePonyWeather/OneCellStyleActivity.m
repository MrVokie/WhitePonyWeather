//
//  OneCellStyleActivity.m
//  WhitePonyWeather
//
//  Created by ci123 on 15/9/8.
//  Copyright (c) 2015年 vokie. All rights reserved.
//

#import "OneCellStyleActivity.h"
#import "WonderfulActivityViewController.h"
#import "NSString+Size.h"

#define TITLE_FONT [UIFont systemFontOfSize:14]

#define CONTENT_FONT [UIFont systemFontOfSize:12]

#define PADDING 5



#define BG_VIEW_START_X 8

#define BG_VIEW_START_Y 8

#define BG_VIEW_WIDTH APP_SCREEN_WIDTH - 16

#define IMAGE_WIDTH (BG_VIEW_WIDTH - 10)

#define IMAGE_HEIGHT IMAGE_WIDTH / 3 * 2

@implementation OneCellStyleActivity

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createWidget];
    }
    
    return self;
}

//创建控件
- (void)createWidget{
    _bgView = [[UIView alloc]init];
    _bgView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    _bgView.frame = CGRectMake(BG_VIEW_START_X, BG_VIEW_START_Y, BG_VIEW_WIDTH, IMAGE_HEIGHT+10);
    [self addSubview:_bgView];
    
    _img = [[UIImageView alloc]init];
    _img.layer.cornerRadius = 3;
    //保持图片不变形
    [_img setContentScaleFactor:[[UIScreen mainScreen] scale]];
    _img.contentMode =  UIViewContentModeScaleAspectFill;
    _img.layer.masksToBounds = YES;
    [self addSubview:_img];
    
    _title = [[UILabel alloc]init];
    _title.numberOfLines = 1;
    _title.font = TITLE_FONT;
    [self addSubview:_title];
    
    _content = [[UILabel alloc]init];
    _content.numberOfLines = 0;
    _content.font = CONTENT_FONT;
    [self addSubview:_content];
    
    _button = [[UIButton alloc]init];
    _button.titleLabel.text = @"下载";
    _button.titleLabel.font = [UIFont systemFontOfSize:14];
    
    _button.backgroundColor = UIColorMake(80, 160, 240, 1);
    _button.layer.cornerRadius = 5;
    _button.layer.masksToBounds = YES;
    [_button setTitle:@"下载" forState:UIControlStateNormal];
    [self addSubview:_button];
}

//控件大小位置的定义
- (void)initWidgetFrameWithCellData:(NSDictionary *)pDict rowIndex:(NSInteger)pIndex{
    _img.frame = CGRectMake(BG_VIEW_START_X + PADDING, BG_VIEW_START_Y + PADDING, IMAGE_WIDTH, IMAGE_HEIGHT);
    [_img setImage:[UIImage imageNamed:pDict[@"image"]]];
    
    CGSize titleSize = [pDict[@"title"] sizeWithAttributes:@{NSFontAttributeName:TITLE_FONT}];
    _title.frame = CGRectMake(CGRectGetMinX(_bgView.frame) + 5, CGRectGetMaxY(_bgView.frame) + 5, titleSize.width, titleSize.height);
    _title.text = pDict[@"title"];
    
    CGFloat contentWidth = _img.frame.size.width / 4.0 * 3.0;
    
    CGSize contentSize = [NSString getMultilineTextLabelHeightWithText:pDict[@"content"] limitWidth:contentWidth font:CONTENT_FONT];
    
    _content.frame = CGRectMake(CGRectGetMinX(_bgView.frame) + 5, CGRectGetMaxY(_title.frame) + 5, contentWidth, contentSize.height);
    _content.text = pDict[@"content"];
    
    CGFloat buttonWidth = _img.frame.size.width / 4.0 - 10;
    _button.frame = CGRectMake(CGRectGetMaxX(_content.frame) + 5, _content.frame.origin.y, buttonWidth, buttonWidth / 2.5);
    _button.tag = pIndex;
    [_button addTarget:self action:@selector(downloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

+ (CGFloat)cellHeightWithDict:(NSDictionary *)pDict {
    
    CGSize titleSize = [pDict[@"title"] sizeWithAttributes:@{NSFontAttributeName:TITLE_FONT}];
    
    CGFloat contentWidth = IMAGE_WIDTH / 4.0 * 3.0;
    
    
    CGSize contentSize = [NSString getMultilineTextLabelHeightWithText:pDict[@"content"] limitWidth:contentWidth font:CONTENT_FONT];
    
    CGFloat buttonWidth = IMAGE_WIDTH / 4.0 - 10;
    CGFloat buttonHeight = buttonWidth / 2.5;
    
    CGFloat maxHeight  = 0.0;
    
    maxHeight = (contentSize.height > buttonHeight) ? contentSize.height : buttonHeight;
    
    return BG_VIEW_START_Y + PADDING + IMAGE_HEIGHT + PADDING + PADDING + titleSize.height + PADDING + maxHeight + PADDING;
}

- (void) downloadButtonClick:(id)pButton{
    UIButton *button = (UIButton *)pButton;
    NSInteger buttonTag = button.tag;   //点击的tableview row数。
    
    [_superViewController downloadAtIndex:buttonTag];
}


@end

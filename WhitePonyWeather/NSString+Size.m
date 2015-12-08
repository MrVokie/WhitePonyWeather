//
//  NSString+Size.m
//  WhitePonyWeather
//
//  Created by ci123 on 15/11/17.
//  Copyright © 2015年 vokie. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

//获取多行文本的高度
+ (CGSize) getMultilineTextLabelHeightWithText:(NSString *)text limitWidth:(CGFloat)width font:(UIFont *)font {
    CGSize textSize = CGSizeMake(width, MAXFLOAT);
    
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    NSDictionary *fontDict = @{NSFontAttributeName:font};
    
    return [text boundingRectWithSize:textSize options:options attributes:fontDict context:nil].size;
}

//单行文本的宽高
+ (CGSize)getSinglelineTextLabelHeightWithText:(NSString *)text font:(UIFont *)font {
    return [text sizeWithAttributes:@{NSFontAttributeName:font}];
}

@end

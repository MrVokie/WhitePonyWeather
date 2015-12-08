//
//  NSString+Size.h
//  WhitePonyWeather
//
//  Created by ci123 on 15/11/17.
//  Copyright © 2015年 vokie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Size)

+ (CGSize) getMultilineTextLabelHeightWithText:(NSString *)text limitWidth:(CGFloat)width font:(UIFont *)font;

+ (CGSize)getSinglelineTextLabelHeightWithText:(NSString *)text font:(UIFont *)font;

@end

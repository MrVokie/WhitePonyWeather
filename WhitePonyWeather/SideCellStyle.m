//
//  sideCellStyle.m
//  WhitePonyWeather
//
//  Created by Vokie on 9/3/15.
//  Copyright (c) 2015 vokie. All rights reserved.
//

#import "SideCellStyle.h"

@implementation SideCellStyle

-(void)awakeFromNib{
    [super awakeFromNib];
    _cLabel.textColor = [[UIColor alloc]initWithRed:253/255.0 green:253/255.0 blue:253/255.0 alpha:1];
}

@end

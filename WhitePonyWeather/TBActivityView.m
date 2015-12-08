#import "TBActivityView.h"

@implementation TBActivityView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultAttribute];
    }
    return self;
}

/**
 *   设置默认属性
 */
-(void)setDefaultAttribute {
    _numberOfRect = 7;
    self.rectBackgroundColor= [UIColor whiteColor];
    _spacing = 2;
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    
    _defaultSize = self.frame.size;
}


-(CAAnimation*)addAnimateWithDelay:(CGFloat)delay {
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = YES;
    animation.autoreverses = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:M_PI];
    animation.duration = _numberOfRect * 0.08; //第一个翻转一周，最后一个开始翻转
    animation.beginTime = CACurrentMediaTime() + delay;
    
    return animation;
}


/**
 *  添加矩形
 */
-(void)addRect {
    [self removeRect];
    [self setHidden:NO];
    CGFloat smallRectWidth = _defaultSize.height / 2.0;
    for (int i = 0; i < _numberOfRect; i++) {
        UIView* rectView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - _numberOfRect*(smallRectWidth + _spacing))/2. + i *(smallRectWidth + _spacing) , 0, smallRectWidth, _defaultSize.height)];
        [rectView setBackgroundColor:_rectBackgroundColor];
        [rectView.layer addAnimation:[self addAnimateWithDelay:i*0.08] forKey:@"TBRotate"];
        [self addSubview:rectView];
    }
}

/**
 *  移除矩形
 */
-(void)removeRect {
    if (self.subviews.count) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [self setHidden:YES];
}



- (void)startAnimate {
    [self addRect];
}


- (void)stopAnimate {
    [self removeRect];
}

@end

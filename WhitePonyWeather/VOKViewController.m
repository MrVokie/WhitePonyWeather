#import "VOKViewController.h"
#import "LeftViewController.h"

#define VK_SLIDE_DISTANCE  200

@interface VOKViewController() <UIGestureRecognizerDelegate> {
    
}

@end

@implementation VOKViewController

+ (VOKViewController *)sharedVKViewController {
    static VOKViewController *sharedVKViewController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedVKViewController = [[self alloc] init];
    });
    
    return sharedVKViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _moveDuration = 0.3;
        _isOpen = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UIView *view_ in self.view.subviews) {
        if ([view_ isKindOfClass:[UITabBar class]]) {
            [view_ removeFromSuperview];
        }else{
            _transitionView = view_;
            _transitionView.frame = self.view.bounds;
        }
    }
    
    //添加点击事件
    _tapGestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    _tapGestureRec.delegate = self;
    [_transitionView addGestureRecognizer:_tapGestureRec];
    _tapGestureRec.enabled = NO;
    
    //增加拖动事件
    _panGestureRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureMainView:)];
    _panGestureRec.delegate = self;
    [_transitionView addGestureRecognizer:_panGestureRec];
}

-(void)viewDidLayoutSubviews{
    if (_isOpen) {
        CGFloat siderWidth = _sideBarWidth == 0 ? (self.view.frame.size.width * 3 / 4) : _sideBarWidth;
        CGFloat x = _transitionView.frame.size.width / 2 + siderWidth;
        _transitionView.frame = CGRectMake(siderWidth, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT);   CGPointMake(x, _transitionView.center.y);
    }else{
        _transitionView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT);
    }
}


- (void)setLeftView:(UIView *)leftView {
    if (_leftView) {
        [_leftView removeFromSuperview];
        _leftView = nil;
    }
    _leftView = leftView;
    
    _leftView.frame = self.view.bounds;
    [self.view insertSubview:_leftView atIndex:0];
}

//设置显示的侧边阴影
- (void)setShowsShadow:(BOOL)showsShadow {
    _showsShadow = showsShadow;
    
    if(_showsShadow){
        _transitionView.layer.masksToBounds = NO;
        _transitionView.layer.shadowRadius = 10;
        _transitionView.layer.shadowOpacity = 0.9;
        _transitionView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:_transitionView.bounds] CGPath];
    }
    else {
        _transitionView.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectNull].CGPath;
    }
}

//显示左菜单
- (void)showLeftView:(BOOL)animated {
    [UIView setAnimationsEnabled:YES];
    //判断是否有左菜单，没有就不显示，
    if (_leftView == nil) {
        return;
    }
    
    //设定tabview的侧滑距离。默认是3/4的屏幕宽度
    CGFloat siderWidth = _sideBarWidth == 0 ? (self.view.frame.size.width * 3 / 4) : _sideBarWidth;

    if (animated) {
        [UIView animateWithDuration:_moveDuration animations:^{
                             //tabview侧滑动，到新的x位置。
                             _transitionView.frame = CGRectMake(siderWidth, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT);
                         } completion:^(BOOL finished) {
                             //侧滑完成，显示侧边栏
                             //打开tap事件
                             _tapGestureRec.enabled = YES;
                             //关闭侧拉栏里面的监听事件
                             ((UIView *)_transitionView.subviews[0]).userInteractionEnabled = NO;
                         }];
    }else{
        _transitionView.frame = CGRectMake(siderWidth, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT);
        _tapGestureRec.enabled = YES;
    }
    //打开侧边栏的标志位
    _isOpen = YES;
}

//显示主视图，关闭侧拉栏
- (void)closeSideBar:(BOOL)animated {
    [UIView setAnimationsEnabled:YES];
    if (animated) {
        [UIView animateWithDuration:_moveDuration
                         animations:^{
                             _transitionView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT);
                         }
                         completion:^(BOOL finished) {
                             //关闭点击事件
                             _tapGestureRec.enabled = NO;
                             ((UIView *)_transitionView.subviews[0]).userInteractionEnabled = YES;
                         }];
    }else{
        _transitionView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT);
        _tapGestureRec.enabled = NO;
    }
    _isOpen = NO;
}


//当点击已经打开的侧拉栏时，关闭侧拉栏
- (void)tapGesture {
    [self closeSideBar:YES];
}

//手势拖动监听接口
- (void)panGestureMainView:(UIPanGestureRecognizer *)panGesture {
    CGPoint translation = [panGesture translationInView:self.view];
    
    static CGFloat viewBegCenterX;
    static CGFloat viewX;
    
    if (panGesture.state == UIGestureRecognizerStateBegan){ //开始拖动
        viewBegCenterX = _transitionView.center.x;
        viewX = _transitionView.frame.origin.x;
        
    }else if (panGesture.state == UIGestureRecognizerStateChanged){//正在拖动
        CGFloat moveDistance = translation.x + viewBegCenterX;
        if (translation.x > 0){ //向右拖动
            
            if (_leftView == nil && _transitionView.frame.origin.x >= 0) {
                return;
            }
            
            _transitionView.center = CGPointMake(moveDistance, _transitionView.center.y);
        }else if(translation.x < 0){ //向左拖动
            if (_leftView == nil && _transitionView.frame.origin.x >= 0) {
                return;
            }
            
            if (moveDistance <= APP_SCREEN_WIDTH/2.0) {  //禁止向左侧滑动，将主viewcontroller划出屏幕
                return;
            }
            
            _transitionView.center = CGPointMake(moveDistance, _transitionView.center.y);
        }
    }else if (panGesture.state == UIGestureRecognizerStateEnded){ //结束拖动
        CGFloat siderWidth = _sideBarWidth == 0 ? (self.view.frame.size.width * 3 / 4) : _sideBarWidth;
        
        CGPoint velocity = [panGesture velocityInView:_transitionView];
        
        if (velocity.x > VK_SLIDE_DISTANCE && viewX == 0) {
            [self showLeftView:YES];
        }else if (velocity.x > VK_SLIDE_DISTANCE && viewX < 0){
            [self closeSideBar:YES];
        }else if (velocity.x < -VK_SLIDE_DISTANCE && viewX > 0){
            [self closeSideBar:YES];
        }else if (_transitionView.frame.origin.x > siderWidth / 2 && viewX == 0) {
            [self showLeftView:YES];
        }else {
            [self closeSideBar:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

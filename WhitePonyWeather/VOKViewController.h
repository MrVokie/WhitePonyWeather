#import <UIKit/UIKit.h>

@class LeftViewController;

@interface VOKViewController : UITabBarController{
    
    
}

@property (nonatomic, strong) UIView *transitionView;
@property (nonatomic, strong) UIView *leftView;
@property (retain, nonatomic) LeftViewController* leftViewController;

@property (nonatomic, assign) CGFloat sideBarWidth;
@property (nonatomic, assign) CGFloat moveDuration;

@property BOOL isOpen;

@property (nonatomic, assign) BOOL showsShadow;

@property UITapGestureRecognizer *tapGestureRec;

@property UIPanGestureRecognizer *panGestureRec;

//创健单行实例
+ (VOKViewController *)sharedVKViewController;

- (void)panGestureMainView:(UIPanGestureRecognizer *)panGesture;

//显示左边菜单
- (void)showLeftView:(BOOL)animated;

//隐藏菜单栏，显示主视图
- (void)closeSideBar:(BOOL)animated;

//设置显示的侧边阴影
- (void)setShowsShadow:(BOOL)showsShadow;





@end

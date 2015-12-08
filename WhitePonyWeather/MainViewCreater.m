#import "MainViewCreater.h"
#import "VOKViewController.h"
#import "ViewController.h"
#import "LeftViewController.h"

@implementation MainViewCreater

- (UIViewController *)createMainView {
    VOKViewController *vkViewController = [VOKViewController sharedVKViewController];
    
    ViewController *mainViewController = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mainViewController];
    
    NSArray *array = @[nav];
    vkViewController.viewControllers = array;
    
    self.leftViewController = [[LeftViewController alloc] init];
    vkViewController.leftViewController = self.leftViewController;
    vkViewController.leftView = self.leftViewController.view;
    
    //显示边界阴影
    [vkViewController setShowsShadow:YES];
    return vkViewController;
}
@end

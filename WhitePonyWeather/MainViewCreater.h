#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class LeftViewController;

@interface MainViewCreater : NSObject {

}

@property(retain,nonatomic) LeftViewController *leftViewController;

- (UIViewController *)createMainView;

@end

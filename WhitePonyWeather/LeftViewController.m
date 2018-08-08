//
//  LeftViewController.m
//  WhitePonyWeather
//
//  Created by ci123 on 15/8/25.
//  Copyright (c) 2015年 vokie. All rights reserved.
//

#import "LeftViewController.h"
#import "SideCellStyle.h"
#import "WonderfulActivityViewController.h"
#import "VOKViewController.h"
#import "ChartGraphViewController.h"
#import "LocationViewController.h"
#import "SocialViewController.h"
#import "UserSettingsViewController.h"
#import "ThemeViewController.h"

@interface LeftViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *leftBgImageView;

@end

@implementation LeftViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    NSString *left = [[NSUserDefaults standardUserDefaults]objectForKey:@"main_left"];
    if (left.length == 0) {
        left = @"cloud_bg_left";
    }
    
    [self.leftBgImageView setImage:[UIImage imageNamed:left]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sideTableView.delegate = self;
    _sideTableView.dataSource = self;
    
    //删除多余分割线
    _sideTableView.tableFooterView = [[UIView alloc]init];
    
    //tableview 半透明
    _sideTableView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    
    _userImageView.layer.cornerRadius = 40;
    _userImageView.layer.masksToBounds = YES;
    
    _cellArrayData = @[
                       @{@"image":@"location_icon",@"text":@"地点管理"},
                       @{@"image":@"chart_icon",@"text":@"天气趋势"},
                       @{@"image":@"share_icon",@"text":@"分享天气"},
                       @{@"image":@"theme_icon",@"text":@"主题定制"},
                       @{@"image":@"activity_icon",@"text":@"精彩推荐"},
                       @{@"image":@"feedback_icon",@"text":@"反馈建议"},
                       @{@"image":@"settings_icon",@"text":@"系统设置"}
                       ];
    
    _sideTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SideCellStyle";
    
    SideCellStyle *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nibArr = [[NSBundle mainBundle]loadNibNamed:cellIdentifier owner:self options:nil];
        cell = (SideCellStyle *)[nibArr objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.cImage setImage:[UIImage imageNamed:[_cellArrayData objectAtIndex:indexPath.row][@"image"]]];
    cell.cLabel.text = [_cellArrayData objectAtIndex:indexPath.row][@"text"];
    //cell 背景层透明
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _cellArrayData.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:         //地点管理
            dispatch_async(dispatch_get_main_queue(), ^{
                LocationViewController *lvc = [[LocationViewController alloc]init];
                UINavigationController *nav_location = [[UINavigationController alloc]initWithRootViewController:lvc];
                [[VOKViewController sharedVKViewController]presentViewController:nav_location animated:YES completion:nil];
            });
            break;
        case 1:{         //图标趋势
            dispatch_async(dispatch_get_main_queue(), ^{
                ChartGraphViewController *cgvc = [[ChartGraphViewController alloc]init];
                UINavigationController *nav_graph = [[UINavigationController alloc]initWithRootViewController:cgvc];
                [[VOKViewController sharedVKViewController]presentViewController:nav_graph animated:YES completion:nil];
            });
            
            
            break;
        }case 2:         //分享天气
            dispatch_async(dispatch_get_main_queue(), ^{
                SocialViewController *svc = [[SocialViewController alloc] init];
                UINavigationController *nav_social = [[UINavigationController alloc]initWithRootViewController:svc];
                [[VOKViewController sharedVKViewController]presentViewController:nav_social animated:YES completion:nil];
            });

            break;
        case 3:{         //主题定制
            dispatch_async(dispatch_get_main_queue(), ^{
                ThemeViewController *tvc = [[ThemeViewController alloc] init];
                UINavigationController *nav_theme = [[UINavigationController alloc]initWithRootViewController:tvc];
                [[VOKViewController sharedVKViewController]presentViewController:nav_theme animated:YES completion:nil];
            });
            
            
            break;
        }case 4:{         //精彩活动
            dispatch_async(dispatch_get_main_queue(), ^{
                WonderfulActivityViewController *wavc = [[WonderfulActivityViewController alloc] init];
                UINavigationController *nav_activity = [[UINavigationController alloc]initWithRootViewController:wavc];
                [[VOKViewController sharedVKViewController]presentViewController:nav_activity animated:YES completion:nil];
            });
            
            break;
        }case 5:{         //反馈
            NSLog(@"Feedback event");
            break;
        }case 6:{         //设置
            dispatch_async(dispatch_get_main_queue(), ^{
                UserSettingsViewController *usvc = [[UserSettingsViewController alloc] init];
                UINavigationController *nav_setting = [[UINavigationController alloc]initWithRootViewController:usvc];
                [[VOKViewController sharedVKViewController]presentViewController:nav_setting animated:YES completion:^{
                    
                }];
            });
            break;
        }default:
            break;
    }
}
- (IBAction)userIconTap:(id)sender {
    NSLog(@"UserIcon tap");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

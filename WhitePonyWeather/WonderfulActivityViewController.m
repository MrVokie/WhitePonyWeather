//
//  WonderfulActivityViewController.m
//  WhitePonyWeather
//
//  Created by ci123 on 15/9/8.
//  Copyright (c) 2015年 vokie. All rights reserved.
//

#import "WonderfulActivityViewController.h"
#import "OneCellStyleActivity.h"
#import "TwoCellStyleActivity.h"

@interface WonderfulActivityViewController ()

@end

@implementation WonderfulActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"精彩活动";
    //状态栏字体白色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [self initBackButton];

    [self loadPlistDataToArray];

    [self loadCellHeightToArray];
    _activityTableView.delegate = self;
    _activityTableView.dataSource = self;
    _activityTableView.tableFooterView = [[UIView alloc]init];
}

- (void)initBackButton{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 20 , 44, 44)];
    button.showsTouchWhenHighlighted = YES;
    button.backgroundColor = [UIColor clearColor];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
    [button setImage:[UIImage imageNamed:@"back_button_image"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backPage:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)backPage:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadCellHeightToArray{
    _cellHeightArray = [NSMutableArray arrayWithCapacity:10];
    
    for (NSDictionary *data in _cellDataList) {
        if ([data[@"type"] isEqualToString:@"2"]) {
            [_cellHeightArray addObject:@([OneCellStyleActivity cellHeightWithDict:data])];
        }else{
            [_cellHeightArray addObject:@([TwoCellStyleActivity cellHeightWithDict:data])];
        }
    }
}

//加载本地数据到数组中
- (void)loadPlistDataToArray{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"ActivityList" ofType:@"plist"];
    _cellDataList=[NSArray arrayWithContentsOfFile:path];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_cellDataList[indexPath.row][@"type"] isEqualToString:@"1"]) {
        static NSString *cellIdentifier = @"TwoCellStyleActivity";
        
        TwoCellStyleActivity *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[TwoCellStyleActivity alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//            cell.superViewController = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [cell initWidgetFrameWithCellData:_cellDataList[indexPath.row] rowIndex:indexPath.row];
        return cell;
    }else{
        static NSString *cellIdentifier = @"OneCellStyleActivity";
        
        OneCellStyleActivity *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[OneCellStyleActivity alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.superViewController = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [cell initWidgetFrameWithCellData:_cellDataList[indexPath.row] rowIndex:indexPath.row];
        return cell;
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _cellDataList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [_cellHeightArray[indexPath.row]floatValue];


}

- (void)downloadAtIndex:(NSInteger)pIndex{
    NSSLog(@">>>>Start>>>> %ld",pIndex);
}

@end

//
//  LocationViewController.m
//  WhitePonyWeather
//
//  Created by Vokie on 11/17/15.
//  Copyright © 2015 vokie. All rights reserved.
//

#import "LocationViewController.h"
#import "DBManager.h"
#import "VOKViewController.h"

@interface LocationViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *locationTableView;
@property (retain, nonatomic) NSMutableArray *cityArray;
@property (retain, nonatomic) NSArray *cityDesc;
@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"地点管理";
    //状态栏字体白色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self initNavButton];
    
    _cityDesc = @[@"全国热门城市", @"您关注的地区"];
    //加载城市地址数据
    [self loadCityDataFromSQLite];
    
    //设置tableview
    _locationTableView.delegate = self;
    _locationTableView.dataSource = self;
    _locationTableView.tableFooterView = [[UIView alloc]init];
}

- (void)initNavButton{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 20 , 44, 44)];
    button.showsTouchWhenHighlighted = YES;
    button.backgroundColor = [UIColor clearColor];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
    [button setImage:[UIImage imageNamed:@"back_button_image"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backPage:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)loadCityDataFromSQLite {
    _cityArray = [NSMutableArray arrayWithCapacity:2];
    
    NSArray *defaultCityArray = [[DBManager sharedManager]queryWithSQL:@"select * from defaultlocation"];
    
    NSArray *myCityArray = [[DBManager sharedManager]queryWithSQL:@"select * from location"];
    
    
    [_cityArray addObject:defaultCityArray];
    [_cityArray addObject:myCityArray];

}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_cityArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CELL_SYSTEM";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = _cityArray[indexPath.section][indexPath.row][@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *cityDict = _cityArray[indexPath.section][indexPath.row];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[VOKViewController sharedVKViewController]closeSideBar:YES];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Choose_New_City" object:nil userInfo:@{@"city_info":cityDict}];
    }];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _cityArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _cityDesc[section];

}

- (void)backPage:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

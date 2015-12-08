//
//  ThemeViewController.m
//  WhitePonyWeather
//
//  Created by ci123 on 15/11/25.
//  Copyright © 2015年 vokie. All rights reserved.
//

#import "ThemeViewController.h"
#import "ThemeCell.h"

static NSString *cellIdentifier = @"Theme_Cell";

@interface ThemeViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *themeCollectionView;

@property (nonatomic, copy) NSArray *dataArray;
@end

@implementation ThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.title = @"主题选择";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavButton];
    
    _dataArray = @[@{@"icon":@"cloud_bg", @"name":@"系统主题", @"left_bg":@"cloud_bg_left"},
                   @{@"icon":@"theme_nature_bg", @"name":@"纯净自然", @"left_bg":@"theme_nature_left"},
                   @{@"icon":@"theme_desert", @"name":@"沙漠孤寂", @"left_bg":@"theme_desert_left"},
                   @{@"icon":@"theme_star", @"name":@"浩瀚繁星", @"left_bg":@"theme_star_left"}
                   ];
    
    //注册Cell，必须要有
//    [_themeCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    UINib *nib = [UINib nibWithNibName:@"ThemeCell" bundle:nil];
    [_themeCollectionView registerNib:nib forCellWithReuseIdentifier:cellIdentifier];
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

- (void)backPage:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - UICollectionView DataSource Delegate

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ThemeCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell.imageIcon setImage:[UIImage imageNamed:_dataArray[indexPath.item][@"icon"]]];
    cell.labelIcon.text = _dataArray[indexPath.item][@"name"];
    return cell;
}


#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 140);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //临时改变个颜色，看好，只是临时改变的。如果要永久改变，可以先改数据源，然后在cellForItemAtIndexPath中控制。（和UITableView差不多吧！O(∩_∩)O~）
    cell.backgroundColor = [UIColor greenColor];
    NSLog(@"item======%ld",indexPath.item);
    NSLog(@"row=======%ld",indexPath.row);
    NSLog(@"section===%ld",indexPath.section);
    
    [[NSUserDefaults standardUserDefaults]setObject:_dataArray[indexPath.item][@"icon"] forKey:@"main_bg"];
    [[NSUserDefaults standardUserDefaults]setObject:_dataArray[indexPath.item][@"left_bg"] forKey:@"main_left"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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

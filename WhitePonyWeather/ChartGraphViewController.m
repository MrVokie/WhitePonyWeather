//
//  ChartGraphViewController.m
//  WhitePonyWeather
//
//  Created by ci123 on 15/10/13.
//  Copyright © 2015年 vokie. All rights reserved.
//

#import "ChartGraphViewController.h"
#import "UserInfo.h"
#import "ForecastWeatherModel.h"
#import "TemperatureModel.h"

#import "WeatherInfoView.h"

@interface ChartGraphViewController () {
    NSInteger totalNumber;
}

@property (retain, nonatomic)NSMutableArray *dayArray;

@property (retain, nonatomic)WeatherInfoView *wiView;
@end

@implementation ChartGraphViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"平均温度趋势图";
    self.view.backgroundColor = [UIColor colorWithRed:0 green:118/255.0 blue:1.0 alpha:1.0];
    //状态栏字体白色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self initBackButton];

    
    //创建天气描述view
    _wiView = [[[NSBundle mainBundle] loadNibNamed:@"WeatherInfoView" owner:self options:nil]firstObject];
    [self.view addSubview:_wiView];
    
    //创建表格
     self.myGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH - 10, (APP_SCREEN_HEIGHT - 40) / 2.0)];
    
    CGFloat maxY = CGRectGetMaxY(self.myGraph.frame) + 20;
    _wiView.frame = CGRectMake(5, maxY, APP_SCREEN_WIDTH - 10, APP_SCREEN_HEIGHT - maxY - 5);
    
     self.myGraph.delegate = self;
     self.myGraph.dataSource = self;
     [self.view addSubview:self.myGraph];
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 0.0
    };
    
    // 配置x轴的数据展示
    self.myGraph.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    
    //设置图表的属性
    self.myGraph.enableTouchReport = YES;
    self.myGraph.enablePopUpReport = YES;
    
    self.myGraph.autoScaleYAxis = YES;
    self.myGraph.alwaysDisplayDots = NO;
    self.myGraph.enableReferenceXAxisLines = YES;
    self.myGraph.enableReferenceYAxisLines = YES;
    self.myGraph.enableReferenceAxisFrame = YES;
    
//    显示X,Y轴的刻度标签
    self.myGraph.enableXAxisLabel = YES;
    self.myGraph.enableYAxisLabel = YES;
    //设置标签的颜色
    self.myGraph.colorXaxisLabel = [UIColor whiteColor];
    self.myGraph.colorYaxisLabel = [UIColor whiteColor];
    
    //开启曲线
    self.myGraph.enableBezierCurve = YES;
    
    // 绘制平均线
    self.myGraph.averageLine.enableAverageLine = YES;
    self.myGraph.averageLine.alpha = 0.6;
    self.myGraph.averageLine.color = [UIColor yellowColor];
    self.myGraph.averageLine.width = 2;
    self.myGraph.averageLine.dashPattern = @[@(10),@(10)];
    
    
    //设置图表绘制的动画效果
    self.myGraph.animationGraphStyle = BEMLineAnimationDraw;
    
    // Y轴参考线
    self.myGraph.lineDashPatternForReferenceYAxisLines = @[@(5),@(5)];
    
    // 格式化显示Y轴的数据
    self.myGraph.formatStringForValues = @"%.1f°C";
    
    self.dayArray = [NSMutableArray arrayWithCapacity:7];
    
    [self requestForecastWeather];
}

//请求服务器获取指定坐标的天气
- (void)requestForecastWeather{
    NSNumber *latitude = [UserInfo sharedUserInfo].lat;
    NSNumber *longitude = [UserInfo sharedUserInfo].lon;
    NSString *mUrl = [NSString stringWithFormat:@"%@forecast/daily?lat=%@&lon=%@&units=metric&appid=%@&cnt=16",REQUEST_URL_HEAD, latitude, longitude, WEATHER_API_KEY];
    
    NSSLog(@"当前天气情况请求地址：%@", mUrl);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:mUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = responseObject;
        
        NSSLog(@"天气数据请求成功：%@",dict);
        
        [ForecastWeatherModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"weather":@"WeatherModel"
                     };
        }];
        
        for (NSDictionary *dayDict in dict[@"list"]) {
            ForecastWeatherModel *cwModel = [ForecastWeatherModel mj_objectWithKeyValues:dayDict];
            [self.dayArray addObject:cwModel];
        }
        //将天气数据刷新到界面上
        [self refreshUIWithModel];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSSLog(@"Error: %@", error);
    }];
}

- (void)refreshUIWithModel {
    // 重置数组(Y数组的值Value，X数组的日期)
    if (!self.arrayOfValues)
        self.arrayOfValues = [[NSMutableArray alloc] init];
    
    if (!self.arrayOfDates)
        self.arrayOfDates = [[NSMutableArray alloc] init];
    
    [self.arrayOfValues removeAllObjects];
    [self.arrayOfDates removeAllObjects];
    
    
    totalNumber = 0;
    for (ForecastWeatherModel *model in self.dayArray) {
        NSDate *baseDate = [NSDate dateWithTimeIntervalSince1970:[model.dt doubleValue]];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate:baseDate];
        NSDate *localeDate = [baseDate dateByAddingTimeInterval:interval];
        
        CGFloat value = ([model.temp.max floatValue] + [model.temp.min floatValue]) / 2.0;
        [self.arrayOfValues addObject:@(value)];
        [self.arrayOfDates addObject:localeDate];
        
        totalNumber = totalNumber + value; //天气温度总值
    }
    [self.myGraph reloadGraph];
    
    [self updateWeatherInfoViewWithModel:[self.dayArray firstObject]];
}

- (void)updateWeatherInfoViewWithModel:(ForecastWeatherModel *)model {
    [_wiView updateUIWithModel:model];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)labelForDateAtIndex:(NSInteger)index {
    NSDate *date = self.arrayOfDates[index];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM月dd号";
    NSString *label = [df stringFromDate:date];
    return label;
}


#pragma mark - SimpleLineGraph Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return (int)[self.arrayOfValues count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[self.arrayOfValues objectAtIndex:index] doubleValue];
}

#pragma mark - SimpleLineGraph Delegate

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 2;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    NSString *label = [self labelForDateAtIndex:index];
    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
    ForecastWeatherModel *fwModel = (ForecastWeatherModel *)(self.dayArray[index]);
    
    [self updateWeatherInfoViewWithModel:fwModel];
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {
}

- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph {
//    NSSLog(@">>%@", [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSum] intValue]]);
//    self.labelDates.text = [NSString stringWithFormat:@"between %@ and %@", [self labelForDateAtIndex:0], [self labelForDateAtIndex:self.arrayOfDates.count - 1]];
}

- (NSString *)noDataLabelTextForLineGraph:(BEMSimpleLineGraphView *)graph{
    return @"正在获取服务器最新数据哦...";
}

//- (NSString *)popUpSuffixForlineGraph:(BEMSimpleLineGraphView *)graph {
//    return @"*";
//}

//- (NSString *)popUpPrefixForlineGraph:(BEMSimpleLineGraphView *)graph {
//    return [NSString stringWithFormat:@"# "];
//}

@end

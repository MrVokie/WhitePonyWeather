//
//  ViewController.m
//  WhitePonyWeather
//
//  Created by Vokie on 8/24/15.
//  Copyright (c) 2015 vokie. All rights reserved.
//

#import "ViewController.h"
#import "VOKViewController.h"
#import "CurrentWeatherModelOne.h"
#import "WeatherModel.h"
#import "LanguageConvertManager.h"
#import "UserInfo.h"                    
#import "TBActivityView.h"
#import "DBManager.h"

@interface ViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *mainBgImageView;
@property (nonatomic)  TBActivityView *indicatorView;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *bg = [[NSUserDefaults standardUserDefaults]objectForKey:@"main_bg"];
    
    if (bg.length == 0) {
        bg = @"cloud_bg";
    }
    [self.mainBgImageView setImage:[UIImage imageNamed:bg]];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    //初始化GPS定位服务
    [self initGPSComponent];
    
    //添加通知监听器
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chooseNewCity:) name:@"Choose_New_City" object:nil];
}

- (void)chooseNewCity:(id)sender {
    NSDictionary *userInfo = [sender userInfo];
    NSDictionary *cityDict = userInfo[@"city_info"];
    
    NSString *cityName = cityDict[@"name"];
    CGFloat lat = [cityDict[@"lat"] floatValue];
    CGFloat lon = [cityDict[@"lon"] floatValue];
    
    self.title = cityName;
    
    [self saveAddressInfoWithName:cityName latitude:lat longtitude:lon];
    
    //获取指定坐标点的天气情况
    [self requestWeatherByLongitude:@(lon) Latitude:@(lat)];
    
    //更新全局内存值，此处代码可以封装。
    [UserInfo sharedUserInfo].lat = @(lat);
    [UserInfo sharedUserInfo].lon = @(lon);
}

- (void)initUI{
    //透明Nav
    self.navigationItem.title = @"";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    self.view.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    
    //状态栏字体白色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    //自定义左侧按钮
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"menubar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(showLeftView)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //右侧刷新按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshLocationAndWeather)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //定义title（地点）
    self.title = @"正在定位...";
    
    
}

- (void)refreshLocationAndWeather {
    //获取当前用户选择城市的天气情况
    [self requestWeatherByLongitude:@([[UserInfo sharedUserInfo].lon floatValue]) Latitude:@([[UserInfo sharedUserInfo].lat floatValue])];
}

- (void)initGPSComponent{
    NSSLog(@"初始化GPS定位");
    [self showWaitIndicator];
    //-----------------定位------------------
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    
    _geocoder=[[CLGeocoder alloc]init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        //NSSLog(@"定位服务当前可能尚未打开，请设置打开！");
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请先开启定位功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return;
    }
}

- (void)configLocationManager {
    //设置定位精度
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //定位频率,每隔多少米定位一次
    CLLocationDistance distance = 10.0;//十米定位一次
    _locationManager.distanceFilter = distance;
}

//设置代理后(启动时)调用，定位权限改变时调用
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSSLog(@">>auth status:%d",status);
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            //用户没有同意，需要请求定位
            if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [_locationManager requestWhenInUseAuthorization];
            }
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse: {
            //用户同意定位。开始定位
            
            [self configLocationManager];
            //启动跟踪定位
            [_locationManager startUpdatingLocation];
            break;
        }
            
        default:
            break;
    }
}

// 根据手机定位，获取用户的坐标，并根据坐标位置、请求该位置的天气信息
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [self showWaitIndicator];
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    NSSLog(@"定位成功! >>> 经度：%f,纬度：%f",coordinate.longitude,coordinate.latitude);
    
    //关闭定位服务
    [_locationManager stopUpdatingLocation];
//    self.title = @"定位成功";
    
    //获取指定坐标地方的中文名
    [self getAddressByLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    [UserInfo sharedUserInfo].lat = @(coordinate.latitude);
    [UserInfo sharedUserInfo].lon = @(coordinate.longitude);
}

//请求服务器获取指定坐标的天气
- (void)requestWeatherByLongitude:(NSNumber *)longitude Latitude:(NSNumber *)latitude{
    [self showWaitIndicator];
    
    NSString *mUrl = [NSString stringWithFormat:@"%@weather?lat=%@&lon=%@&units=metric&appid=%@",REQUEST_URL_HEAD, latitude, longitude, WEATHER_API_KEY];
    
    NSSLog(@"当前天气情况请求地址：%@", mUrl);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:mUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = responseObject;
        
        NSSLog(@"天气数据请求成功：%@",dict);
        if ([dict[@"cod"] integerValue] == 404) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前城市的气象数据异常\n点击确定重试" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 1001;
            [alert show];
        }else {
            [CurrentWeatherModelOne mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"weather":@"WeatherModel"
                         };
            }];
            
            CurrentWeatherModelOne *cwModel = [CurrentWeatherModelOne mj_objectWithKeyValues:dict];
            
            //根据地名、取得城市坐标
//            [self getCoordinateByAddress:cwModel.name];  //存在重名问题
            
            //将天气数据刷新到界面上
            [self refreshUIWithModel:cwModel];
        }
        [self removeWaitIndicator];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSSLog(@"Error: %@", error);
        [self removeWaitIndicator];
    }];
}



// 根据地名计算地理坐标、以及中文名称、国家等
-(void)getCoordinateByAddress:(NSString *)address{
    //地理编码
    [_geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
        CLPlacemark *placemark=[placemarks firstObject];
        CLLocation *location=placemark.location;//位置
        CLRegion *region=placemark.region;//区域
        NSDictionary *addressDic= placemark.addressDictionary;
        NSSLog(@"\n>>>>>>>地名取坐标位置:\n\nlocation:%@\n\n区域:%@\n\n国家：%@\n\n称呼：%@\n\n省份：%@\n\n城市：%@\n\n", location,region,addressDic[@"Country"], addressDic[@"Name"],addressDic[@"State"],addressDic[@"City"]);
    }];
}

-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    [self showWaitIndicator];
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            
            NSString *address = [[NSUserDefaults standardUserDefaults] objectForKey:@"address"];
            if (address != nil && address.length > 0) {
                //使用上一次获取到的地理位置信息。
                self.title = address;
                
                CLLocationDegrees lat = [[NSUserDefaults standardUserDefaults] doubleForKey:@"lat"];
                CLLocationDegrees lon = [[NSUserDefaults standardUserDefaults] doubleForKey:@"lon"];
                //获取指定坐标点的天气情况
                [self requestWeatherByLongitude:@(lon) Latitude:@(lat)];
            }else{
                self.title = @"未知城市";
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"根据您的地理位置获取城市名称失败\n点击确定重试" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 1000;
                [alert show];
                
                NSSLog(@"error.code：%ld", error.code);
                NSSLog(@"error.localizedDescription：%@", error.localizedDescription);
                [self removeWaitIndicator];
            }
        }else{
            CLPlacemark *placemark=[placemarks firstObject];
            NSDictionary *infoDict = placemark.addressDictionary;
            NSString *addressName = nil;
            if (infoDict[@"City"] != nil) {
                addressName = [infoDict[@"City"]stringByAppendingString:infoDict[@"SubLocality"]];
                self.title = addressName;
            }else{
                addressName = infoDict[@"SubLocality"];
                self.title = addressName;
            }

            [self saveAddressInfoWithName:addressName latitude:latitude longtitude:longitude];
            
            //获取指定坐标点的天气情况
            [self requestWeatherByLongitude:@(longitude) Latitude:@(latitude)];
            
            NSSLog(@"坐标取地名详细信息:%@", infoDict);
        }
    }];
}

//存储上一次的地址信息
- (void)saveAddressInfoWithName:(NSString *)addressName latitude:(CLLocationDegrees)latitude longtitude:(CLLocationDegrees)longitude {
    [[NSUserDefaults standardUserDefaults] setObject:addressName forKey:@"address"];
    [[NSUserDefaults standardUserDefaults] setDouble:latitude forKey:@"lat"];
    [[NSUserDefaults standardUserDefaults] setDouble:longitude forKey:@"lon"];
    
    //保存到数据库
    [[DBManager sharedManager]insertCityName:addressName latitude:Double2String(latitude) longtitude:Double2String(longitude)];
}

- (void)showLeftView{
    [[VOKViewController sharedVKViewController]showLeftView:YES];
}

- (void)refreshUIWithModel:(CurrentWeatherModelOne *)model{
    _curTempLabel.text = [self getCurrentTemp:model.main.temp];
    WeatherModel *weatherModel = (WeatherModel *)[model.weather firstObject];
    NSString *cnDesc = [[LanguageConvertManager sharedManager] getWeatherDescription:weatherModel];
    NSInteger minT = [model.main.temp_min floatValue] - 2.5;
    NSInteger maxT = [model.main.temp_max floatValue] + 2.5;
    NSString *tempRange = [NSString stringWithFormat:@" %ld°~%ld°",(long)minT, (long)maxT];
    _descLabel.text =[cnDesc stringByAppendingString:tempRange];
    
    //能见度
    CGFloat viMile = [model.visibility integerValue] / 1000.0;
    viMile = viMile == 0 ? 4.0:viMile;  //默认是4公里的能见度
    _visibilityDistLabel.text = [NSString stringWithFormat:@"能见度%.1f公里",viMile];
    
    //更新时间
    _updateTimeLabel.text = [self convertTimeWithTimeStamp:model.dt withFormatter:@"更新时间:YYYY/MM/dd HH:mm"];
    
    //湿度、大气压
    _humidAtmosLabel.text = [[LanguageConvertManager sharedManager] getFormatWithHumid:model.main.humidity Pressure:model.main.pressure];
    
    //日出日落时间
    NSString *sunRise = [self convertTimeWithTimeStamp:model.sys.sunrise withFormatter:@"日出HH:mm "];
    NSString *sunSet = [self convertTimeWithTimeStamp:model.sys.sunset withFormatter:@" 日落HH:mm "];
    _sunRiseSetLabel.text = [sunRise stringByAppendingString:sunSet];
    
    //风速云朵比例
    NSString *windLevel = [[[LanguageConvertManager sharedManager]getWindLevel:model.wind.speed]stringByAppendingString:@"  "];

    NSString *cloudLevel = [[LanguageConvertManager sharedManager] getFormatWithCloudLevel:model.clouds.all];

    _windCloudLabel.text = [windLevel stringByAppendingString:cloudLevel];
}

- (NSString *)getCurrentTemp:(NSString *)temp{
    NSArray* arr = [temp componentsSeparatedByString: @"."];
    NSString* currentTemp = [arr objectAtIndex:0];
    return [NSString stringWithFormat:@"%@",currentTemp];
}



- (NSString *)convertTimeWithTimeStamp:(NSString *)timestamp withFormatter:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format]; //设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSDate *curDateTime = [NSDate dateWithTimeIntervalSince1970:[timestamp longLongValue]];
    NSString *formatTime = [formatter stringFromDate:curDateTime];
    return formatTime;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            [self getAddressByLatitude:[[UserInfo sharedUserInfo].lat doubleValue] longitude:[[UserInfo sharedUserInfo].lon doubleValue]];
        }
    }else if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            [self requestWeatherByLongitude:[UserInfo sharedUserInfo].lon Latitude:[UserInfo sharedUserInfo].lat];
        }
    }
}

- (TBActivityView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[TBActivityView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH - 70, 30)];
        [self.indicatorView setCenter:CGPointMake(APP_SCREEN_WIDTH / 2.0, APP_SCREEN_HEIGHT - 90)];
        [self.view addSubview:self.indicatorView];
    }
    return _indicatorView;
}

- (void)showWaitIndicator {
    [self.indicatorView startAnimate];
}

- (void)removeWaitIndicator {
    [self.indicatorView stopAnimate];
}


@end

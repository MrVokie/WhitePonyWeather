//
//  ViewController.h
//  WhitePonyWeather
//
//  Created by Vokie on 8/24/15.
//  Copyright (c) 2015 vokie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (retain, nonatomic) CLLocationManager *locationManager;

@property (retain, nonatomic) CLGeocoder *geocoder;
@property (weak, nonatomic) IBOutlet UILabel *curTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *visibilityDistLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidAtmosLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunRiseSetLabel;
@property (weak, nonatomic) IBOutlet UILabel *windCloudLabel;

@end

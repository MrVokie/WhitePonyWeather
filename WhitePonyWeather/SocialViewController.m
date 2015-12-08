//
//  SocialViewController.m
//  WhitePonyWeather
//
//  Created by Vokie on 11/21/15.
//  Copyright © 2015 vokie. All rights reserved.
//

#import "SocialViewController.h"
#import "UMSocial.h"

@interface SocialViewController ()<UMSocialUIDelegate>

@end

@implementation SocialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"分享天气";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    [self initNavButton];
    
    [self share];
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

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    NSString *resultString = @"";
    if (response.responseCode == UMSResponseCodeSuccess) {
        resultString = @"分享成功啦!";
    }else if (response.responseCode == UMSResponseCodeCancel) {
        resultString = @"您取消分享了:（";
    }else {
        resultString = [NSString stringWithFormat:@"分享失败，失败Code:%d", response.responseCode];
    }
    
    [[[UIAlertView alloc]initWithTitle:@"提示" message:resultString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
}

- (IBAction)ShareAgainButtonClick:(id)sender {
    [self share];
}

- (void)share {
    NSString *shareText = [NSString stringWithFormat:@"【白驹天气】vokie向您分享南京市的天气情况:2014年5月13日，天气晴朗，最高温度22度，最低温度17度。"];
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"564fca6467e58e3b3f003d91"
        shareText:shareText
        shareImage:nil
        shareToSnsNames:[NSArray arrayWithObjects:UMShareToSms,  UMShareToEmail, UMShareToSina, UMShareToDouban, UMShareToRenren, nil]
        delegate:self];
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

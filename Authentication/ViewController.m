//
//  ViewController.m
//  Authentication
//
//  Created by zhangDongdong on 2018/1/8.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "AlipaySDK/AlipaySDK.h"


@interface ViewController ()
{
    AppDelegate *appdelegate;
//    WeixinPayHelper *helper;
}
@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)wechatbtn:(id)sender {
    
    [[SocialManager defaultManager]getUserInfoWithPlatform:wechat completion:^(NSDictionary *result, NSInteger *error) {
        
         NSLog(@"%@",result);

    }];
    
}
- (IBAction)weibobtn:(id)sender {
    
    [[SocialManager defaultManager]getUserInfoWithPlatform:weibo completion:^(NSDictionary *result, NSInteger *error) {
        
        NSLog(@"%@",result);
        
    }];
}
- (IBAction)QQLoginbtn:(id)sender {
    
    [[SocialManager defaultManager]getUserInfoWithPlatform:QQ completion:^(NSDictionary *result, NSInteger *error) {
        
        NSLog(@"%@",result);
        
    }];
    
}

- (IBAction)alipaybtn:(id)sender {
    
    NSString *appScheme = @"com.microsoft.Authentication";
//    app_id=2015052600090779&biz_content={"timeout_express":"30m","product_code":"QUICK_MSECURITY_PAY","total_amount":"0.01","subject":"1","body":"我是测试数据","out_trade_no":"IQJZSRC1YMQB5HU"}&charset=utf-8&format=json&method=alipay.trade.app.pay&notify_url=http://domain.merchant.com/payment_notify&sign_type=RSA2&timestamp=2016-08-25 20:26:31&version=1.0
    
    NSString * orderString = @"app_id%3D2018030802337287%26biz_content%3D%7B%5C%22timeout_express%5C%22%3A%5C%2230m%5C%22%2C%5C%22product_code%5C%22%3A%5C%22QUICK_MSECURITY_PAY%5C%22%2C%5C%22total_amount%5C%22%3A%5C%220.02%5C%22%2C%5C%22subject%5C%22%3A%5C%221%5C%22%2C%5C%22body%5C%22%3A%5C%22%E6%88%91%E6%98%AF%E6%B5%8B%E8%AF%95%E6%95%B0%E6%8D%AE%5C%22%2C%5C%22out_trade_no%5C%22%3A%5C%22ZQLM3O56MJD4SK3%5C%22%7D%26charset%3Dutf-8%26method%3Dalipay.trade.app.pay%26sign_type%3DRSA2%26timestamp%3D2018-03-28%2020%3A36%3A11%26version%3D1.0sign%3D*H1jG3wouVyD8gzu1rCeHCU%2FFzPmCddL1nXEU31M35Y8plDa4FpA2nxbf%2BmJgB71L70vl0hzAthwynTBjiXLUI8228lGoBkI%2Bgy7aPhkmzFvMNIoC%2B%2F0QP0UmwUrBwUjzca0V99O5mU%2BQ5GnADh41jdzEkX28lIvb42qxziJ8byU3APat4NdsILITZSD5pHL2G%2BJmSlsQX58tfgOb6D8icJwdaSpAvggzvvkt7uY%2BCfs9HMtInDrfU8udFha%2B6n1qx9g%2BtEPLP%2F7pVUDzBaEh8qQ3nS7%2FwpJ1k8Ku9C7kI4F4GsdRSYCGaslgv7Oy2X3wLlNmzJV4Burob7lVI1hvJA%3D%3D";
    
    // NOTE: 调用支付结果开始支付
    
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        
        NSLog(@"reslut = %@",resultDic);
        
        NSString * memo = resultDic[@"memo"];
        
        NSLog(@"===memo:%@", memo);
        
        if ([resultDic[@"ResultStatus"] isEqualToString:@"9000"]) {
            
            NSLog(@"支付成功");
            
        }else{
            
            NSLog(@"支付失败");
        }
        
        
        
    }];
}

@end

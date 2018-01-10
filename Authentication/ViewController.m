//
//  ViewController.m
//  Authentication
//
//  Created by zhangDongdong on 2018/1/8.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"


#define IFM_SinaAPPKey      @"2161062029"
#define IFM_SinaAppSecret   @"8882ed1ca6c30b9b8794765ec3313a39"


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


@end

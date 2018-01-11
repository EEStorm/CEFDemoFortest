//
//  ViewController.m
//  Authentication
//
//  Created by zhangDongdong on 2018/1/8.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"



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


@end

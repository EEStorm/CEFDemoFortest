//
//  ViewController.m
//  Authentication
//
//  Created by zhangDongdong on 2018/1/8.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import "ViewController.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"
//微信开发者ID
#define URL_APPID @"wx0a6553c087c9e3ea"
#define URL_SECRET @"b55dda0f534a6014dd472442d22a6e29"

#define IFM_SinaAPPKey      @"2161062029"
#define IFM_SinaAppSecret   @"8882ed1ca6c30b9b8794765ec3313a39"

//#import "AFNetworking.h"
//#import "WeixinPayHelper.h"

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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(weiboDidLoginNotification:) name:@"weiboDidLoginNotification" object:nil];
}
- (IBAction)wechatbtn:(id)sender {
    
    [[SocialManager defaultManager]getUserInfoWithPlatform:wechat completion:^(id result, NSError *error) {



    }];
//    if ([WXApi isWXAppInstalled]) {
//        SendAuthReq *req = [[SendAuthReq alloc]init];
//        req.scope = @"snsapi_userinfo";
//        req.openID = URL_APPID;
//        req.state = @"1245";
//        appdelegate = [UIApplication sharedApplication].delegate;
//        appdelegate.wxDelegate = self;
//
//        [WXApi sendReq:req];
//    }else{
//        //把微信登录的按钮隐藏掉。
//    }
    
}
- (IBAction)weibobtn:(id)sender {
    
    NSLog(@"%s",__func__);
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = @"http://www.baidu.com";
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}


#pragma mark 微信登录回调。
-(void)loginSuccessByCode:(NSString *)code{
    NSLog(@"code %@",code);
    __weak typeof(*&self) weakSelf = self;
    
    NSString *url =[NSString stringWithFormat:
                    @"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",
                    URL_APPID,URL_SECRET,code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"%@",dic);
                NSString *accessToken = dic[@"access_token"];
                NSString *openId = dic[@"openid"];
                
//                [self getWechatUserInfoWithAccessToken:accessToken openId:openId];
                [weakSelf requestUserInfoByToken:accessToken andOpenid:openId];
            }
        });
    });

    
}

-(void)requestUserInfoByToken:(NSString *)token andOpenid:(NSString *)openID{
    

    NSString *url =[NSString stringWithFormat:
                    @"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openID];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"%@",dic);
                
                NSString *openId = [dic objectForKey:@"openid"];
                NSString *memNickName = [dic objectForKey:@"nickname"];
                NSString *memSex = [dic objectForKey:@"sex"];
                
//                [self loginWithOpenId:openId memNickName:memNickName memSex:memSex];
            }
        });
        
    });
    
}


#pragma mark - Weibo Methods

- (void)weiboDidLoginNotification:(NSNotification *)notification
{
    NSLog(@"%s",__func__);
    
    NSDictionary *userInfo = [notification userInfo];
    NSString *accessToken = [userInfo objectForKey:@"accessToken"];
    NSString *uid = [userInfo objectForKey:@"userId"];
    
    NSLog(@"userInfo %@",userInfo);
    
    [self getWeiboUserInfoWithAccessToken:accessToken uid:uid];
}

- (void)getWeiboUserInfoWithAccessToken:(NSString *)accessToken uid:(NSString *)uid
{
    NSString *url =[NSString stringWithFormat:
                    @"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@",accessToken,uid];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl
                                                     encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data)
            {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"%@",dic);
                
                NSString *openId = [dic objectForKey:@"id"];
                NSString *memNickName = [dic objectForKey:@"name"];
                NSString *memSex = [[dic objectForKey:@"gender"] isEqualToString:@"m"] ? @"1" : @"0";
                
//                [self loginWithOpenId:openId memNickName:memNickName memSex:memSex];
            }
        });
        
    });
}



@end

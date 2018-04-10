//
//  weiboManager.m
//  Authentication
//
//  Created by zhangDongdong on 2018/1/10.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import "WeiboManager.h"

@implementation WeiboManager



-(void)registWXSDKwithAppkey:(NSString *)appkey appSecret:(NSString *)appSecret redirectURL:(NSString *)redirectURL{
    
    [WeiboSDK enableDebugMode:true];
    [WeiboSDK registerApp:appkey];
    NSLog(@"%s",__func__);
    

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(weiboDidLoginNotification:) name:@"weiboDidLoginNotification"  object:nil];
}

-(void)sendReqWithAppkey:(NSString *)appkey appSecret:(NSString *)appSecret redirectURL:(NSString *)redirectURL {
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"WB_ACCESS_TOKEN"];
    NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:@"WB_USER_ID"];

    if (accessToken && openID) {
        
        [self weiboRefreshToken:appkey appSecret:appSecret redirectURL:redirectURL];
        
    }else {
        
        [self weiboLogin:appkey redirectURL:redirectURL];
    }
    
}


-(void)weiboRefreshToken:(NSString *)appkey appSecret:(NSString *)appSecret redirectURL:(NSString *)redirectURL {
    
    
    NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"WB_REFRESH_TOKEN"];
    NSString *refreshUrlStr = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/access_token?client_id=%@&client_secret=%@&grant_type=refresh_token&redirect_uri=%@&refresh_token=%@",appkey, appSecret,redirectURL, refreshToken];
    
    NSURL *url = [NSURL URLWithString:refreshUrlStr];
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSString *args = [NSString stringWithFormat:@"%@",refreshToken];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            //        NSLog(@"%@",dict);
            NSString *accessToken = dict[@"access_token"];
            NSString *refreshToken = dict[@"refresh_token"];
            NSString *userId = dict[@"uid"];
            
            if (accessToken && (![accessToken isEqual: @""])&& userId && ![userId isEqual: @""]) {
                
                [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"WB_ACCESS_TOKEN"];
                [[NSUserDefaults standardUserDefaults]setObject:userId forKey:@"WB_USER_ID"];
                [[NSUserDefaults standardUserDefaults]setObject:refreshToken forKey:@"WB_REFRESH_TOKEN"];
                
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            
            [self getWeiboUserInfoWithAccessToken:accessToken uid:userId];
        }
        
    }];
    
    
    [sessionDataTask resume];

}



-(void)weiboLogin:(NSString *)appkey redirectURL:(NSString *)redirectURL {
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = redirectURL;
    request.scope = @"all";
    request.userInfo = @{
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
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
                
                
                NSString *openId = [dic objectForKey:@"id"];
                NSString *memNickName = [dic objectForKey:@"name"];
                NSString *memSex = [[dic objectForKey:@"gender"] isEqualToString:@"m"] ? @"1" : @"0";
                
                self.completion(dic, self.error);
                //                [self loginWithOpenId:openId memNickName:memNickName memSex:memSex];
            }
        });
        
    });
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString *userId = [(WBAuthorizeResponse *)response userID];
        NSString *accessToken = [(WBAuthorizeResponse *)response accessToken];
        NSString *refreshToken = [(WBAuthorizeResponse *)response refreshToken];
        
        if (refreshToken) {
            // 更新access_token、refresh_token、open_id
            
            if (accessToken && (![accessToken isEqual: @""])&& userId && ![userId isEqual: @""]) {
                
                [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"WB_ACCESS_TOKEN"];
                [[NSUserDefaults standardUserDefaults]setObject:userId forKey:@"WB_USER_ID"];
                [[NSUserDefaults standardUserDefaults]setObject:refreshToken forKey:@"WB_REFRESH_TOKEN"];
                
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
        }
        
        NSLog(@"userId %@",userId);
        NSLog(@"accessToken %@",accessToken);
        
        NSDictionary *notification = @{
                                       @"userId" : userId,
                                       @"accessToken" : accessToken
                                       };
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"weiboDidLoginNotification"
                                                            object:self userInfo:notification];
    }else {
        self.error = 0;
    }
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}


@end

















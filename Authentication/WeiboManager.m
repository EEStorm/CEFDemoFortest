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
    

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(weiboDidLoginNotification:) name:@"weiboDidLoginNotification" object:nil];
}

-(void)sendReqWithAppkey:(NSString *)appkey redirectURL:(NSString *)redirectURL {
    
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

















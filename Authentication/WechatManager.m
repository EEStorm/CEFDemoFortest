//
//  wechatManager.m
//  Authentication
//
//  Created by zhangDongdong on 2018/1/10.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import "WechatManager.h"

@implementation WechatManager

-(void)registWXSDKwithAppkey:(NSString *)appkey appSecret:(NSString *)appSecret{
    
    [WXApi registerApp:appkey];
    
}

-(void)sendReqWithAppkey:(NSString *)appkey{
    
    if ([WXApi isWXAppInstalled]) {
        
        NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"WX_ACCESS_TOKEN"];
        NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:@"WX_OPEN_ID"];
       
        if (accessToken && openID) {

            [self wechatRefreshToken:appkey];
            
        }else {
            
            [self wechatLogin:appkey];
        }
        
    }else{
        //把微信登录的按钮隐藏掉。
    }
} 

-(void)wechatRefreshToken:(NSString *)appkey{
    
    NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"WX_REFRESH_TOKEN"];
    NSString *refreshUrlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@", appkey, refreshToken];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *zoneUrl = [NSURL URLWithString:refreshUrlStr];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers error:nil];
                NSString *openId = [dic objectForKey:@"openid"];
                NSString *accessToken = [dic objectForKey:@"access_token"];
                NSString *reAccessToken = [dic objectForKey:@"refresh_token"];
                
                if (reAccessToken) {
                    // 更新access_token、refresh_token、open_id
                     [self requestUserInfoByToken:accessToken andOpenid:openId];
                    
                    if (accessToken && (![accessToken isEqual: @""])&& openId && ![openId isEqual: @""]) {
                        
                        [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"WX_ACCESS_TOKEN"];
                        [[NSUserDefaults standardUserDefaults]setObject:openId forKey:@"WX_OPEN_ID"];
                        [[NSUserDefaults standardUserDefaults]setObject:refreshToken forKey:@"WX_REFRESH_TOKEN"];
                        
                        [[NSUserDefaults standardUserDefaults]synchronize];
                    }
                }
                else {
                    [self wechatLogin:appkey];
                }
                
            }else {
                [self wechatLogin:appkey];
            }
        });
        
    });
}



-(void)wechatLogin:(NSString *)appkey{
    
    SendAuthReq *req = [[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    req.openID = appkey;
    req.state = @"1245";
    self.wxDelegate = self;
    
    [WXApi sendReq:req];
}

-(void) onResp:(BaseResp*)resp{
    NSLog(@"resp %d",resp.errCode);
    
    /*
     enum  WXErrCode {
     WXSuccess           = 0,    成功
     WXErrCodeCommon     = -1,  普通错误类型
     WXErrCodeUserCancel = -2,    用户点击取消并返回
     WXErrCodeSentFail   = -3,   发送失败
     WXErrCodeAuthDeny   = -4,    授权失败
     WXErrCodeUnsupport  = -5,   微信不支持
     };
     */
    if ([resp isKindOfClass:[SendAuthResp class]]) {   //授权登录的类。
        if (resp.errCode == 0) {  //成功。
            //这里处理回调的方法 。 通过代理吧对应的登录消息传送过去。
            self.error = resp.errCode;
            if ([_wxDelegate respondsToSelector:@selector(loginSuccessByCode:)]) {
                SendAuthResp *resp2 = (SendAuthResp *)resp;
                [_wxDelegate loginSuccessByCode:resp2.code];
            }
        }else{ //失败
            NSLog(@"error %@",resp.errStr);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败" message:[NSString stringWithFormat:@"reason : %@",resp.errStr] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
    
    /*
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) { //微信分享 微信回应给第三方应用程序的类
        SendMessageToWXResp *response = (SendMessageToWXResp *)resp;
        NSLog(@"error code %d  error msg %@  lang %@   country %@",response.errCode,response.errStr,response.lang,response.country);
        
        if (resp.errCode == 0) {  //成功。
            //这里处理回调的方法 。 通过代理吧对应的登录消息传送过去。
            if (_wxDelegate) {
                if([_wxDelegate respondsToSelector:@selector(shareSuccessByCode:)]){
                    [_wxDelegate shareSuccessByCode:response.errCode];
                }
            }
        }else{ //失败
            NSLog(@"error %@",resp.errStr);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"reason : %@",resp.errStr] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
    */
    
}

- (void)loginSuccessByCode:(NSString *)code { 
    
    NSLog(@"code %@",code);
    __weak typeof(*&self) weakSelf = self;
    
    NSString *url =[NSString stringWithFormat:
                    @"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",
                    self.appkey,self.appsecret,code];
    
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
                NSString *refreshToken = dic[@"refresh_token"];
                
                if (accessToken && (![accessToken isEqual: @""])&& openId && ![openId isEqual: @""]) {
                    
                    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"WX_ACCESS_TOKEN"];
                    [[NSUserDefaults standardUserDefaults]setObject:openId forKey:@"WX_OPEN_ID"];
                    [[NSUserDefaults standardUserDefaults]setObject:refreshToken forKey:@"WX_REFRESH_TOKEN"];
                    
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
//
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
                
                self.result = dic;
               self.completion(self.result,self.error);
//                NSLog(@"%@",dic);
//                NSString *openId = [dic objectForKey:@"openid"];
//                NSString *memNickName = [dic objectForKey:@"nickname"];
//                NSString *memSex = [dic objectForKey:@"sex"];
                
                //                [self loginWithOpenId:openId memNickName:memNickName memSex:memSex];
            }
        });
        
    });
    
}

- (void)shareSuccessByCode:(int)code { 
    
}

@end

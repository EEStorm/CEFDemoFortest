//
//  QQManager.m
//  Authentication
//
//  Created by zhangDongdong on 2018/1/10.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import "QQManager.h"

@implementation QQManager


-(void)registWXSDKwithAppkey:(NSString *)appkey appSecret:(NSString *)appSecret redirectURL:(NSString *)redirectURL{
    
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:appkey andDelegate:self];
    
}

-(void)sendReqWithAppkey:(NSString *)appkey redirectURL:(NSString *)redirectURL {
//    if (_tencentOAuth.accessToken) {
//
//        //获取用户信息。 调用这个方法后，qq的sdk会自动调用
//        //- (void)getUserInfoResponse:(APIResponse*) response
//
//        [_tencentOAuth getUserInfo];
//
//        NSString *accessToken = _tencentOAuth.accessToken;
//        if (accessToken && (![accessToken isEqual: @""])) {
//
//            [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"QQ_ACCESS_TOKEN"];
//        }
//    }else{
//
//        NSLog(@"accessToken 没有获取成功");
        [self QQLogin];
//    }
    
}


-(void)QQLogin{
    NSArray *permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, nil];
    [self.tencentOAuth authorize:permissions];
}

- (void)tencentDidLogin{
    
    /** Access Token凭证，用于后续访问各开放接口 */
    if (_tencentOAuth.accessToken) {
        
        //获取用户信息。 调用这个方法后，qq的sdk会自动调用
        //- (void)getUserInfoResponse:(APIResponse*) response
        
        [_tencentOAuth getUserInfo];
        
        NSString *accessToken = _tencentOAuth.accessToken;
        if (accessToken && (![accessToken isEqual: @""])) {
            
            [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"QQ_ACCESS_TOKEN"];
        }
    }else{
        
        NSLog(@"accessToken 没有获取成功");
    }
    
}

- (void)tencentDidNotLogin:(BOOL)cancelled{
    if (cancelled) {
        NSLog(@" 用户点击取消按键,主动退出登录");
    }else{
        NSLog(@"其他原因， 导致登录失败");
    }
}

- (void)tencentDidNotNetWork{
    NSLog(@"没有网络了， 怎么登录成功呢");
}

- (BOOL)tencentNeedPerformIncrAuth:(TencentOAuth *)tencentOAuth withPermissions:(NSArray *)permissions{
    
    // incrAuthWithPermissions是增量授权时需要调用的登录接口
    // permissions是需要增量授权的权限列表
    [tencentOAuth incrAuthWithPermissions:permissions];
    return NO; // 返回NO表明不需要再回传未授权API接口的原始请求结果；
    // 否则可以返回YES
}

/**
 * [该逻辑未实现]因token失效而需要执行重新登录授权。在用户调用某个api接口时，如果服务器返回token失效，则触发该回调协议接口，由第三方决定是否跳转到登录授权页面，让用户重新授权。
 * \param tencentOAuth 登录授权对象。
 * \return 是否仍然回调返回原始的api请求结果。
 * \note 不实现该协议接口则默认为不开启重新登录授权流程。若需要重新登录授权请调用\ref TencentOAuth#reauthorizeWithPermissions: \n注意：重新登录授权时用户可能会修改登录的帐号
 */
- (BOOL)tencentNeedPerformReAuth:(TencentOAuth *)tencentOAuth{
    
    [self QQLogin];
    return YES;
}

/**
 * 用户通过增量授权流程重新授权登录，token及有效期限等信息已被更新。
 * \param tencentOAuth token及有效期限等信息更新后的授权实例对象
 * \note 第三方应用需更新已保存的token及有效期限等信息。
 */
- (void)tencentDidUpdate:(TencentOAuth *)tencentOAuth{
    NSLog(@"增量授权完成");
    if (tencentOAuth.accessToken
        && 0 != [tencentOAuth.accessToken length])
    {
        [[NSUserDefaults standardUserDefaults]setObject:tencentOAuth.accessToken forKey:@"QQ_ACCESS_TOKEN"];
        [[NSUserDefaults standardUserDefaults]setObject:tencentOAuth.openId forKey:@"QQ_OPEN_ID"];
    }
    else
    {
        NSLog(@"增量授权不成功，没有获取accesstoken");
    }
    
}

/**
 * 用户增量授权过程中因取消或网络问题导致授权失败
 * \param reason 授权失败原因，具体失败原因参见sdkdef.h文件中\ref UpdateFailType
 */
- (void)tencentFailedUpdate:(UpdateFailType)reason{
    
    switch (reason)
    {
        case kUpdateFailNetwork:
        {
            //            _labelTitle.text=@"增量授权失败，无网络连接，请设置网络";
            NSLog(@"增量授权失败，无网络连接，请设置网络");
            break;
        }
        case kUpdateFailUserCancel:
        {
            //            _labelTitle.text=@"增量授权失败，用户取消授权";
            NSLog(@"增量授权失败，用户取消授权");
            break;
        }
        case kUpdateFailUnknown:
        default:
        {
            NSLog(@"增量授权失败，未知错误");
            break;
        }
    }
    
    
}

/**
 * 获取用户个人信息回调
 */
- (void)getUserInfoResponse:(APIResponse*) response{
    NSLog(@" response %@",response.userData);
    NSLog(@" response %@",response.jsonResponse);
    
    NSDictionary *dic = response.jsonResponse;
    NSMutableArray *arr = [NSMutableArray array];
    QQProfile *qqPofile = [[QQProfile alloc]init];
    qqPofile.is_yellow_vip = [dic objectForKey:@"is_yellow_vip"];
    qqPofile.city = [dic objectForKey:@"city"];
    qqPofile.gender = [dic objectForKey:@"gender"];
    qqPofile.year = [dic objectForKey:@"year"];
    qqPofile.nickname = [dic objectForKey:@"nickname"];
    qqPofile.province = [dic objectForKey:@"province"];
    [arr addObject:qqPofile];
    
    NSString *homePath = NSHomeDirectory();
    NSString *path = [homePath stringByAppendingPathComponent:@"Library/Caches/QQ.archive"];
    [NSKeyedArchiver archiveRootObject:arr toFile:path];
   
    self.completion(response.jsonResponse, 0);
    
}

@end

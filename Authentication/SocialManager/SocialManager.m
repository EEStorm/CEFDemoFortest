//
//  SocialManager.m
//  Authentication
//
//  Created by zhangDongdong on 2018/1/10.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import "SocialManager.h"

@implementation SocialManager

static SocialManager *_instance;

-(void)setPlaform:(Platform)platform appkey:(NSString *)appkey appSecret:(NSString *)appSecret redirectURL:(NSString *)redirectURL withEID:(NSString *)EID{
    
    if (platform == wechat) {
        
        self.wechatmanager = [[WechatManager alloc]init];
        self.wechatAppkey = appkey;
        self.wechatSecret = appSecret;
        self.wechatmanager.appkey = appkey;
        self.wechatmanager.appsecret = appSecret;
        
        [self.wechatmanager registWXSDKwithAppkey:appkey appSecret:appSecret];
    }else if (platform == weibo){
        
        self.weiboManager = [[WeiboManager alloc]init];
        [self.weiboManager registWXSDKwithAppkey:appkey appSecret:appSecret redirectURL:redirectURL];
        self.weiboAppkey = appkey;
        self.weiboSecret = appSecret;
        self.weiboRedirectURL = redirectURL;
    }else {
        
        self.qqManager = [[QQManager alloc]init];
        [self.qqManager registWXSDKwithAppkey:appkey appSecret:appSecret redirectURL:redirectURL];
        self.qqAppkey = appkey;
        self.qqSecret = appSecret;
        self.qqRedirectURL = redirectURL;
    }
    
}

-(void)getUserInfoWithPlatform:(Platform)platform completion:(SocialCompletion)completion {
    
    if (platform == wechat) {
        
        [self.wechatmanager sendReqWithAppkey:self.wechatAppkey];
        self.wechatmanager.completion = completion;
        
    } else if (platform == weibo){
        
        [self.weiboManager sendReqWithAppkey:self.weiboAppkey appSecret:self.weiboSecret redirectURL:self.weiboRedirectURL];
        self.weiboManager.completion = completion;
    }else {
        [self.qqManager sendReqWithAppkey:self.qqAppkey redirectURL:self.qqRedirectURL];
        self.qqManager.completion = completion;
    }
    
}

-(BOOL)handleOpenURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    
    if ([url.host isEqualToString:@"pay"]) {// 微信
        return [WXApi handleOpenURL:url delegate:CEFPayManager];
    }
    
    if ([options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.sina.weibo"]) {
        NSLog(@"新浪微博~");
        
        return [WeiboSDK handleOpenURL:url delegate:self.weiboManager];
        
    }else if ([options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.tencent.xin"]){
        
        return [WXApi handleOpenURL:url delegate:self.wechatmanager];
        
    }else if ([options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.tencent.mqq"]){
        
        /**
         处理由手Q唤起的跳转请求
         \param url 待处理的url跳转请求
         \param delegate 第三方应用用于处理来至QQ请求及响应的委托对象
         \return 跳转请求处理结果，YES表示成功处理，NO表示不支持的请求协议或处理失败
         */
        [QQApiInterface handleOpenURL:url delegate:self.qqManager];
        return [TencentOAuth HandleOpenURL:url];
    }
    return true;
}



+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    //    @synchronized (self) {
    //        // 为了防止多线程同时访问对象，造成多次分配内存空间，所以要加上线程锁
    //        if (_instance == nil) {
    //            _instance = [super allocWithZone:zone];
    //        }
    //        return _instance;
    //    }
    // 也可以使用一次性代码
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}

+(instancetype)defaultManager
{
    
    return [[self alloc]init];
}

-(id)copyWithZone:(NSZone *)zone
{
    return _instance;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}
@end

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

-(void)setPlaform:(Platform)platform appkey:(NSString *)appkey appSecret:(NSString *)appSecret redirectURL:(NSString *)redirectURL{
    
    if (platform == wechat) {
        
        self.wechatmanager = [WechatManager new];
        [self.wechatmanager registWXSDKwithAppkey:appkey appSecret:appSecret];
        self.wechatAppkey = appkey;
        self.wechatSecret = appSecret;
        self.wechatmanager.appkey = appkey;
        self.wechatmanager.appsecret = appSecret;
        
    }else {
        
    }
    
}

-(void)getUserInfoWithPlatform:(Platform)paltform completion:(Completion)completion {
    
    if (paltform == wechat) {
        
        [self.wechatmanager sendReqWithAppkey:self.wechatAppkey];

        self.wechatmanager.completion = completion;
        
    } else {
        
    }
    
}

-(BOOL)handleOpenURL:(NSURL *)url{
    
    
    return [WXApi handleOpenURL:url delegate:self.wechatmanager];
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

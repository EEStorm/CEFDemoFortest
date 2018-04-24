//
//  SocialManager.h
//  Authentication
//
//  Created by zhangDongdong on 2018/1/10.
//  Copyright © 2018年 micorosoft. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "WechatManager.h"
#import "WeiboManager.h"
#import "QQManager.h"

//#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>



typedef enum {
    
    wechat = 0,

    QQ = 1,

    weibo = 2
    
} Platform;

typedef void(^SocialCompletion)(NSDictionary *result, NSInteger *error);



@interface SocialManager : NSObject<WXApiDelegate>


@property(copy,nonatomic)SocialCompletion completion;


#pragma mark - 微信

@property(strong,nonatomic)WechatManager * wechatmanager;
@property(assign,nonatomic)NSString* wechatAppkey;
@property(assign,nonatomic)NSString* wechatSecret;


#pragma mark - 微博
@property(strong,nonatomic)WeiboManager *weiboManager;
@property(assign,nonatomic)NSString * weiboAppkey;
@property(assign,nonatomic)NSString * weiboSecret;
@property(assign,nonatomic)NSString * weiboRedirectURL;

#pragma mark - QQ
@property(strong,nonatomic)QQManager * qqManager;
@property(assign,nonatomic)NSString * qqAppkey;
@property(assign,nonatomic)NSString * qqSecret;
@property(assign,nonatomic)NSString * qqRedirectURL;



+(instancetype)defaultManager;

-(void)setPlaform:(Platform)platform appkey:(NSString *)appkey appSecret:(NSString *)appSecret redirectURL:(NSString *)redirectURL;

-(void)getUserInfoWithPlatform:(Platform)platform completion:(SocialCompletion)completion;

-(BOOL)handleOpenURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options;


@end









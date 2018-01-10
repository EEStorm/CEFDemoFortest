//
//  SocialManager.h
//  Authentication
//
//  Created by zhangDongdong on 2018/1/10.
//  Copyright © 2018年 micorosoft. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "WechatManager.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>


//微信开发者ID
#define URL_APPID @"wx0a6553c087c9e3ea"
#define URL_SECRET @"b55dda0f534a6014dd472442d22a6e29"

typedef enum {
    
    wechat = 0,

    QQ = 1,

    weibo = 2
    
} Platform;

typedef void(^Completion)(id result, NSError *error);



@interface SocialManager : NSObject<WXApiDelegate,WXDelegate>



@property(strong,nonatomic)WechatManager *wechatmanager;
@property(copy,nonatomic)Completion completion;
@property (nonatomic, weak)id<WXDelegate> wxDelegate;

+(instancetype)defaultManager;

-(void)setPlaform:(Platform)platform appkey:(NSString *)appkey appSecret:(NSString *)appSecret redirectURL:(NSString *)redirectURL;

-(void)getUserInfoWithPlatform:(Platform)paltform completion:(Completion)completion;

-(BOOL)handleOpenURL:(NSURL *)url;
@end









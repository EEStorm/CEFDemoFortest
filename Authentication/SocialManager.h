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



typedef enum {
    
    wechat = 0,

    QQ = 1,

    weibo = 2
    
} Platform;

typedef void(^Completion)(NSDictionary *result, NSInteger *error);



@interface SocialManager : NSObject<WXApiDelegate>



@property(strong,nonatomic)WechatManager *wechatmanager;
@property(copy,nonatomic)Completion completion;
@property(assign,nonatomic)NSString* wechatAppkey;
@property(assign,nonatomic)NSString* wechatSecret;

+(instancetype)defaultManager;

-(void)setPlaform:(Platform)platform appkey:(NSString *)appkey appSecret:(NSString *)appSecret redirectURL:(NSString *)redirectURL;

-(void)getUserInfoWithPlatform:(Platform)paltform completion:(Completion)completion;

-(BOOL)handleOpenURL:(NSURL *)url;
@end









//
//  wechatManager.h
//  Authentication
//
//  Created by zhangDongdong on 2018/1/10.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"


@protocol WXDelegate <NSObject>

-(void)loginSuccessByCode:(NSString *)code;
-(void)shareSuccessByCode:(int) code;
//-(void)weiboDidLoginNotification:(NSNotification *)notification;

@end

typedef void(^SocialCompletion)(NSDictionary *result, NSInteger *error);

@interface WechatManager : NSObject<WXApiDelegate,WXDelegate>


@property (nonatomic, weak) id<WXDelegate> wxDelegate;
@property (nonatomic, assign) NSString * appkey;
@property (nonatomic, assign) NSString * appsecret;
@property (nonatomic, assign) NSDictionary * result;
@property (nonatomic, assign) NSInteger *error;
@property(copy,nonatomic)SocialCompletion completion;

-(void)registWXSDKwithAppkey:(NSString *)appkey appSecret:(NSString *)appSecret;
-(void)sendReqWithAppkey:(NSString*)appkey ;

@end

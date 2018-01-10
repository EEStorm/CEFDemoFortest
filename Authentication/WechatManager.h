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


@interface WechatManager : NSObject<WXApiDelegate,WXDelegate>


@property (nonatomic, weak) id<WXDelegate> wxDelegate;


-(void)registWXSDKwithAppkey:(NSString *)appkey appSecret:(NSString *)appSecret;


@end

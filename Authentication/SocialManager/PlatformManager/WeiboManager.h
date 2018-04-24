//
//  weiboManager.h
//  Authentication
//
//  Created by zhangDongdong on 2018/1/10.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"

@protocol WBDelegate <NSObject>

-(void)weiboDidLoginNotification:(NSNotification *)notification;

@end

typedef void(^SocialCompletion)(NSDictionary *result, NSInteger *error);

@interface WeiboManager : NSObject<WeiboSDKDelegate,WBDelegate>

@property(copy,nonatomic)SocialCompletion completion;
@property (nonatomic, assign) NSInteger *error;
@property (nonatomic, weak) id<WBDelegate> wbDelegate;

-(void)sendReqWithAppkey:(NSString *)appkey appSecret:(NSString *)appSecret redirectURL:(NSString *)redirectURL;
-(void)registWXSDKwithAppkey:(NSString *)appkey appSecret:(NSString *)appSecret redirectURL:(NSString *)redirectURL;

@end

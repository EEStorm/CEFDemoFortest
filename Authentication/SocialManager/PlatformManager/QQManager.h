//
//  QQManager.h
//  Authentication
//
//  Created by zhangDongdong on 2018/1/10.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

typedef void(^Completion)(NSDictionary *result, NSInteger *error);

@interface QQManager : NSObject<TencentSessionDelegate>

@property(strong,nonatomic)TencentOAuth *tencentOAuth;

@property(copy,nonatomic)Completion completion;


-(void)sendReqWithAppkey:(NSString *)appkey redirectURL:(NSString *)redirectURL;
-(void)registWXSDKwithAppkey:(NSString *)appkey appSecret:(NSString *)appSecret redirectURL:(NSString *)redirectURL;


@end

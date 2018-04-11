//
//  AppDelegate.m
//  Authentication
//
//  Created by zhangDongdong on 2018/1/8.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import "SocialManager.h"

#import "AlipaySDK/AlipaySDK.h"

//微信开发者ID
#define URL_APPID @"wx0a6553c087c9e3ea"
#define URL_SECRET @"b55dda0f534a6014dd472442d22a6e29"

#define IFM_SinaAPPKey      @"2161062029"
#define IFM_SinaAppSecret   @"8882ed1ca6c30b9b8794765ec3313a39"

#define QQ_APPID @"1105567034"
#define QQ_SECRET @"i9u9zTaunPX7JIzM"

@interface AppDelegate ()<TencentSessionDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [[SocialManager defaultManager] setPlaform:wechat appkey:URL_APPID appSecret:URL_SECRET redirectURL:nil];
    
    [[SocialManager defaultManager] setPlaform:weibo appkey:IFM_SinaAPPKey appSecret:IFM_SinaAppSecret redirectURL:@"http://www.baidu.com"];

    [[SocialManager defaultManager] setPlaform:QQ appkey:QQ_APPID appSecret:QQ_SECRET redirectURL:@"http://com.infomedia.p3kapp"];
    
    return YES;
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{

    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return [[SocialManager defaultManager] handleOpenURL:url options:options];

}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}



//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//    return [TencentOAuth HandleOpenURL:url];
//}
//
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
//    return [TencentOAuth HandleOpenURL:url];
//}





- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

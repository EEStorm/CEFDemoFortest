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
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "SocialManager.h"

//微信开发者ID
#define URL_APPID @"wx0a6553c087c9e3ea"
#define URL_SECRET @"b55dda0f534a6014dd472442d22a6e29"

#define IFM_SinaAPPKey      @"2161062029"
#define IFM_SinaAppSecret   @"8882ed1ca6c30b9b8794765ec3313a39"

@interface AppDelegate ()<TencentSessionDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //向微信注册应用。
//    [WXApi registerApp:@"wx0a6553c087c9e3ea"];
    [[SocialManager defaultManager] setPlaform:wechat appkey:URL_APPID appSecret:URL_SECRET redirectURL:nil];
    
    [WeiboSDK enableDebugMode:true];
    [WeiboSDK registerApp:IFM_SinaAPPKey];
//
//    TencentOAuth *tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1105567034" andDelegate:self];
//    NSArray *permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, nil];
//    [tencentOAuth authorize:permissions];
    
    return YES;
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    
    /*! @brief 处理微信通过URL启动App时传递的数据
     *
     * 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
     * @param url 微信启动第三方应用时传递过来的URL
     * @param delegate  WXApiDelegate对象，用来接收微信触发的消息。
     * @return 成功返回YES，失败返回NO。
     */
    
//    return [WXApi handleOpenURL:url delegate:self];
    NSDictionary * dic = options;
    NSLog(@"%@", dic);
    
    if ([options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.sina.weibo"]) {
        NSLog(@"新浪微博~");
        
        return [WeiboSDK handleOpenURL:url delegate:self];
        
    }else if ([options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.tencent.xin"]){
        
//        return [WXApi handleOpenURL:url delegate:self];
        return [[SocialManager defaultManager]handleOpenURL:url ];
        
    }else if ([options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.tencent.mqq"]){
        
        /**
         处理由手Q唤起的跳转请求
         \param url 待处理的url跳转请求
         \param delegate 第三方应用用于处理来至QQ请求及响应的委托对象
         \return 跳转请求处理结果，YES表示成功处理，NO表示不支持的请求协议或处理失败
         */
        [QQApiInterface handleOpenURL:url delegate:self];
        return [TencentOAuth HandleOpenURL:url];
    }
    return YES;
}



/**
 处理来至QQ的请求
 */
- (void)onReq:(QQBaseReq *)req{
    NSLog(@" ----req %@",req);
}

//- (void)tencentDidLogin
//{
//    [_tencentOAuth getUserInfo];
//}
/**
 处理来至QQ的响应
 */
//- (void)onResp:(QQBaseResp *)resp{
//    NSLog(@" ----resp %@",resp);
//}

/**
 处理QQ在线状态的回调
 */
- (void)isOnlineResponse:(NSDictionary *)response{
    
}



//-(void) onResp:(BaseResp*)resp{
//    NSLog(@"resp %d",resp.errCode);
//
//    /*
//     enum  WXErrCode {
//     WXSuccess           = 0,    成功
//     WXErrCodeCommon     = -1,  普通错误类型
//     WXErrCodeUserCancel = -2,    用户点击取消并返回
//     WXErrCodeSentFail   = -3,   发送失败
//     WXErrCodeAuthDeny   = -4,    授权失败
//     WXErrCodeUnsupport  = -5,   微信不支持
//     };
//     */
//    if ([resp isKindOfClass:[SendAuthResp class]]) {   //授权登录的类。
//        if (resp.errCode == 0) {  //成功。
//            //这里处理回调的方法 。 通过代理吧对应的登录消息传送过去。
//            if ([_wxDelegate respondsToSelector:@selector(loginSuccessByCode:)]) {
//                SendAuthResp *resp2 = (SendAuthResp *)resp;
//                [_wxDelegate loginSuccessByCode:resp2.code];
//            }
//        }else{ //失败
//            NSLog(@"error %@",resp.errStr);
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败" message:[NSString stringWithFormat:@"reason : %@",resp.errStr] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            [alert show];
//        }
//    }
//
//    if ([resp isKindOfClass:[SendMessageToWXResp class]]) { //微信分享 微信回应给第三方应用程序的类
//        SendMessageToWXResp *response = (SendMessageToWXResp *)resp;
//        NSLog(@"error code %d  error msg %@  lang %@   country %@",response.errCode,response.errStr,response.lang,response.country);
//
//        if (resp.errCode == 0) {  //成功。
//            //这里处理回调的方法 。 通过代理吧对应的登录消息传送过去。
//            if (_wxDelegate) {
//                if([_wxDelegate respondsToSelector:@selector(shareSuccessByCode:)]){
//                    [_wxDelegate shareSuccessByCode:response.errCode];
//                }
//            }
//        }else{ //失败
//            NSLog(@"error %@",resp.errStr);
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"reason : %@",resp.errStr] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            [alert show];
//        }
//    }
//
//
//}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString *userId = [(WBAuthorizeResponse *)response userID];
        NSString *accessToken = [(WBAuthorizeResponse *)response accessToken];
        
        NSLog(@"userId %@",userId);
        NSLog(@"accessToken %@",accessToken);
        
        NSDictionary *notification = @{
                                       @"userId" : userId,
                                       @"accessToken" : accessToken
                                       };
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"weiboDidLoginNotification"
                                                            object:self userInfo:notification];
    }
}
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

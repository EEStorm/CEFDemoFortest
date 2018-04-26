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
#import "CEFService.h"
#import "PagementSuccessVC.h"

//微信开发者ID
#define URL_APPID @"wxa186d3f0aa51c56e"
#define URL_SECRET @"7c82bd6a2b1da97d78491a41c4166111"

#define IFM_SinaAPPKey      @"2161062029"
#define IFM_SinaAppSecret   @"8882ed1ca6c30b9b8794765ec3313a39"

#define QQ_APPID @"1105567034"
#define QQ_SECRET @"i9u9zTaunPX7JIzM"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

//
    [CEFPayManager registerPayment];
    CEFPayManager.aliPayEnable = false;
    
    NSString *EID = [[NSUserDefaults standardUserDefaults] objectForKey:@"CUSTOM_EID"];
    if (EID) {
        [CEFService registerForRemoteNotifications:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) delegate:self EID:EID profile:^(NSDictionary * dict) {

            //        NSLog(@"%@",dict);
        } successCompletion:^{

        } failedCompletion:^{

        }];
    }else {
        [CEFService createEIDwithTags:@[@"Beijing"] customId:@"storm" EID:^(NSString *EID) {

            [[NSUserDefaults standardUserDefaults]setObject:EID forKey:@"CUSTOM_EID"];

            [CEFService registerForRemoteNotifications:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) delegate:self EID:EID profile:^(NSDictionary * dict) {

                //        NSLog(@"%@",dict);
            } successCompletion:^{

            } failedCompletion:^{

            }];
        }];
    }

    
    [[SocialManager defaultManager] setPlaform:wechat appkey:URL_APPID appSecret:URL_SECRET redirectURL:nil];
    
    [[SocialManager defaultManager] setPlaform:weibo appkey:IFM_SinaAPPKey appSecret:IFM_SinaAppSecret redirectURL:@"http://www.baidu.com"];

    [[SocialManager defaultManager] setPlaform:QQ appkey:QQ_APPID appSecret:QQ_SECRET redirectURL:@"http://com.infomedia.p3kapp"];
    
    return YES;
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{

  
    return [[SocialManager defaultManager] handleOpenURL:url options:options];

    return YES;
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//    return [TencentOAuth HandleOpenURL:url];
//}
//
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
//    return [TencentOAuth HandleOpenURL:url];
//}


#pragma mark - iOS10 收到通知（本地和远端） UNUserNotificationCenterDelegate

//App处于前台接收通知时
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    UNNotificationRequest *request = notification.request;
    UNNotificationContent *content = request.content;
    [CEFService getContent:content];
    
    // 提醒用户，有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionAlert);
    
}


//App通知的点击事件
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    
    UNNotificationRequest *request = response.notification.request;
    UNNotificationContent *content = request.content;
    [CEFService getContent:content];
    
    completionHandler(); // 系统要求执行这个方法
}


#pragma mark -iOS 10之前收到通知

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"iOS6及以下系统，收到通知:%@", userInfo);
    //此处省略一万行需求代码。。。。。。
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"iOS7及以上系统，收到通知:%@", userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
    //此处省略一万行需求代码。。。。。。
}


#pragma  mark - 获取device Token
//获取DeviceToken成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    
    [CEFService registerDeviceToken:deviceToken profile:^(NSDictionary *profile) {
        NSLog(@"%@",profile);
    }];
    
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
    
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"PAYSUCCESS"]) {
            UIViewController *topmostVC = [self topViewController];
            UIStoryboard *PaymentSuccessPageStoryboard = [UIStoryboard storyboardWithName:@"PaymentSuccessPage" bundle:nil];
            PagementSuccessVC *paysuccessPage = [PaymentSuccessPageStoryboard instantiateInitialViewController];
            [topmostVC.navigationController pushViewController:paysuccessPage animated:YES];
        }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
@end

//
//  CEFNotificationManager.m
//  NotificationDemo
//
//  Created by zhangDongdong on 2018/4/8.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import "CEFNotificationManager.h"
#import "AppDelegate.h"

@implementation CEFNotificationManager

+(void)registerNotifications:(UNAuthorizationOptions)entity delegate:(id)delegate EID:(NSString *)EID successCompletion:(Completion)successCompletion failedCompletion:(Completion)failedCompletion{
    EId = EID;
    NSString *version = [UIDevice currentDevice].systemVersion;
    
    if (version.doubleValue >= 10.0) {
        //iOS 10 later
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //必须写代理，不然无法监听通知的接收与点击事件
        center.delegate = delegate;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error && granted) {
                //用户点击允许
                NSLog(@"注册成功");
                
                successCompletion();
            }else{
                //用户点击不允许
                NSLog(@"注册失败");
                failedCompletion();
            }
        }];
        
        // 可以通过 getNotificationSettingsWithCompletionHandler 获取权限设置
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSLog(@"========%@",settings);
        }];
    }else if (version.doubleValue >= 8.0){
        //iOS 8 - iOS 10系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:entity categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else{
        //iOS 8.0系统以下
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:entity];
    }
    
    //注册远端消息通知获取device token
    if ([NSThread isMainThread] ){
         [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        });
    }
}



+(void)registerDeviceToken:(NSData *)deviceToken profile:(Profile)profile{
    
    NSString *deviceString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceString = [deviceString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [self registerNotification:deviceString Profile:profile ];
}

+(void)registerNotification:(NSString *)deviceToken Profile:(Profile)profile{
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://cefsfcluster.chinanorth.cloudapp.chinacloudapi.cn/users/%@/serviceproviders/notification",EId]];
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *dictPramas = @{@"channel":@"Apns",
                                 @"properties":@{
                                         @"targetId":deviceToken
                                         }
                                 };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictPramas options:0 error:nil];
    request.HTTPBody = data;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        
        profile(dict);
    }];
    
    [sessionDataTask resume];
}

+(void)getContent:(UNNotificationContent *)content{
    
}


@end

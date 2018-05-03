//
//  PersonalProfile.m
//  Authentication
//
//  Created by zhangDongdong on 2018/4/26.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import "PersonalProfile.h"

@implementation PersonalProfile

-(void)uploadProfile{
    NSString *EID = [[NSUserDefaults standardUserDefaults] objectForKey:@"CUSTOM_EID"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://cefsfcluster.chinanorth.cloudapp.chinacloudapi.cn/users/%@/serviceproviders/authentication",EID]];
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *usernameFeild = [userDefaults objectForKey:@"USERNAME"];
    NSString *phonenumberFeild = [userDefaults objectForKey:@"PHONE"];
    NSString *emailFeild = [userDefaults objectForKey:@"EMAIL"];
    BOOL wechatLogin = [userDefaults boolForKey:@"WECHATLOGIN"];
    BOOL QQLogin = [userDefaults boolForKey:@"QQLOGIN"];
    
    NSString *socialProfile = @"";
    if (wechatLogin && QQLogin) {
        socialProfile = @"WeChat,QQ";
    }else if (wechatLogin && !QQLogin){
        socialProfile = @"WeChat";
    }else if (!wechatLogin && QQLogin){
        socialProfile = @"QQ";
    }
//    NSString *socialProfile = [userDefaults objectForKey:@"SOCIALPROFILE"];
    
    if (!emailFeild) {
        emailFeild = @"null";
    }
    if (!usernameFeild) {
        usernameFeild = @"null";
    }
    if (!phonenumberFeild) {
        phonenumberFeild = @"null";
    }
    
    NSString *homePath = NSHomeDirectory();
    NSString *weChatPath = [homePath stringByAppendingPathComponent:@"Library/Caches/wechat.archive"];
    NSArray *wechatArr = [NSKeyedUnarchiver unarchiveObjectWithFile:weChatPath];
    WechatProfile *wechatProfile = [[WechatProfile alloc]init];
    if (wechatArr.count) {
        wechatProfile = wechatArr[0];
    }
    
    NSString *QQPath = [homePath stringByAppendingPathComponent:@"Library/Caches/QQ.archive"];
    NSArray *QQArr = [NSKeyedUnarchiver unarchiveObjectWithFile:QQPath];
    QQProfile *qqProfile = [[QQProfile alloc]init];
    if (QQArr.count) {
        qqProfile = QQArr[0];
    }
    
    NSMutableDictionary *properties = [[NSMutableDictionary alloc]init];
    
    NSDictionary *personalDict = @{
                                   @"username":usernameFeild,
                                   @"phone":phonenumberFeild,
                                   @"email":emailFeild,
                                   @"socialProfile": socialProfile
                                   };
    
 
    
    [properties addEntriesFromDictionary:personalDict];
    
    if (wechatLogin && QQLogin) {
        if (wechatLogin) {
            
            [properties addEntriesFromDictionary:@{
                                                   @"WeChat.subscribe": @"1",
                                                   @"WeChat.openid": wechatProfile.openid,
                                                   @"WeChat.nickname": wechatProfile.nickname,
                                                   @"WeChat.sex": wechatProfile.sex,
                                                   @"WeChat.language": wechatProfile.language,
                                                   @"WeChat.city": wechatProfile.city,
                                                   @"WeChat.country": wechatProfile.country,
                                                   @"WeChat.province": wechatProfile.province,
                                                   }];
        }
        if (QQLogin) {
            
            [properties addEntriesFromDictionary:@{
                                                   @"QQ.year": qqProfile.year,
                                                   @"QQ.nickname": qqProfile.nickname,
                                                   @"QQ.sex": qqProfile.gender,
                                                   @"QQ.is_yellow_vip": qqProfile.is_yellow_vip,
                                                   @"QQ.city": qqProfile.city,
                                                   @"QQ.province": qqProfile.province,
                                                   }];
        }
    }else if (wechatLogin && !QQLogin){
        if (wechatLogin) {
            
            [properties addEntriesFromDictionary:@{
                                                   @"WeChat.subscribe": @"1",
                                                   @"WeChat.openid": wechatProfile.openid,
                                                   @"WeChat.nickname": wechatProfile.nickname,
                                                   @"WeChat.sex": wechatProfile.sex,
                                                   @"WeChat.language": wechatProfile.language,
                                                   @"WeChat.city": wechatProfile.city,
                                                   @"WeChat.country": wechatProfile.country,
                                                   @"WeChat.province": wechatProfile.province,
                                                   }];
        }
    }else if (!wechatLogin && QQLogin){
        if (QQLogin) {
            
            [properties addEntriesFromDictionary:@{
                                                   @"QQ.year": qqProfile.year,
                                                   @"QQ.nickname": qqProfile.nickname,
                                                   @"QQ.sex": qqProfile.gender,
                                                   @"QQ.is_yellow_vip": qqProfile.is_yellow_vip,
                                                   @"QQ.city": qqProfile.city,
                                                   @"QQ.province": qqProfile.province,
                                                   }];
        }
    }
    
    
    
    NSDictionary *dictPramas = @{@"channel":@"Any",
                                 @"properties":properties
                                     };
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictPramas options:0 error:nil];
    request.HTTPBody = data;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        NSLog(@"%@",dict);
        //        profile(dict);
    }];
    
    [sessionDataTask resume];
}


@end

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
    
    NSString *homePath = NSHomeDirectory();
    NSString *path = [homePath stringByAppendingPathComponent:@"Library/Caches/hehe.archive"];
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    WechatProfile *wechatProfile = [[WechatProfile alloc]init];
    if (arr.count) {
        wechatProfile = arr[0];
        NSLog(@"%@", wechatProfile.openid);
    }
    NSMutableDictionary *socialProfile = [[NSMutableDictionary alloc]init];
    NSDictionary *wechatDic = @{
                               @"subscribe": @"1",
                               @"openid": wechatProfile.openid,
                               @"nickname": wechatProfile.nickname,
                               @"sex": @"1",
                               @"language": wechatProfile.language,
                               @"city": wechatProfile.city,
                               @"country": wechatProfile.country,
                               @"province": wechatProfile.province,
                               };
//    [socialProfile setValue:wechatProfiledic forKey:@"wechat"];
    NSDictionary *dictPramas = @{@"channel":@"Any",
                                 @"properties":@{
                                         @"username":@"1",
                                         @"phone":@"1",
                                         @"email":@"1",
                                         @"socialProfile":@"WeiBo",
                                         @"Profile":@{
                                                 @"WeChat":wechatDic                                                 }
                                         }
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

//
//  WechatProfile.m
//  Authentication
//
//  Created by zhangDongdong on 2018/4/26.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import "WechatProfile.h"

@implementation WechatProfile

//"WeChat": {
//    "subscribe": "1",
//    "openid": "oLVPpjqs2BhvzwPj5A-vTYAX4GLc",
//    "nickname": "ciweibaobao",
//    "sex": "1",
//    "language": "zh_CN",
//    "city": "ShenZhen",
//    "province": "Gangdong",
//    "country": "China"
//},
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        NSLog(@"initWithCoder");
        _subscribe = [aDecoder decodeObjectForKey:@"Subscribe"];
        _openid = [aDecoder decodeObjectForKey:@"Openid"];
        _nickname = [aDecoder decodeObjectForKey:@"Nickname"];
        _sex = [aDecoder decodeObjectForKey:@"Sex"];
        _language = [aDecoder decodeObjectForKey:@"Language"];
        _city = [aDecoder decodeObjectForKey:@"City"];
        _province = [aDecoder decodeObjectForKey:@"Province"];
        _country = [aDecoder decodeObjectForKey:@"Country"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    NSLog(@"encodeWithCoder");
    [aCoder encodeObject:_subscribe forKey:@"Subscribe"];
    [aCoder encodeObject:_openid forKey:@"Openid"];
    [aCoder encodeObject:_nickname forKey:@"Nickname"];
    [aCoder encodeObject:_sex forKey:@"Sex"];
    [aCoder encodeObject:_language forKey:@"Language"];
    [aCoder encodeObject:_city forKey:@"City"];
    [aCoder encodeObject:_province forKey:@"Province"];
    [aCoder encodeObject:_country forKey:@"Country"];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end

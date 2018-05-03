//
//  QQProfile.m
//  Authentication
//
//  Created by zhangDongdong on 2018/4/26.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import "QQProfile.h"

@implementation QQProfile


//@property(strong,nonatomic)NSString *city;
//@property(strong,nonatomic)NSString *gender;
//@property(strong,nonatomic)NSString *nickname;
//@property(strong,nonatomic)NSString *year;
//@property(strong,nonatomic)NSString *province;
//@property(strong,nonatomic)NSString *is_yellow_vip;


- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        NSLog(@"initWithCoder");
        _gender = [aDecoder decodeObjectForKey:@"Gender"];
        _year = [aDecoder decodeObjectForKey:@"Year"];
        _nickname = [aDecoder decodeObjectForKey:@"Nickname"];
        _is_yellow_vip = [aDecoder decodeObjectForKey:@"Is_Yellow_Vip"];
        _city = [aDecoder decodeObjectForKey:@"City"];
        _province = [aDecoder decodeObjectForKey:@"Province"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    NSLog(@"encodeWithCoder");
    [aCoder encodeObject:_gender forKey:@"Gender"];
    [aCoder encodeObject:_year forKey:@"Year"];
    [aCoder encodeObject:_nickname forKey:@"Nickname"];
    [aCoder encodeObject:_is_yellow_vip forKey:@"Is_Yellow_Vip"];
    [aCoder encodeObject:_city forKey:@"City"];
    [aCoder encodeObject:_province forKey:@"Province"];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end

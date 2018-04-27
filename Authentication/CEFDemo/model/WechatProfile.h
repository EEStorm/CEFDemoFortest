//
//  WechatProfile.h
//  Authentication
//
//  Created by zhangDongdong on 2018/4/26.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WechatProfile : NSObject<NSCoding>

@property(strong,nonatomic)NSString *subscribe;
@property(strong,nonatomic)NSString *openid;
@property(strong,nonatomic)NSString *nickname;
@property(strong,nonatomic)NSString *sex;
@property(strong,nonatomic)NSString *language;
@property(strong,nonatomic)NSString *city;
@property(strong,nonatomic)NSString *province;
@property(strong,nonatomic)NSString *country;


@end

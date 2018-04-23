//
//  ShoppingListModel.h
//  CEFDemo
//
//  Created by zhangDongdong on 2018/4/20.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingListModel : NSObject

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *price;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)weiboModelWithDict:(NSDictionary *)dict;
@end

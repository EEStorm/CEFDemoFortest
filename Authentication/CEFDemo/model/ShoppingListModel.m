//
//  ShoppingListModel.m
//  CEFDemo
//
//  Created by zhangDongdong on 2018/4/20.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import "ShoppingListModel.h"

@implementation ShoppingListModel


- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)weiboModelWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end

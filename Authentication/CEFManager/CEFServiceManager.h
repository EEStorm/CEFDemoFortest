//
//  CEFServiceManager.h
//  Authentication
//
//  Created by zhangDongdong on 2018/5/10.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CEFServiceManager : NSObject

+(NSString *)createEIDwithTags:(NSArray*)tags customId:(NSString*)customId;

@end

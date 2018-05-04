//
//  CEFResponseonse.h
//  Authentication
//
//  Created by zhangDongdong on 2018/5/4.
//  Copyright © 2018年 micorosoft. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface CEFResponse : NSObject
/** 错误码 */
@property (nonatomic, assign) int errCode;
/** 错误提示字符串 */
@property (nonatomic, retain) NSString *errStr;
/** 响应类型 */
@property (nonatomic, assign) int type;
/** 平台类型 */
@property (nonatomic, assign) int channel;

@end


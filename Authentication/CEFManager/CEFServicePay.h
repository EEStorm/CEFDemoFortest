
#import <Foundation/Foundation.h>
#import "WXApi.h"

#define CEFPayManager [CEFServicePay defaultManager]

typedef NS_ENUM(NSInteger, CEFServicePayResult){
    CEFServicePayResultSuccess,// 成功
    CEFServicePayResultFailure,// 失败
    CEFServicePayResultCancel  // 取消
};

typedef enum {
    
    WeChat = 0,
    
    Alipay = 1
    
} Channel;

typedef void(^CEFServicePayResultCallBack)(CEFServicePayResult payResult, NSString *errorMessage);
typedef void(^CreateOrderCompletion)(NSString* prepayId,NSString* partnerid,NSString* noncestr,NSString* timestamp,NSString* sign);

@interface CEFServicePay : NSObject

@property(nonatomic,copy)CreateOrderCompletion createOrderCompletion;
@property(nonatomic,assign)BOOL wechatPayEnable;
@property(nonatomic,assign)BOOL aliPayEnable;
@property(nonatomic,assign)BOOL unionPayEnable;

+ (instancetype)defaultManager;

- (void)registerPaymentWithEID:(NSString *)EID;

- (void)CEFServicePayWithEID:(NSString *)EID channel:(Channel)channel subject:(NSString *)subject tradeNumber:(NSString *)tradeNumber amount:(NSString *) amount callBack:(CEFServicePayResultCallBack)callBack;

@end

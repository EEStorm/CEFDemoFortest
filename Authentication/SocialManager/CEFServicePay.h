
#import <Foundation/Foundation.h>
#import "WXApi.h"

#define CEFPayManager [CEFServicePay defaultManager]

/**
 支付成功回调状态码
 */
typedef NS_ENUM(NSInteger, CEFServicePayResult){
    CEFServicePayResultSuccess,// 成功
    CEFServicePayResultFailure,// 失败
    CEFServicePayResultCancel  // 取消
};

typedef void(^CEFServicePayResultCallBack)(CEFServicePayResult payResult, NSString *errorMessage);
typedef void(^CreateOrderCompletion)(NSString*);

@interface CEFServicePay : NSObject

@property(nonatomic,copy)CreateOrderCompletion createOrderCompletion;
@property(nonatomic,assign)BOOL wechatPayEnable;
@property(nonatomic,assign)BOOL aliPayEnable;
@property(nonatomic,assign)BOOL unionPayEnable;

+ (instancetype)defaultManager;

/**
 *  处理跳转url，回到应用，需要在delegate中实现
 */
- (BOOL)handleOpenURL:(NSURL *)url;

/**
 注册微信支持开发者AppID并且保存支付宝的URLSchemes，需要在 didFinishLaunchingWithOptions 中调用
 */
- (void)registerPayment;

/**
 发起支付

 @param order 传入订单信息,如果是字符串，则对应是跳转支付宝支付；如果传入PayReq 对象，这跳转微信支付,注意，不能传入空字符串或者nil
 @param callBack 回调，有返回状态信息
 */
- (void)CEFServicePayWithOrder:(id)order callBack:(CEFServicePayResultCallBack)callBack;


- (void)requestOrderPrepayId:(NSString *)EID createOrderCompletion:(CreateOrderCompletion) createOrder;
@end

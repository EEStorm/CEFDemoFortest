
#import "CEFServicePay.h"

#import <CommonCrypto/CommonDigest.h>
/**
 *  此处必须保证在Info.plist 中的 URL Types 的 Identifier 对应一致
 */
#define WeChat_URLTypesIdentifier @"wechatpay"
#define Alipay_URLTypesIdentifier @"alipay"

// 回调url地址为空
#define callBackURL @"url地址不能为空！"

// 订单信息为空字符串或者nil
#define orderMessage_nil @"订单信息不能为空！"
// 没添加 URL Types
#define addURLTypes @"请先在Info.plist 添加 URLTypes"
// 添加了 URL Types 但信息不全
#define addURLSchemes(URLTypes) [NSString stringWithFormat:@"请先在Info.plist对应的 URLTypes 添加 %@ 对应的 URL Schemes", URLTypes]

@interface CEFServicePay () <WXApiDelegate>

// 支付结果缓存回调
@property (nonatomic, copy) CEFServicePayResultCallBack callBack;
// 保存URL_Schemes到字典里面
@property (nonatomic, strong) NSMutableDictionary *URL_Schemes_Dic;

@end

@implementation CEFServicePay


+ (instancetype)defaultManager {
    static CEFServicePay *CEFServicePay;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CEFServicePay = [[self alloc] init];
    });
    return CEFServicePay;
}

- (BOOL)handleOpenURL:(NSURL *)url {
    
    NSAssert(url, callBackURL);
    if ([url.host isEqualToString:@"pay"]) {// 微信
        return [WXApi handleOpenURL:url delegate:self];
    }
    else{
        return NO;
    }
}

- (void)registerPaymentWithEID:(NSString *)EID {
    NSString *Info_plist_path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *Info_plist_dic = [NSDictionary dictionaryWithContentsOfFile:Info_plist_path];
    NSArray *URL_Types_Array = Info_plist_dic[@"CFBundleURLTypes"];
    NSAssert(URL_Types_Array, addURLTypes);
    [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"PAYSUCCESS"];
    for (NSDictionary *URL_Type_Dic in URL_Types_Array) {
        NSString *URL_Name = URL_Type_Dic[@"CFBundleURLName"];
        NSArray *URL_Schemes_Array = URL_Type_Dic[@"CFBundleURLSchemes"];
        NSAssert(URL_Schemes_Array.count, addURLSchemes(URL_Name));
        NSString *URL_Schemes = URL_Schemes_Array.lastObject;
        
        if ([URL_Name isEqualToString:WeChat_URLTypesIdentifier]) {//微信支付
            [self.URL_Schemes_Dic setValue:URL_Schemes forKey:WeChat_URLTypesIdentifier];
            NSLog(@"WeChat_URL_Schemes=appid 微信开发者ID= %@", URL_Schemes);
            [WXApi registerApp:URL_Schemes];
            
        } else if ([URL_Name isEqualToString:Alipay_URLTypesIdentifier]){//支付宝
            NSLog(@"Alipay_URL_Schemes= %@", URL_Schemes);
            [self.URL_Schemes_Dic setValue:URL_Schemes forKey:Alipay_URLTypesIdentifier];
            
        } else{
            
        }
    }
}

- (void)CEFServicePayWithOrder:(id)order callBack:(CEFServicePayResultCallBack)callBack {
    NSAssert(order, orderMessage_nil);
    
    self.callBack = callBack;
    
    if ([order isKindOfClass:[PayReq class]]) {
        
        NSAssert(self.URL_Schemes_Dic[WeChat_URLTypesIdentifier], addURLSchemes(WeChat_URLTypesIdentifier));
        
        [WXApi sendReq:(PayReq *)order];
    }
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
//    
//    CEFResp *cefresp = [[CEFResp alloc]init];
//    cefresp.errCode = resp.errCode;
//    cefresp.errStr = resp.errStr;
//    cefresp.type = resp.type;
//    [CEFSocialManager.CEFApiDel onResopnse:cefresp];
    
    if([resp isKindOfClass:[PayResp class]]){
        
        CEFServicePayResult errorCode = CEFServicePayResultSuccess;
        NSString *errStr = resp.errStr;
        switch (resp.errCode) {
            case 0:
                errorCode = CEFServicePayResultSuccess;
                errStr = @"订单支付成功";
                [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"PAYSUCCESS"];
                [self paySuccess];
                break;
            case -1:
                errorCode = CEFServicePayResultFailure;
                errStr = resp.errStr;
                break;
            case -2:
                errorCode = CEFServicePayResultCancel;
                errStr = @"用户中途取消";
                break;
            default:
                errorCode = CEFServicePayResultFailure;
                errStr = resp.errStr;
                break;
        }
        if (self.callBack) {
            self.callBack(errorCode,errStr);
        }
    }
}

-(void)paySuccess{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://cefsfcluster.chinanorth.cloudapp.chinacloudapi.cn/mock/sendsms"]];
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *msg = [NSString stringWithFormat:@"支付成功，您消费了 0.01 元"];
    
    NSString *phone = [[NSUserDefaults standardUserDefaults]objectForKey:@"PHONE"];
    NSDictionary *dictPramas = @{@"mobile":phone,
                                 @"msg":msg
                                 };
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictPramas options:0 error:nil];
    request.HTTPBody = data;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        NSLog(@"%@",dict);
    }];
    [sessionDataTask resume];
}

-(void)CEFServicePayWithEID:(NSString *)EID channel:(Channel)channel subject:(NSString *)subject tradeNumber:(NSString *)tradeNumber amount:(NSString *)amount callBack:(CEFServicePayResultCallBack)callBack{
    
    self.callBack = callBack;
    
    [CEFPayManager requestOrderPrepayId: EID channel:channel subject:subject tradeNumber:tradeNumber amount:amount createOrderCompletion:^(NSString *prepayId,NSString* partnerid,NSString* noncestr,NSString* timestamp,NSString* sign) {
        
        
        PayReq *req = [[PayReq alloc] init];
        req.partnerId = partnerid;
        req.prepayId= prepayId;
        req.package = @"Sign=WXPay";
        req.nonceStr= noncestr;
        req.timeStamp= timestamp.intValue;
  
        req.sign= sign;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [CEFPayManager CEFServicePayWithOrder:req callBack:callBack];
        });
    }];
}


-(void)requestOrderPrepayId:(NSString *)EID channel:(Channel)channel subject:(NSString *)subject tradeNumber:(NSString *)tradeNumber amount:(NSString *) amount createOrderCompletion:(CreateOrderCompletion)createOrder{
   
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://xzshengpaymentstaging.eastasia.cloudapp.azure.com/serviceProviders/payment/createOrder"]];
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *dictPramas = @{@"eid":EID,
                                 @"channel":@"WeChat",
                                 @"subject":subject,
                                 @"tradeNumber":tradeNumber,
                                 @"amount":amount
                                 };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictPramas options:0 error:nil];
    request.HTTPBody = data;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];

        NSDictionary *properties = (NSDictionary *)[dict objectForKey:@"properties"];
        
        NSString *prepayId = [properties objectForKey:@"prepayid"];
        NSString *partnerid = [properties objectForKey:@"partnerid"];
        NSString *noncestr = [properties objectForKey:@"noncestr"];
        NSString *timestamp = [properties objectForKey:@"timestamp"];
        NSString *sign = [properties objectForKey:@"sign"];
//        NSString *orderId = [properties objectForKey:@"orderId"];
        createOrder(prepayId,partnerid,noncestr,timestamp,sign);
        NSLog(@"%@",prepayId);
        
        
        [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"PAYSUCCESS"];
    }];
    [sessionDataTask resume];
    
}
#pragma mark -- Setter & Getter

- (NSMutableDictionary *)URL_Schemes_Dic {
    if (_URL_Schemes_Dic == nil) {
        _URL_Schemes_Dic = [NSMutableDictionary dictionary];
    }
    return _URL_Schemes_Dic;
}

@end

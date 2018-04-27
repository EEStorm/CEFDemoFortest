
#import "XLsn0wPay.h"
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

@interface XLsn0wPay () <WXApiDelegate>

// 支付结果缓存回调
@property (nonatomic, copy) XLsn0wPayResultCallBack callBack;
// 保存URL_Schemes到字典里面
@property (nonatomic, strong) NSMutableDictionary *URL_Schemes_Dic;

@end

@implementation XLsn0wPay


+ (instancetype)defaultManager {
    static XLsn0wPay *xlsn0wPay;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        xlsn0wPay = [[self alloc] init];
    });
    return xlsn0wPay;
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

- (void)registerPayment {
    NSString *Info_plist_path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *Info_plist_dic = [NSDictionary dictionaryWithContentsOfFile:Info_plist_path];
    NSArray *URL_Types_Array = Info_plist_dic[@"CFBundleURLTypes"];
    NSAssert(URL_Types_Array, addURLTypes);
    [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"PAYSUCCESS"];
    for (NSDictionary *URL_Type_Dic in URL_Types_Array) {
        NSString *URL_Name = URL_Type_Dic[@"CFBundleURLName"];
        NSArray *URL_Schemes_Array = URL_Type_Dic[@"CFBundleURLSchemes"];
        NSAssert(URL_Schemes_Array.count, addURLSchemes(URL_Name));
        // 一般对应只有一个
        NSString *URL_Schemes = URL_Schemes_Array.lastObject;
        
        if ([URL_Name isEqualToString:WeChat_URLTypesIdentifier]) {//微信支付
            [self.URL_Schemes_Dic setValue:URL_Schemes forKey:WeChat_URLTypesIdentifier];
            // 注册微信 appid 微信开发者ID即 WeChat URL Schemes
            NSLog(@"WeChat_URL_Schemes=appid 微信开发者ID= %@", URL_Schemes);
            [WXApi registerApp:@"wxa186d3f0aa51c56e"];
            
        } else if ([URL_Name isEqualToString:Alipay_URLTypesIdentifier]){//支付宝
            // 保存支付宝scheme，以便发起支付使用
            //注意：这里的URL Schemes，在实际商户的app中要填写独立的scheme，建议跟商户的app有一定的标示度，
            //要做到和其他的商户app不重复，否则可能会导致支付宝返回的结果无法正确跳回商户app。
            NSLog(@"Alipay_URL_Schemes= %@", URL_Schemes);
            [self.URL_Schemes_Dic setValue:URL_Schemes forKey:Alipay_URLTypesIdentifier];
            
        } else{
            
        }
    }
}

- (void)xlsn0wPayWithOrder:(id)order callBack:(XLsn0wPayResultCallBack)callBack {
    NSAssert(order, orderMessage_nil);
    // 缓存block
    self.callBack = callBack;
    // 发起支付
    if ([order isKindOfClass:[PayReq class]]) {
        // 微信
        NSAssert(self.URL_Schemes_Dic[WeChat_URLTypesIdentifier], addURLSchemes(WeChat_URLTypesIdentifier));
        
        [WXApi sendReq:(PayReq *)order];
    }
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    // 判断支付类型
    if([resp isKindOfClass:[PayResp class]]){
        //支付回调
        XLsn0wPayResult errorCode = XLsn0wPayResultSuccess;
        NSString *errStr = resp.errStr;
        switch (resp.errCode) {
            case 0:
                errorCode = XLsn0wPayResultSuccess;
                errStr = @"订单支付成功";
                [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"PAYSUCCESS"];
                break;
            case -1:
                errorCode = XLsn0wPayResultFailure;
                errStr = resp.errStr;
                break;
            case -2:
                errorCode = XLsn0wPayResultCancel;
                errStr = @"用户中途取消";
                [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"PAYSUCCESS"];
                break;
            default:
                errorCode = XLsn0wPayResultFailure;
                errStr = resp.errStr;
                break;
        }
        if (self.callBack) {
            self.callBack(errorCode,errStr);
        }
    }
}

-(void)requestOrderPrepayId:(NSString *)EID createOrderCompletion:(CreateOrderCompletion)createOrder{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://xzshengpaymentdev.eastasia.cloudapp.azure.com/serviceProviders/payment/createOrder"]];
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *dictPramas = @{@"eid":EID,
                                 @"channel":@"WeChat",
                                 @"subject":@"Test",
                                 @"tradeNumber":@"DevTradeNumber001",
                                 @"amount":@"1",
                                 @"notifyUrl":@"https://xzshengwebhookwatcher.azurewebsites.net/api/weChatPaymentWebhook"
                                 };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictPramas options:0 error:nil];
    request.HTTPBody = data;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
//        EID = (NSString *)[dict objectForKey:@"eid"];
//        eidStr(EID);
        NSDictionary *properties = (NSDictionary *)[dict objectForKey:@"properties"];
        NSString *prepayId = [properties objectForKey:@"prepayId"];
        createOrder(prepayId);
        NSLog(@"%@",prepayId);
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

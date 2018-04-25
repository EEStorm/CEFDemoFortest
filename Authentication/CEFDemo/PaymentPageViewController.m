//
//  PaymentPageViewController.m
//  Authentication
//
//  Created by zhangDongdong on 2018/4/23.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import "PaymentPageViewController.h"
#import <CommonCrypto/CommonDigest.h>

@interface PaymentPageViewController ()
@property (weak, nonatomic) IBOutlet UIView *wexinpay;

@end

@implementation PaymentPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = true;
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wechatPay:)];
    [self.view addGestureRecognizer:tapGesture];
}

-(void)wechatPay:(UITapGestureRecognizer *)gesture{
    PayReq *req = [[PayReq alloc] init];
    req.partnerId = @"1502289851";
    req.prepayId= @"wx251339043342975af9ddb8af3100473921";
    req.package = @"Sign=WXPay";
    req.nonceStr= @"5K8264ILTKCH16CQ2502SI8ZNMTM67VS";
    req.timeStamp= @"1412000000".intValue;
    
    NSString *signStr = [NSString stringWithFormat:@"appid=wxa186d3f0aa51c56e&noncestr=5K8264ILTKCH16CQ2502SI8ZNMTM67VS&package=Sign=WXPay&partnerid=1502289851&prepayid=%@&timestamp=1412000000&key=cefacedjfioakckjguqnqk91701dadj1",@"wx251339043342975af9ddb8af3100473921"];
    NSString *sign = [self md5:signStr];
    
    req.sign= sign;
    [CEFPayManager xlsn0wPayWithOrder:req callBack:^(XLsn0wPayResult payResult, NSString *errorMessage) {
        NSLog(@"errCode = %zd,errStr = %@",payResult, errorMessage);
    }];
}


-(NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    //加密规则，因为逗比微信没有出微信支付demo，这里加密规则是参照安卓demo来得
    unsigned char result[16]= "0123456789abcdef";
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    //这里的x是小写则产生的md5也是小写，x是大写则md5是大写，这里只能用大写，逗比微信的大小写验证很逗
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

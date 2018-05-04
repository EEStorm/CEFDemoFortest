//
//  PaymentPageViewController.m
//  Authentication
//
//  Created by zhangDongdong on 2018/4/23.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import "PaymentPageViewController.h"
#import "PagementSuccessVC.h"

@interface PaymentPageViewController ()
@property (weak, nonatomic) IBOutlet UIView *wexinpay;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unionPayConstant;
@property (weak, nonatomic) IBOutlet UIView *alipayView;
@property (weak, nonatomic) IBOutlet UIView *unionPayView;
@property (nonatomic,assign)NSInteger paylistCount;
@end

@implementation PaymentPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setupUI];
}

-(void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = true;
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wechatPay:)];
    [self.wexinpay addGestureRecognizer:tapGesture];
}

-(void)wechatPay:(UITapGestureRecognizer *)gesture{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    NSString *EID = [[NSUserDefaults standardUserDefaults] objectForKey:@"CUSTOM_EID"];
    
    [CEFPayManager CEFServicePayWithEID:EID
                                channel:WeChat
                                subject:@"Test"
                            tradeNumber:@"DevTradeNumber001"
                                 amount:@"1"
                              notifyUrl:@"https://xzshengwebhookwatcher.azurewebsites.net/api/weChatPaymentWebhook"
                               callBack:^(CEFServicePayResult payResult, NSString *errorMessage) {
                                   
                                   NSLog(@"errCode = %zd,errStr = %@",payResult, errorMessage);

                                   // UI
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [hud hideAnimated:YES];
                                   });
        
    }];
}




@end

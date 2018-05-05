

//
//  ViewController.m
//  CEFDemo
//
//  Created by zhangDongdong on 2018/4/19.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "ShoppingListViewController.h"
#import "CompleteProfileController.h"
#import "MBProgressHUD.h"
#import "PersonalProfile.h"

#define SHColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface ViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIView *registerView;
@property (weak, nonatomic) IBOutlet UIButton *topLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *topRegisterBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginView_loginBtnClick;
@property (weak, nonatomic) IBOutlet UITextField *loginView_phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *loginView_password;


@property (weak, nonatomic) IBOutlet UITextField *registerView_phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *registerView_verificationCode;
@property (weak, nonatomic) IBOutlet UITextField *registerView_password;
@property (weak, nonatomic) IBOutlet UITextField *registerView_comfirmPassword;
@property (weak, nonatomic) IBOutlet UIButton *registerView_registerBtnClick;

@end

@implementation ViewController

- (IBAction)loginBtnClick:(id)sender {
    [self clickLoginBtn];
}

- (IBAction)registerBtnClick:(id)sender {
    self.loginView.hidden = true;
    self.registerView.hidden = false;
    self.topLoginBtn.tintColor = [UIColor lightGrayColor];
    self.topRegisterBtn.tintColor = [UIColor blueColor];
    
    self.loginView_phoneNumber.text = @"";
    self.loginView_password.text = @"";
    
    self.loginView_loginBtnClick.backgroundColor = [UIColor lightGrayColor];
    self.loginView_loginBtnClick.enabled = false;
}

- (IBAction)loginViewBtnClick:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"USER"];
    NSString *password = [defaults objectForKey:@"PASSWORD"];
    
    if ([username isEqualToString:self.loginView_phoneNumber.text] && [password isEqualToString:self.loginView_password.text]) {
        
        ShoppingListViewController *shoppingVC = [[ShoppingListViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:shoppingVC];
        
        AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        UIViewController *vc = app.window.rootViewController;
        app.window.rootViewController = nav;
        [vc removeFromParentViewController];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"账号或密码错误";
        hud.offset = CGPointMake(0.f, 100);
        [hud hideAnimated:YES afterDelay:2.f];
    }
    
    
}
- (IBAction)registerViewBtnClick:(id)sender {
    
    if ([self.registerView_password.text isEqualToString:self.registerView_comfirmPassword.text]) {
        
        [[NSUserDefaults standardUserDefaults]setObject:self.registerView_phoneNumber.text forKey:@"PHONE"];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"NICKNAME"] == nil) {
            
            [[NSUserDefaults standardUserDefaults]setObject:self.registerView_phoneNumber.text forKey:@"NICKNAME"];
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *phoneNum = self.registerView_phoneNumber.text;
        NSString *password = self.registerView_password.text;
        BOOL islogin = [defaults boolForKey:@"ISLOGIN"];
        
        [defaults setObject:phoneNum forKey:@"USER"];
        [defaults setObject:password forKey:@"PASSWORD"];
        
        if (islogin) {
            
            ShoppingListViewController *shoppingVC = [[ShoppingListViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:shoppingVC];
            
            AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
            UIViewController *vc = app.window.rootViewController;
            app.window.rootViewController = nav;
            [vc removeFromParentViewController];
        }else {
            
            UIStoryboard *CompleteStoryboard = [UIStoryboard storyboardWithName:@"CompleteProfile" bundle:nil];
            CompleteProfileController *profileController = [CompleteStoryboard instantiateInitialViewController];
            profileController.type = @"phone";
            [self presentViewController:profileController animated:0.3 completion:^{
                [self clickLoginBtn];
            }];
            
        }
    }else {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"输入密码不一致";
        hud.offset = CGPointMake(0.f, 100);
        [hud hideAnimated:YES afterDelay:2.f];

    }
}

- (IBAction)pushMessage:(id)sender {

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://cefsfcluster.chinanorth.cloudapp.chinacloudapi.cn/mock/sendsms"]];
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    int randomStr = 1000 +  (arc4random() % 101);
    NSString *msg = [NSString stringWithFormat:@"您的短信验证码是 %d",randomStr];
    NSString *phone = @"";
    if (![self.registerView_phoneNumber.text isEqual:@""]) {
        phone = self.registerView_phoneNumber.text;
    }
    NSDictionary *dictPramas = @{@"mobile":phone,
                                 @"msg":msg
                                 };
    
    [[NSUserDefaults standardUserDefaults]setInteger:randomStr forKey:@"RANDOMSTR"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictPramas options:0 error:nil];
    request.HTTPBody = data;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        NSLog(@"%@",dict);
    }];
    [sessionDataTask resume];

}






- (IBAction)weixinLogin:(id)sender {
    
    [[CEFSocialService defaultManager]loginWithPlatform:wechat completion:^(NSDictionary *result, NSInteger *error) {

         NSLog(@"%@",result);
        
        [self presentCompleteVC:@"weixin"];
    }];
}

- (IBAction)QQLogin:(id)sender {
   
    [[CEFSocialService defaultManager]loginWithPlatform:QQ completion:^(NSDictionary *result, NSInteger *error) {

        NSLog(@"%@",result);
        
        [self presentCompleteVC:@"QQ"];

    }];
}


- (IBAction)weiboLogin:(id)sender {
    
    [[CEFSocialService defaultManager]loginWithPlatform:weibo completion:^(NSDictionary *result, NSInteger *error) {
        
        NSLog(@"%@",result);
        
        [self presentCompleteVC:@"weibo"];
    }];
}



-(void)presentCompleteVC:(NSString *)type {
    
    BOOL islogin = [[NSUserDefaults standardUserDefaults]boolForKey:@"ISLOGIN"];
    
    if (islogin) {
        
        ShoppingListViewController *shoppingVC = [[ShoppingListViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:shoppingVC];
        
        AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        UIViewController *vc = app.window.rootViewController;
        app.window.rootViewController = nav;
        [vc removeFromParentViewController];
        
        PersonalProfile *personalProfile = [[PersonalProfile alloc]init];
        [personalProfile uploadProfile];
    }else {
        [[NSUserDefaults standardUserDefaults]setObject:self.registerView_phoneNumber.text forKey:@"PHONE"];
        UIStoryboard *CompleteStoryboard = [UIStoryboard storyboardWithName:@"CompleteProfile" bundle:nil];
        
        CompleteProfileController *profileController = [CompleteStoryboard instantiateInitialViewController];
        profileController.type = type;
        [self presentViewController:profileController animated:0.3 completion:^{
            [self clickLoginBtn];
        }];
    }
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setUpUI];
    
    [self registerDelegate];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    self.registerView_registerBtnClick.enabled = false;
    self.loginView_loginBtnClick.enabled = false;
}

-(void)viewDidDisappear:(BOOL)animated {
    [self.navigationController.view bringSubviewToFront:self.navigationController.navigationBar];
}
-(void)registerDelegate{
    
    self.loginView_phoneNumber.delegate = self;
    self.loginView_password.delegate = self;
    
    self.registerView_phoneNumber.delegate = self;
    self.registerView_verificationCode.delegate = self;
    self.registerView_password.delegate = self;
    self.registerView_comfirmPassword.delegate = self;
}


-(void)setUpUI {
    self.loginView.hidden = false;
    self.registerView.hidden = true;
    self.topLoginBtn.tintColor = [UIColor blueColor];
    self.topRegisterBtn.tintColor = [UIColor lightGrayColor];
    self.loginView_loginBtnClick.backgroundColor = [UIColor lightGrayColor];
    self.loginView_loginBtnClick.enabled = false;
    
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFeild:)];
    [self.view addGestureRecognizer:tapGesture];
}

-(void)resignFeild:(UITapGestureRecognizer *)gesture{
    [self.loginView_phoneNumber resignFirstResponder];
    [self.loginView_password resignFirstResponder];
    
    [self.registerView_phoneNumber resignFirstResponder];
    [self.registerView_verificationCode resignFirstResponder];
    [self.registerView_password resignFirstResponder];
    [self.registerView_comfirmPassword resignFirstResponder];
}

-(void)clickLoginBtn{
    
    self.loginView.hidden = false;
    self.registerView.hidden = true;
    self.topLoginBtn.tintColor = [UIColor blueColor];
    self.topRegisterBtn.tintColor = [UIColor lightGrayColor];
    
    self.registerView_phoneNumber.text = @"";
    self.registerView_verificationCode.text = @"";
    self.registerView_password.text = @"";
    self.registerView_comfirmPassword.text = @"";
    
    self.registerView_registerBtnClick.backgroundColor = [UIColor lightGrayColor];
    self.registerView_registerBtnClick.enabled = false;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 1 || textField.tag == 2) {
        if (![self.loginView_phoneNumber.text  isEqual: @""] && ![self.loginView_password.text  isEqual: @""]) {
            self.loginView_loginBtnClick.backgroundColor = SHColor(12,126,216);
            self.loginView_loginBtnClick.enabled = true;
        }else {
            self.loginView_loginBtnClick.backgroundColor = [UIColor lightGrayColor];
            self.loginView_loginBtnClick.enabled = false;
        }
    }else {
        if (![self.registerView_phoneNumber.text isEqual:@""]
            && ![self.registerView_verificationCode.text isEqual:@""]
            && ![self.registerView_password.text isEqual:@""]
            && ![self.registerView_comfirmPassword.text isEqual:@""]) {
            self.registerView_registerBtnClick.backgroundColor = SHColor(12, 126, 216);
            self.registerView_registerBtnClick.enabled = true;
        }else {
            self.registerView_registerBtnClick.backgroundColor = [UIColor lightGrayColor];
            self.registerView_registerBtnClick.enabled = false;
        }
    }
    return true;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.loginView_phoneNumber resignFirstResponder ];
    [self.loginView_password resignFirstResponder ];
    [self.registerView_password resignFirstResponder ];
    [self.registerView_phoneNumber resignFirstResponder ];
    [self.registerView_verificationCode resignFirstResponder ];
    [self.registerView_comfirmPassword resignFirstResponder ];
    return true;
}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if (textField.tag == 1 || textField.tag == 2) {
        if (![self.loginView_phoneNumber.text  isEqual: @""] && ![self.loginView_password.text  isEqual: @""]) {
            self.loginView_loginBtnClick.backgroundColor = SHColor(12,126,216);
            self.loginView_loginBtnClick.enabled = true;
        }else {
            self.loginView_loginBtnClick.backgroundColor = [UIColor lightGrayColor];
            self.loginView_loginBtnClick.enabled = false;
        }
    }else {
        if (![self.registerView_phoneNumber.text isEqual:@""]
            && ![self.registerView_verificationCode.text isEqual:@""]
            && ![self.registerView_password.text isEqual:@""]
            && ![self.registerView_comfirmPassword.text isEqual:@""]) {
            self.registerView_registerBtnClick.backgroundColor = SHColor(12, 126, 216);
            self.registerView_registerBtnClick.enabled = true;
        }else {
            self.registerView_registerBtnClick.backgroundColor = [UIColor lightGrayColor];
            self.registerView_registerBtnClick.enabled = false;
        }
    }
    return true;
}



@end



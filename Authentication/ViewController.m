

//
//  ViewController.m
//  CEFDemo
//
//  Created by zhangDongdong on 2018/4/19.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import "ViewController.h"
#import "ShoppingListViewController.h"
#import "CompleteProfileController.h"

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
    ShoppingListViewController *shoppingVC = [[ShoppingListViewController alloc]init];
    [self.navigationController pushViewController:shoppingVC animated:true];
    
}
- (IBAction)registerViewBtnClick:(id)sender {
    
    ShoppingListViewController *shoppingVC = [[ShoppingListViewController alloc]init];
    [self.navigationController pushViewController:shoppingVC animated:true];
}
- (IBAction)weixinLogin:(id)sender {
    
    [[SocialManager defaultManager]getUserInfoWithPlatform:wechat completion:^(NSDictionary *result, NSInteger *error) {

         NSLog(@"%@",result);
        [self presentCompleteVC:@"weixin"];
    }];
}

- (IBAction)QQLogin:(id)sender {
   
    [[SocialManager defaultManager]getUserInfoWithPlatform:QQ completion:^(NSDictionary *result, NSInteger *error) {

        NSLog(@"%@",result);
        [self presentCompleteVC:@"QQ"];

    }];
}


- (IBAction)weiboLogin:(id)sender {
    
    [[SocialManager defaultManager]getUserInfoWithPlatform:weibo completion:^(NSDictionary *result, NSInteger *error) {
        
        NSLog(@"%@",result);
        [self presentCompleteVC:@"weibo"];
    }];
}



-(void)presentCompleteVC:(NSString *)type {
    
    UIStoryboard *CompleteStoryboard = [UIStoryboard storyboardWithName:@"CompleteProfile" bundle:nil];
    CompleteProfileController *profileController = [CompleteStoryboard instantiateInitialViewController];
    profileController.type = type;
    [self presentViewController:profileController animated:0.3 completion:^{
        [self clickLoginBtn];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setUpUI];
    
    [self registerDelegate];
}
-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    
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
    self.registerView_registerBtnClick.enabled = true;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end



//
//  CompleteProfileController.m
//  CEFDemo
//
//  Created by zhangDongdong on 2018/4/19.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import "CompleteProfileController.h"
#import "CEFNotificationManager.h"
#import "AppDelegate.h"
#import "ShoppingListViewController.h"
#import "PersonalProfile.h"

@interface CompleteProfileController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameFeild;
@property (weak, nonatomic) IBOutlet UITextField *phonenumberFeild;
@property (weak, nonatomic) IBOutlet UITextField *emailFeild;
@property (weak, nonatomic) IBOutlet UITextField *sexFeild;
@property (weak, nonatomic) IBOutlet UITextField *cityFeild;

@end

@implementation CompleteProfileController


- (IBAction)completeBtnClick:(id)sender {
    
    [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"ISLOGIN"];
    [[NSUserDefaults standardUserDefaults]setObject:self.usernameFeild.text forKey:@"USERNAME"];
    [[NSUserDefaults standardUserDefaults]setObject:self.phonenumberFeild.text forKey:@"PHONE"];
    [[NSUserDefaults standardUserDefaults]setObject:self.emailFeild.text forKey:@"EMAIL"];
    
    
    [[NSUserDefaults standardUserDefaults]setObject:self.usernameFeild.text forKey:@"CEFNICKNAME"];
    
    
    PersonalProfile *personalProfile = [[PersonalProfile alloc]init];
    [personalProfile uploadProfile];
    
    [self dismissViewControllerAnimated:true completion:^{
        ShoppingListViewController *shoppingVC = [[ShoppingListViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:shoppingVC];
        
        AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        UIViewController *vc = app.window.rootViewController;
        app.window.rootViewController = nav;
        [vc removeFromParentViewController];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFeild:)];
    [self.view addGestureRecognizer:tapGesture];
    
    NSString *phone = [[NSUserDefaults standardUserDefaults]objectForKey:@"PHONE"];
    if (![phone isEqual:@""]) {
        self.phonenumberFeild.text = phone;
    }
    
    self.usernameFeild.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"NICKNAME"];
    
}

-(void)resignFeild:(UITapGestureRecognizer *)gesture{
    [self.usernameFeild resignFirstResponder];
    [self.phonenumberFeild resignFirstResponder];
    
    [self.emailFeild resignFirstResponder];
    [self.cityFeild resignFirstResponder];
    [self.sexFeild resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  CompleteProfileController.m
//  CEFDemo
//
//  Created by zhangDongdong on 2018/4/19.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import "CompleteProfileController.h"
#import "CEFService.h"

@interface CompleteProfileController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameFeild;
@property (weak, nonatomic) IBOutlet UITextField *phonenumberFeild;
@property (weak, nonatomic) IBOutlet UITextField *emailFeild;

@end

@implementation CompleteProfileController


- (IBAction)completeBtnClick:(id)sender {
    
    
    NSString *EID = [[NSUserDefaults standardUserDefaults] objectForKey:@"CUSTOM_EID"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://cefsfcluster.chinanorth.cloudapp.chinacloudapi.cn/users/%@/serviceproviders/authentication",EID]];
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *dictPramas = @{@"channel":@"Any",
                                 @"properties":@{
                                                @"username":self.usernameFeild.text,
                                                @"phone":self.phonenumberFeild.text,
                                                @"email":self.emailFeild.text,
                                                @"socialProfile":self.type
                                                }
                                 };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictPramas options:0 error:nil];
    request.HTTPBody = data;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        NSLog(@"%@",dict);
//        profile(dict);
    }];
    
    [sessionDataTask resume];
    
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

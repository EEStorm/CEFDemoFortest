//
//  CompleteProfileController.m
//  CEFDemo
//
//  Created by zhangDongdong on 2018/4/19.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import "CompleteProfileController.h"

@interface CompleteProfileController ()

@end

@implementation CompleteProfileController


- (IBAction)completeBtnClick:(id)sender {
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

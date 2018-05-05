//
//  PagementSuccessVC.m
//  Authentication
//
//  Created by zhangDongdong on 2018/4/26.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import "PagementSuccessVC.h"

@interface PagementSuccessVC ()
@property (weak, nonatomic) IBOutlet UILabel *nickname;

@end

@implementation PagementSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nickname.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"CEFNICKNAME"];
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

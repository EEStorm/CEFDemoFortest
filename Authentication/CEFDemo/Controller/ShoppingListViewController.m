//
//  ShoppingListViewController.m
//  CEFDemo
//
//  Created by zhangDongdong on 2018/4/20.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import "ShoppingListViewController.h"
#import "shoppingCell.h"
#import "ShoppingListModel.h"
#import "PaymentPageViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"

@interface ShoppingListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView* tableview;
@property(nonatomic,strong)NSArray* dataArray;

@end

@implementation ShoppingListViewController



- (NSArray *)dataArray {
    if (nil == _dataArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"shopping.plist" ofType:nil];
        NSArray *tempArray = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *mutable = [NSMutableArray array];
        for (NSDictionary *dict in tempArray) {
            ShoppingListModel *model = [ShoppingListModel weiboModelWithDict:dict];
            [mutable addObject:model];
        }
        _dataArray = mutable;
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    
}


-(void)setupUI{
    
    UIImageView *personIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"personalIcon"]];
    personIcon.frame = CGRectMake(18, 44, 80, 80);
    
    personIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logout:)];
    [personIcon addGestureRecognizer:tapGesture];
    
    
    UILabel *personLable = [[UILabel alloc]initWithFrame:CGRectMake(36+80, 44+30, 200, 30)];
    
    personLable.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"CEFNICKNAME"];
    [self.view addSubview:personLable];
    [self.view addSubview:personIcon];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+80, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height-44-80) style:UITableViewStylePlain];
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.rowHeight = 150;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"shoppingCell" bundle:nil]  forCellReuseIdentifier:@"shoppingCell"];
    
    [self.view addSubview:self.tableview];
    
    self.navigationController.delegate = self;
}

-(void)logout:(UITapGestureRecognizer *)gesture{
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnullaction) {
        UIStoryboard *CompleteStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *loginVC = [CompleteStoryboard instantiateInitialViewController];
        
        AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        UIViewController *vc = app.window.rootViewController;
        app.window.rootViewController = loginVC;
        [vc removeFromParentViewController];
    }];
    
    UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:@"注销用户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnullaction) {
        
        NSString *EID = [[NSUserDefaults standardUserDefaults] objectForKey:@"CUSTOM_EID"];
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
        
        UIStoryboard *CompleteStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *loginVC = [CompleteStoryboard instantiateInitialViewController];
        
        AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        UIViewController *vc = app.window.rootViewController;
        app.window.rootViewController = loginVC;
        [vc removeFromParentViewController];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alertController addAction:okAction];
    [alertController addAction:logoutAction];
    [alertController addAction:cancelAction];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    

}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"shoppingCell";
    shoppingCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier
                             forIndexPath:indexPath];
    cell.shoppingModel = self.dataArray[indexPath.row];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *PaymentPageStoryboard = [UIStoryboard storyboardWithName:@"PaymentPage" bundle:nil];
    
    ShoppingListModel *shoppingModel = self.dataArray[indexPath.row];
    [[NSUserDefaults standardUserDefaults]setObject:shoppingModel.text forKey:@"SUBJECT"];
    PaymentPageViewController *profileContpaymentVCroller = [PaymentPageStoryboard instantiateInitialViewController];
    [self.navigationController pushViewController:profileContpaymentVCroller animated:true];
}

@end

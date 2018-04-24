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
    
    UILabel *personLable = [[UILabel alloc]initWithFrame:CGRectMake(36+80, 44+30, 80, 30)];
    personLable.text = @"李菁";
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
    PaymentPageViewController *profileContpaymentVCroller = [PaymentPageStoryboard instantiateInitialViewController];
    [self.navigationController pushViewController:profileContpaymentVCroller animated:true];
}

@end

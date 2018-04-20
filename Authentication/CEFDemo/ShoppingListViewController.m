//
//  ShoppingListViewController.m
//  CEFDemo
//
//  Created by zhangDongdong on 2018/4/20.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import "ShoppingListViewController.h"
#import "shoppingCell.h"

@interface ShoppingListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView* tableview;
@property(nonatomic,strong)NSArray* data;

@end

@implementation ShoppingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    
    self.data = @[@"xxx",@"xx",@"xxx",@"xxx",@"xxxx",@"xxx",
             @"xxx",@"xxx",@"xxx"];
}


-(void)setupUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 120, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height) style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = [UIColor greenColor];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
//    tableviewregister(UINib.init(nibName: "shoppingCell", bundle: nil), forCellReuseIdentifier: ticketIdentifier)
    [self.tableview registerNib:[UINib nibWithNibName:@"shoppingCell" bundle:nil]  forCellReuseIdentifier:@"shoppingCell"];
    
    [self.view addSubview:self.tableview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"shoppingCell";
    shoppingCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier
                             forIndexPath:indexPath];
    NSString *name = self.data[indexPath.row];
    cell.textLabel.text = name;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
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

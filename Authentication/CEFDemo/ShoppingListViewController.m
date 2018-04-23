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
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height-44) style:UITableViewStylePlain];
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.rowHeight = 150;
    
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
    cell.shoppingModel = self.dataArray[indexPath.row];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
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

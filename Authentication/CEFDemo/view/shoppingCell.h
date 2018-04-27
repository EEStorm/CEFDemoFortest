//
//  shoppingCell.h
//  CEFDemo
//
//  Created by zhangDongdong on 2018/4/20.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingListModel.h"

@interface shoppingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellContent;
@property (weak, nonatomic) IBOutlet UILabel *celltitle;

@property (weak, nonatomic) IBOutlet UIImageView *imagepc;

@property (weak, nonatomic) IBOutlet UIImageView *price;
@property(nonatomic,strong)ShoppingListModel *shoppingModel;

@end

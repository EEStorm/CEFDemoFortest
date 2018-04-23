//
//  shoppingCell.m
//  CEFDemo
//
//  Created by zhangDongdong on 2018/4/20.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import "shoppingCell.h"

@implementation shoppingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


-(void)setShoppingModel:(ShoppingListModel *)shoppingModel {
    _shoppingModel = shoppingModel;
    self.celltitle.text = self.shoppingModel.text;
    self.cellContent.text = self.shoppingModel.content;
    
    self.imagepc.image = [UIImage imageNamed:self.shoppingModel.icon];
    self.price.image = [UIImage imageNamed:self.shoppingModel.price];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

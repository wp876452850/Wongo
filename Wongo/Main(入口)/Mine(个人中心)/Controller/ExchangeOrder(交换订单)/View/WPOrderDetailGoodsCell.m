//
//  WPOrderDetailGoodsCell.m
//  Wongo
//
//  Created by rexsu on 2017/4/24.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPOrderDetailGoodsCell.h"

@interface WPOrderDetailGoodsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *number;

@end
@implementation WPOrderDetailGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


-(void)setModel:(WPExchangeOrderGoodsModel *)model{
    _model = model;
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:nil];
    _goodsName.text = model.gname;
    _price.text     = [NSString stringWithFormat:@"￥%@", model.price ];
    _number.text    = model.number;
}

@end

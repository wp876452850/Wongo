//
//  WPSearchGoodsCollectionViewCell.m
//  Wongo
//
//  Created by rexsu on 2017/2/20.
//  Copyright © 2017年 Winny. All rights reserved.
//  搜索-商品/我的/他的店铺，公用cell

#import "WPSearchGoodsCollectionViewCell.h"

@interface WPSearchGoodsCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *collectNumber;
@property (weak, nonatomic) IBOutlet UIButton *collect;
//原价
@property (weak, nonatomic) IBOutlet UILabel *originalPrice;
//现价
@property (weak, nonatomic) IBOutlet UILabel *presentPrice;

@end
@implementation WPSearchGoodsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _presentPrice.textColor = SelfOrangeColor;
    
    [_collect setImage:[UIImage imageNamed:@"collectBtn"] forState:UIControlStateNormal];
    [_collect setImage:[UIImage imageNamed:@"select_select_address"] forState:UIControlStateSelected];
    
}

-(void)setModel:(WPSearchGoodsModel *)model{
    _model = model;
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"broken"]];
    _goodsName.text = model.gname;
    _collectNumber.text = model.freight;
    _collect.selected = [model.collect boolValue];
    //_originalPrice.text = [NSString stringWithFormat:@"%@%@",model.priceUnit,model.originalPrice];
    _presentPrice.text = [NSString stringWithFormat:@"￥%@",model.price];
}

@end

//
//  WPEnjoyGoodsTableViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/8/7.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPEnjoyGoodsTableViewCell.h"

@interface WPEnjoyGoodsTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UITextView *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end
@implementation WPEnjoyGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

-(void)setModel:(WPExchangeModel *)model{
    _model = model;
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:nil];
    _goodsName.text = model.gname;
    _price.text = [NSString stringWithFormat:@"%.2f",model.price.floatValue];
}

@end

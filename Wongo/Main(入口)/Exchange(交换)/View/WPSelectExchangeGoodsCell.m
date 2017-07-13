//
//  WPSelectExchangeGoodsCell.m
//  Wongo
//
//  Created by rexsu on 2017/3/29.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPSelectExchangeGoodsCell.h"

@interface WPSelectExchangeGoodsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;

@end
@implementation WPSelectExchangeGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.selectButton setBackgroundImage:[UIImage imageNamed:@"select_normal_address"] forState:UIControlStateNormal];
    [self.selectButton setBackgroundImage:[UIImage imageNamed:@"select_select_address"] forState:UIControlStateSelected];
    self.selectButton.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)selectButtonClick:(UIButton *)sender
{
    if (sender) {
        sender.selected = !sender.selected;
    }
}

-(void)setModel:(WPSelectExchangeGoodsModel *)model{
    _model = model;
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:nil];
    self.goodsName.text     = model.gname;
    self.goodsPrice.text    = [NSString stringWithFormat:@"￥%@",model.price];
}
@end

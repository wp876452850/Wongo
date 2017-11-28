//
//  WPCommodityManagementTableViewCell.m
//  Wongo
//
//  Created by rexsu on 2016/12/20.
//  Copyright © 2016年 Wongo. All rights reserved.
//

#import "WPCommodityManagementTableViewCell.h"
#import "WPExchangeViewController.h"

@interface WPCommodityManagementTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
@implementation WPCommodityManagementTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)delete:(UIButton *)sender {
    
}

-(void)setModel:(WPMyGoodsInformationModel *)model{
    _model = model;
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"loadimage"]];
    _goodsName.text = model.gname;
    _price.text     = [NSString stringWithFormat:@"￥%ld",[model.price integerValue]];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    WPExchangeViewController * vc = [WPExchangeViewController createExchangeGoodsWithUrlString:ExchangeDetailGoodsUrl params:@{@"gid":_model.gid} fromOrder:NO];
    
    [[self findViewController:self].navigationController pushViewController:vc animated:YES];
}
@end

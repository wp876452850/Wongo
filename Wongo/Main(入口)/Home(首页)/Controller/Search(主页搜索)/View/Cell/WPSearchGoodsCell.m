//
//  WPSearchGoodsCell.m
//  Wongo
//
//  Created by rexsu on 2017/2/14.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPSearchGoodsCell.h"

@interface WPSearchGoodsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;

@property (weak, nonatomic) IBOutlet UILabel *goodsName;

@end
@implementation WPSearchGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void)setModel:(WPSearchModel *)model
{
    _model = model;
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"broken"]];
    _goodsName.text = model.gcname;
}
@end

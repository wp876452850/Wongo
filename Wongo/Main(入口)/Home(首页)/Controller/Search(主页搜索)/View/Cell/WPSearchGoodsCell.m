//
//  WPSearchGoodsCell.m
//  Wongo
//
//  Created by rexsu on 2017/2/14.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPSearchGoodsCell.h"
#import "WPCollectionBaseViewController.h"
#import "WPConsignmentClassGoodsViewController.h"

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
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"loadimage"]];
    _goodsName.text = model.gcname;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.isConsignment) {
        WPCollectionBaseViewController * vc = [[WPCollectionBaseViewController alloc]initWithGcid:_model.gcid];
        vc.url = QueryGoodById;
        vc.myNavItem.title = _model.gcname;
        [[self findViewController:self].navigationController pushViewController:vc animated:YES];
        return;
    }
    WPConsignmentClassGoodsViewController * vc = [[WPConsignmentClassGoodsViewController alloc]initWithGcid:_model.gcid];
    vc.myNavItem.title = _model.gcname;
    [[self findViewController:self].navigationController pushViewController:vc animated:YES];
}
@end

//
//  WPStoreConsignmentCollectionViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/11/14.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPStoreConsignmentCollectionViewCell.h"
//寄卖详情
#import "WPConsignmentViewController.h"

@interface WPStoreConsignmentCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end

@implementation WPStoreConsignmentCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void)setModel:(WPConsignmentModel *)model{
    _model = model;
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:[model.url isKindOfClass:[NSNull class]]?@"":model.url] placeholderImage:[self getPlaceholderImage]];
    _goodsName.text = model.lname;
    _price.text = [NSString stringWithFormat:@"￥%.f",[model.price floatValue]];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    WPConsignmentViewController * vc = [[WPConsignmentViewController alloc]initWithLid:_model.lid];
    [[self findViewController:self].navigationController pushViewControllerAndHideBottomBar:vc animated:YES];
}
@end

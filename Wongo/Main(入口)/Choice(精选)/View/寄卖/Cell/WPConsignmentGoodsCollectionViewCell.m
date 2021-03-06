//
//  WPConsignmentGoodsCollectionViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/11/8.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPConsignmentGoodsCollectionViewCell.h"

@interface WPConsignmentGoodsCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end

@implementation WPConsignmentGoodsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void)setModel:(WPConsignmentModel *)model{
    if (!model.url||[model.url isKindOfClass:[NSNull class]])model.url = @"";
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"loadimage"]];
    self.title.text = model.lname;
    self.price.text = [NSString stringWithFormat:@"￥%.f",[model.price floatValue]];
}
@end

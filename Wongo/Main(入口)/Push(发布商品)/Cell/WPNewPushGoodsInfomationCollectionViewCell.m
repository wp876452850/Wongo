//
//  WPNewPushGoodsInfomationCollectionViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/11/15.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPNewPushGoodsInfomationCollectionViewCell.h"

@interface WPNewPushGoodsInfomationCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodName;
@property (weak, nonatomic) IBOutlet UILabel *lunci;
@property (weak, nonatomic) IBOutlet UILabel *price;
//一元到付申请
@property (weak, nonatomic) IBOutlet UILabel *left;
//免费配送
@property (weak, nonatomic) IBOutlet UILabel *right;

@end
@implementation WPNewPushGoodsInfomationCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.left.layer.borderColor = AllBorderColor.CGColor;
    self.layer.borderWidth = .5f;
    self.right.layer.borderColor = AllBorderColor.CGColor;
    self.layer.borderWidth = .5f;
}

@end

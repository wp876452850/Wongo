//
//  WPHomeDreamingPhotoCollectionViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/11/4.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPHomeDreamingPhotoCollectionViewCell.h"

@interface WPHomeDreamingPhotoCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;

@property (weak, nonatomic) IBOutlet UITextView *name;

@property (weak, nonatomic) IBOutlet UILabel *price;


@end

@implementation WPHomeDreamingPhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.state.shadowOffset = CGSizeMake(0.2, 0.2);
    self.state.shadowColor = TitleGrayColor;
    self.lunci.shadowOffset = CGSizeMake(0.2, 0.2);
    self.lunci.shadowColor = TitleGrayColor;
}


-(void)setModel:(WPNewHomeDreamingPhotoModel *)model{
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"loadimage"]];
    self.name.text = model.proname;
    self.price.text = [NSString stringWithFormat:@"￥%ld",[model.price integerValue]];
}
@end

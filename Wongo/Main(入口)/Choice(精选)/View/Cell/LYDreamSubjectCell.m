//
//  LYDreamSubjectCell.m
//  Wongo
//
//  Created by  WanGao on 2017/6/5.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "LYDreamSubjectCell.h"

@interface LYDreamSubjectCell ()
@property (weak, nonatomic) IBOutlet UILabel *subName;
@property (weak, nonatomic) IBOutlet UILabel *contents;
@property (weak, nonatomic) IBOutlet UIImageView *subImage;

@end

@implementation LYDreamSubjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setModel:(WPDreamingMainGoodsModel *)model{
    _model = model;
    self.subName.text = model.subname;
    self.contents.text = model.contents;
    [self.subImage sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:nil];
}
@end

//
//  WPDreamingImageTableViewCell.m
//  test222
//
//  Created by rexsu on 2017/5/11.
//  Copyright © 2017年 Winny. All rights reserved.
//  造梦详情-物品介绍 Main图

#import "WPDreamingImageTableViewCell.h"

@interface WPDreamingImageTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;

@end
@implementation WPDreamingImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setModel:(WPDreamingIntroduceImageModel *)model{
    _model = model;
    
}
@end

//
//  WPNewDreamingTableViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/8/9.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPNewDreamingTableViewCell.h"

@interface WPNewDreamingTableViewCell ()
/**主题名字*/
@property (weak, nonatomic) IBOutlet UILabel *subjectName;
/**背景图片*/
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
/**参与人数*/
@property (weak, nonatomic) IBOutlet UILabel *participation;

@end
@implementation WPNewDreamingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void)setModel:(WPDreamingMainGoodsModel *)model{
    _model = model;
    [self.bgImage sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"loadimage"]];
    self.subjectName.text = model.subname;
}


@end

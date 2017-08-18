//
//  WPHomeDreamingCollectionViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/8/14.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPHomeDreamingCollectionViewCell.h"
#import "WPDreamingDirectoryModel.h"
#import "WPDreamingDetailViewController.h"

@interface WPHomeDreamingCollectionViewCell ()
//指示图标
@property (nonatomic,strong)UIImageView * instructions;

@end
@implementation WPHomeDreamingCollectionViewCell

-(UIImageView *)instructions{
    if (!_instructions) {
        _instructions = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"positioning"]];
    }
    return _instructions;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void)setModel:(WPDreamingDirectoryModel *)model{
    _model = model;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    WPDreamingDetailViewController *vc = [WPDreamingDetailViewController createDreamingDetailWithPlid:_model.plid subid:_model.subid];
    [[self findViewController:self].navigationController pushViewController:vc animated:YES];
}
@end

//
//  WPHomeDreamingCollectionViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/8/14.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPHomeDreamingCollectionViewCell.h"

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

@end

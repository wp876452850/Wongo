//
//  WPListFirstTableViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/8/22.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPListFirstTableViewCell.h"

@interface WPListFirstTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *one;
@property (weak, nonatomic) IBOutlet UIImageView *two;
@property (weak, nonatomic) IBOutlet UIImageView *three;

@end
@implementation WPListFirstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end

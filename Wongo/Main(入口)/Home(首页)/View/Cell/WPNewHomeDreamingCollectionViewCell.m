//
//  WPNewHomeDreamingCollectionViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/11/2.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPNewHomeDreamingCollectionViewCell.h"

@interface WPNewHomeDreamingCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UILabel *category;

@end

@implementation WPNewHomeDreamingCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.category.layer.borderWidth = 1.f;
    self.category.layer.borderColor = ColorWithRGB(255,255, 255).CGColor;
    
}

@end

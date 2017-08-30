//
//  WPExchangeImageShowTableViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/8/29.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPExchangeImageShowTableViewCell.h"

@implementation WPExchangeImageShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

-(void)setImages:(NSArray *)images{
    _images = images;
    for (int i = 0; i < images.count; i++) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (WINDOW_WIDTH+40)*i+20, WINDOW_WIDTH, WINDOW_WIDTH)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:images[i]] placeholderImage:nil];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:imageView];
    }
}
@end

//
//  WPExchangeImageShowTableViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/8/29.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPExchangeImageShowTableViewCell.h"

@implementation WPExchangeImageShowTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

-(void)setImages:(NSArray *)images{
    _images = images;
    for (int i = 0; i < images.count; i++) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (WINDOW_WIDTH+10)*i, WINDOW_WIDTH, WINDOW_WIDTH)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:images[i]] placeholderImage:[UIImage imageNamed:@"loadimage"]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
    }
}

@end

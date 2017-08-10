//
//  WPCustomButton.m
//  Wongo
//
//  Created by  WanGao on 2017/8/9.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPCustomButton.h"

@interface WPCustomButton ()



@end

@implementation WPCustomButton
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.bounds = CGRectMake(0, 0, self.width, 20);
        _titleLabel.centerY = self.height/2;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}
-(void)setSelected:(BOOL)selected{
    _selected = selected;
    if (_selected) {
        self.titleLabel.attributedText = self.selectedAttrobuteString;
    }else{
        self.titleLabel.attributedText = self.normalAttrobuteString;
    }
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
    }return self;
}

@end

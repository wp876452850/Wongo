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

-(UIImageView *)image{
    if (!_image) {
        _image = [[UIImageView alloc]initWithFrame:CGRectZero];
        
    }
    return _image;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.bounds = CGRectMake(0, 0, self.width, 20);
        _titleLabel.center = CGPointMake(self.width/2, self.height/2);
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

-(void)setSelected:(BOOL)selected{
    _selected = selected;
    if (_selected) {
        if (_selectedAttrobuteString.length>0) {
            self.titleLabel.attributedText = self.selectedAttrobuteString;
            self.titleLabel.textColor = self.selectedTitleColor;
        }
    }else{
        self.titleLabel.attributedText = self.normalAttrobuteString;
        self.titleLabel.textColor = self.normalTitleColor;
    }
}

-(void)setNormalTitleColor:(UIColor *)normalTitleColor{
    _normalTitleColor = normalTitleColor;
    if (!self.selected) {
        _titleLabel.textColor = normalTitleColor;
    }
}

-(void)setNormalAttrobuteString:(NSAttributedString *)normalAttrobuteString{
    _normalAttrobuteString = normalAttrobuteString;
    if (!self.selected) {
    _titleLabel.attributedText = normalAttrobuteString;
    }
}

-(void)setSelectedTitleColor:(UIColor *)selectedTitleColor{
    _selectedTitleColor = selectedTitleColor;
    if (self.selected) {
        self.titleLabel.textColor = selectedTitleColor;
    }
}

-(void)setSelectedAttrobuteString:(NSAttributedString *)selectedAttrobuteString{
    _selectedAttrobuteString = selectedAttrobuteString;
    if (self.selected) {
        self.titleLabel.attributedText = selectedAttrobuteString;
    }
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //[self addSubview:self.image];
        [self addSubview:self.titleLabel];
    }return self;
}

@end

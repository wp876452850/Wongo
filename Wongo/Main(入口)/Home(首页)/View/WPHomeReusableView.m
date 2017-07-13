//
//  WPHomeReusableView.m
//  Wongo
//
//  Created by rexsu on 2017/2/8.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPHomeReusableView.h"
#define EnglishTitle_Font 11
#define ChineseTitle_Font 11


@interface WPHomeReusableView ()
@property (nonatomic,strong)UIImageView         * icon;
@property (nonatomic,strong)UILabel             * title_e;
@property (nonatomic,strong)UILabel             * title_c;
/**专题数*/
@property (nonatomic,strong)UILabel             * price;
@property (nonatomic,strong)UIImageView         * goIcon;
@property (nonatomic,strong)UIButton            * goProject;


@end
@implementation WPHomeReusableView

-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
    }
    return _icon;
}
-(UIImageView *)goIcon{
    if (!_goIcon) {
        _goIcon = [[UIImageView alloc]init];
    }
    return _goIcon;
}
-(UILabel *)title_e{
    if (!_title_e) {
        _title_e = [[UILabel alloc]init];
        _title_e.font = [UIFont systemFontOfSize:EnglishTitle_Font];
    }
    return _title_e;
}
-(UILabel *)title_c{
    if (!_title_c) {
        _title_c = [[UILabel alloc]init];
        _title_c.font = [UIFont systemFontOfSize:ChineseTitle_Font];
    }
    return _title_c;
}
-(UILabel *)projectNumber{
    if (!_price) {
        _price = [[UILabel alloc]init];
        _price.font = [UIFont systemFontOfSize:EnglishTitle_Font];
        _price.textAlignment = NSTextAlignmentRight;
    }
    return _price;
}
-(UIButton *)goProject{
    if (!_goProject) {
        _goProject = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _goProject;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.icon];
        [self addSubview:self.title_c];
        [self addSubview:self.title_e];
        [self addSubview:self.goProject];
        [self addSubview:self.goIcon];
        [self addSubview:self.projectNumber];
        [self subviewConstraintLayout];
    }
    return self;
}
//约束布局
-(void)subviewConstraintLayout{
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.bottom.equalTo(self.mas_bottom).offset(-12);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [_title_c mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_icon.mas_right).offset(10);
        make.top.equalTo(_icon.mas_centerY).offset(1);
    }];
    [_title_e mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_icon.mas_right).offset(10);
        make.bottom.equalTo(_icon.mas_centerY).offset(-1);
    }];
    [_goProject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(120, 40));
    }];
    [_goIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.centerY.mas_equalTo(_goProject.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_goIcon.mas_left).offset(-5);
        make.centerY.mas_equalTo(_goProject.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(120, 15));
    }];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = ColorWithRGB(235, 235, 235);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(_icon.mas_top).offset(-11.5);
    }];
}
-(void)setModel:(WPHomeReusableModel *)model{
    _model = model;
    self.icon.image         = [UIImage imageNamed:model.icon_name];
    self.title_c.text       = model.title_c;
    self.title_e.text       = model.title_e;
    self.price.text         = model.price;
    self.goIcon.image       = [UIImage imageNamed:@"goIcon"];
    self.title_e.textColor  = model.titleColor;
}

-(void)setDreamingMainGoodsModel:(WPDreamingMainGoodsModel *)dreamingMainGoodsModel{
    _dreamingMainGoodsModel = dreamingMainGoodsModel;
    
    self.title_c.text       = dreamingMainGoodsModel.contents;
    self.title_e.text       = dreamingMainGoodsModel.subname;
    self.price.text         = @"进入专题";
    self.goIcon.image       = [UIImage imageNamed:@"goIcon"];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:dreamingMainGoodsModel.url]];
    
}
@end

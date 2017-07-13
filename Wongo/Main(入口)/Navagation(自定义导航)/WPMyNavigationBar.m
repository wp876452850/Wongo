//
//  WPMyNavigationBar.m
//  Wongo
//
//  Created by rexsu on 2016/12/20.
//  Copyright © 2016年 Wongo. All rights reserved.
//  个人中心各子界面专用导航

#import "WPMyNavigationBar.h"

@interface WPMyNavigationBar ()

@end
@implementation WPMyNavigationBar


-(UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rightButton;
}
-(UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        
    }
    return _leftButton;
}
-(UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.textColor = [UIColor whiteColor];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.font = [UIFont systemFontOfSize:18];
    }
    return _title;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, WINDOW_WIDTH, 64);
        self.backgroundColor = ColorWithRGB(33, 34, 35);
        [self addSubview:self.leftButton];
        
        [self addSubview:self.title];
        
        [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(10);
            make.centerY.mas_equalTo(self.mas_centerY).offset(10);
            make.size.mas_equalTo(CGSizeMake(26,26));
        }];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY).offset(10);
            make.size.mas_equalTo(CGSizeMake(200, 30));
        }];
    }
    return self;
}

-(void)showRightButton{
    [self addSubview:self.rightButton];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).mas_offset(-10);
        make.centerY.mas_equalTo(self.mas_centerY).offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
}
@end

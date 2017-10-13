//
//  WPNavigationBarView.m
//  Wongo
//
//  Created by rexsu on 2016/12/13.
//  Copyright © 2016年 Wongo. All rights reserved.
//  自定义导航条样式

#import "WPNavigationBarView.h"
#define Self_BackGroundColor ColorWithRGB(33, 34, 35)
#define Title_Font [UIFont systemFontOfSize:18]

@implementation WPNavigationBarView

-(instancetype)initWithStyle:(NavigationBarStyle)style
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, WINDOW_WIDTH, 64);

        self.backgroundColor = Self_BackGroundColor;
        switch (style) {
            case NavigationBarHomeStyle:{
                [self createHomeStyleNavigationBar];
            }
                break;
            case NavigationBarChoiceStyle:{
                [self createChoiceStyleNavigationBar];
            }
                break;
        }
    }
    return self;
}

- (void)createHomeStyleNavigationBar
{
    
    
}
- (void)createChoiceStyleNavigationBar
{
    UIView * navigationItem = [[UIView alloc]initWithFrame:CGRectMake(0, 20, WINDOW_WIDTH, 44)];
    [self addSubview:navigationItem];
    /**标题*/
    UILabel * title = [[UILabel alloc]init];
    /**左侧按钮*/
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    /**右侧按钮*/
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [navigationItem addSubview:title];
    [navigationItem addSubview:leftBtn];
    [navigationItem addSubview:rightBtn];
    
    title.font = Title_Font;
    title.textColor = [UIColor whiteColor];
    title.text = @"精选";
    title.textAlignment = NSTextAlignmentCenter;
    [navigationItem addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 30));
        make.centerX.mas_equalTo(navigationItem.mas_centerX);
        make.centerY.mas_equalTo(navigationItem.mas_centerY);
    }];
    
#warning 后期更改UI给的图
    //[leftBtn setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    self.leftItemButton = leftBtn;
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(navigationItem).offset(10);
        make.centerY.mas_equalTo(navigationItem.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];

    
#warning 后期更改UI给的图
    //[rightBtn setBackgroundImage:[UIImage imageNamed:@"shopingCar"] forState:UIControlStateNormal];
    self.rightItemButton = rightBtn;
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(navigationItem).offset(-10);
        make.centerY.mas_equalTo(navigationItem.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];

    
}



@end

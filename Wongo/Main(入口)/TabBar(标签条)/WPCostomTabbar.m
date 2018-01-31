//
//  WPCostomTabbar.m
//  Wongo
//
//  Created by  WanGao on 2018/1/29.
//  Copyright © 2018年 Winny. All rights reserved.
//

#import "WPCostomTabbar.h"

@interface WPCostomTabbar ()

@property (nonatomic,strong)UIImageView * bgImageView;

@property (nonatomic,assign)NSInteger currentPage;

@end

@implementation WPCostomTabbar

-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _bgImageView.image = [UIImage imageNamed:@"tabbarbg"];
//        _bgImageView.userInteractionEnabled = YES;
        
    }
    return _bgImageView;
}

-(instancetype)init{
    if (self) {
        self = [[WPCostomTabbar alloc]initWithFrame:CGRectMake(0, WINDOW_HEIGHT-115, WINDOW_WIDTH, 115)];
        [self addSubview:self.bgImageView];
        [self createTabbarButton];
    }
    return self;
}

-(instancetype)initWithCurrentPage:(NSInteger)currentPage{
    if (self = [super init]) {
        self = [[WPCostomTabbar alloc]initWithFrame:CGRectMake(0, WINDOW_HEIGHT-115, WINDOW_WIDTH, 115)];
        self.currentPage = currentPage;
        [self addSubview:self.bgImageView];
        [self createTabbarButton];
    }
    return self;
}

-(void)createTabbarButton{
    NSArray * icons = @[@"tabbar_Home_Normal",@"tabbar_Exchange_Normal",@"tabbar_Push_Normal",@"tabbar_My_Normal"];
    NSArray * selectIcons = @[@"tabbar_Home_Select",@"tabbar_Exchange_Select",@"tabbar_Push_Select",@"tabbar_My_Select"];
    for (int i = 0; i<4; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, self.height - 73, 94, 74);
        button.centerX = WINDOW_WIDTH/8 * (i*2+1);
        button.tag = i;
        [button setImage:[UIImage imageNamed:icons[i]] forState:UIControlStateNormal];
        if (i == self.currentPage) {
            [button setImage:[UIImage imageNamed:selectIcons[i]] forState:UIControlStateNormal];
        }        
        [button addTarget:self action:@selector(tabbarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

-(void)tabbarButtonClick:(UIButton *)sender{
    WPTabBarController * tabbar = [WPTabBarController sharedTabbarController];
    [tabbar btnClick:sender];
}

@end

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



@end

@implementation WPCostomTabbar

-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithFrame:self.frame];
        _bgImageView.image = [UIImage imageNamed:@"tabbarbg"];
        _bgImageView.userInteractionEnabled = YES;
        
    }
    return _bgImageView;
}

-(instancetype)init{
    if (self) {
        self = [[WPCostomTabbar alloc]initWithFrame:CGRectMake(0, WINDOW_HEIGHT-115, WINDOW_WIDTH, 115)];
        
    }
    return self;
}

-(void)createTabbarButton{
    NSArray * icons = @[@"tabbar_Home",@"tabbar_Exchange",@"tabbar_Push",@"tabbar_My"];
    for (int i = 0; i<4; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat w = 73;
        CGFloat h = 73;
        button.frame = CGRectMake(0, self.height - 73 - 10, 73, 73);
        button.centerY = WINDOW_WIDTH/8 * (i*2+1);
        button.tag = i;
        [button setImage:[UIImage imageNamed:icons[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tabbarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)tabbarButtonClick:(UIButton *)sender{
    WPTabBarController * tabbar = [WPTabBarController sharedTabbarController];
    [tabbar btnClick:sender];
}

@end

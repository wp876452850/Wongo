//
//  WPHomeHeaderSearchView.m
//  Wongo
//
//  Created by rexsu on 2017/2/7.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPHomeHeaderSearchView.h"
#import "WPSearchGuideViewController.h"

@interface WPHomeHeaderSearchView ()<UICollectionViewDelegate>
{
    CGFloat headerViewHeight;
}

@property (nonatomic,strong)UIButton * positioningButton;

@property (nonatomic,strong)UIButton * searchButton;

@property (nonatomic,strong)UIButton * shoppingCarButton;
@end
static NSString * contentOffset = @"contantOffset";


@implementation WPHomeHeaderSearchView


-(instancetype)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, WINDOW_WIDTH, 64);
        self.backgroundColor = ColorWithRGB(33, 34, 36);
        [self selfSubViewsFrame];
        self.shoppingCarButton.hidden = YES;
        self.positioningButton.hidden = YES;
    }
    return self;
}

-(void)showSearchView{
    self.hidden = NO;
    self.searchButton.hidden = NO;
    self.searchButton.alpha = self.alpha;
    NSLog(@"%f  ---   %f",_positioningButton.alpha,self.alpha);
    [UIView animateWithDuration:0.25 animations:^{
        self.searchButton.frame = CGRectMake( - CGRectGetMaxX(self.positioningButton.frame) + 10 , 27, WINDOW_WIDTH - CGRectGetMaxX(self.positioningButton.frame) - CGRectGetMidX(self.shoppingCarButton.frame) - 20, 30);
    }];
}

-(void)hidenSearchView{
    self.hidden = YES;
    
    self.searchButton.hidden = YES;
   
    
}
-(void)animationForSearchButton{
    [UIView animateWithDuration:0.25 animations:^{
        self.positioningButton.alpha = 1;
        self.searchButton.alpha = 1;
        self.shoppingCarButton.alpha = 1;
        self.searchButton.frame = CGRectMake(CGRectGetMaxX(self.positioningButton.frame) + 10 , 27, WINDOW_WIDTH - CGRectGetMaxX(self.positioningButton.frame) - (WINDOW_WIDTH - CGRectGetMidX(self.shoppingCarButton.frame)) - 35, 30);
    }];
}
-(void)selfSubViewsFrame{
    [self.positioningButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.centerY.mas_equalTo(self.mas_centerY).offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 30));
    }];

    [self.shoppingCarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-25);
        make.centerY.mas_equalTo(self.mas_centerY).offset(10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
}

-(UIButton *)positioningButton{
    if (!_positioningButton) {
        _positioningButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _positioningButton.backgroundColor = ColorWithRGB(23, 23, 23);
        [self addSubview:_positioningButton];
    }
    return _positioningButton;
}

-(UIButton *)searchButton{
    if (!_searchButton) {
         _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchButton setBackgroundImage:[UIImage imageNamed:@"SearchBarBG"] forState:UIControlStateNormal];
        [_searchButton setImage:[UIImage imageNamed:@"searchbtn"] forState:UIControlStateNormal];
        [_searchButton setTitle:@"输入商品名称" forState:UIControlStateNormal];
        _searchButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_searchButton setTitleColor:ColorWithRGB(102, 102, 102) forState:UIControlStateNormal];
        [_searchButton addTarget:self action:@selector(goSearchGuide) forControlEvents:UIControlEventTouchUpInside];
        _searchButton.frame = CGRectMake(CGRectGetMaxX(self.positioningButton.frame) + 10 , 27, WINDOW_WIDTH - CGRectGetMaxX(self.positioningButton.frame) - (WINDOW_WIDTH - CGRectGetMidX(self.shoppingCarButton.frame)) - 35, 30);
        [_searchButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 0)];
        [self addSubview:_searchButton];
    }
    return _searchButton;
}

-(UIButton *)shoppingCarButton{
    if (!_shoppingCarButton) {
         _shoppingCarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shoppingCarButton.backgroundColor = ColorWithRGB(23, 23, 23);
        [self addSubview:_shoppingCarButton];
    }
    return _shoppingCarButton;
}

-(void)goSearchGuide{
    //FIXME:功能暂未开放
    [[self findViewController:self]showAlertNotOpenedWithBlock:nil];
    return;
    WPSearchGuideViewController * vc = [[WPSearchGuideViewController alloc]init];
    WPTabBarController * tabBar = [WPTabBarController sharedTabbarController];
    UINavigationController * nav = [tabBar.childViewControllers firstObject];
    [nav pushViewControllerAndHideBottomBar:vc animated:YES];
}

#warning 1.0不做定位和购物车
-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];

}
@end

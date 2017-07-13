//
//  WPAnimationHeader.m
//  Wongo
//
//  Created by rexsu on 2017/3/31.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPAnimationHeader.h"

@implementation WPAnimationHeader

-(void)prepare{
    [super prepare];
    //设置未请求数据时的动画组
    self.lastUpdatedTimeLabel.hidden = YES;
//    NSMutableArray * idleImages = [NSMutableArray array];
//    for (NSUInteger i = 1; i<=60; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
//        [idleImages addObject:image];
//    }
//    [self setImages:idleImages forState:MJRefreshStateIdle];
//
//    //设置开始请求并且刷新时动画
//    NSMutableArray *actionImages = [NSMutableArray array];
//    for (NSUInteger i = 1; i<=3; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
//        [actionImages addObject:image];
//    }
//    
//    [self setImages:actionImages forState:MJRefreshStatePulling];
//    
//    
//    // 设置正在刷新状态的动画图片
//    [self setImages:actionImages forState:MJRefreshStateRefreshing];
//    
//    [self setTitle:@"下拉刷新内容" forState:MJRefreshStateIdle];
//    [self setTitle:@"松开即可刷新" forState:MJRefreshStatePulling];
//    [self setTitle:@"数据加载中..." forState:MJRefreshStateRefreshing];

}

- (void)placeSubviews{
    [super placeSubviews];
    
    //如果需要自己重新布局子控件，请在这里设置
    //箭头
    
}
@end

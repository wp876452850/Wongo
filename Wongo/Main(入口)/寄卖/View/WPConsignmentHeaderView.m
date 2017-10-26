//
//  WPConsignmentHeaderView.m
//  Wongo
//
//  Created by  WanGao on 2017/10/25.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPConsignmentHeaderView.h"

@interface WPConsignmentHeaderView ()

@property (nonatomic,strong)UIImageView * guideImageView;



@end
@implementation WPConsignmentHeaderView
-(UIImageView *)guideImageView{
    if (!_guideImageView) {
        _guideImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
        _guideImageView.frame = CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_WIDTH*0.6);
        _guideImageView.backgroundColor = RandomColor;
        
    }
    return _guideImageView;
}
-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}
@end

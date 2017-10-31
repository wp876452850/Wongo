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
//标题
@property (nonatomic,strong)UILabel * titleLabel;
//品种分类视图
@property (nonatomic,strong)UIView * varietiesView;
//品种1
@property (nonatomic,strong)UIButton * varieties1;
//品种2
@property (nonatomic,strong)UIButton * varieties2;
//品种3
@property (nonatomic,strong)UIButton * varieties3;
//品种4
@property (nonatomic,strong)UIButton * varieties4;
//品种5
@property (nonatomic,strong)UIButton * varieties5;

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
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.guideImageView.bottom, WINDOW_WIDTH, 30)];
        _titleLabel.backgroundColor = WhiteColor;
        _titleLabel.text = @"你要卖什么";
    }
    return _titleLabel;
}
-(UIView *)varietiesView{
    if (!_varietiesView) {
        _varietiesView = [[UIView alloc]initWithFrame:CGRectMake(0, _titleLabel.bottom, WINDOW_WIDTH, 180)];
        CGFloat width  = 143*(WINDOW_WIDTH/375);
        CGFloat height = 180 * (WINDOW_WIDTH/375);
        
        _varieties1 = [self setupVarietiesViewWithFrame:CGRectMake(0, 0, width, height) tag:1];
        
        _varieties2 = [self setupVarietiesViewWithFrame:CGRectMake(width, 0, (WINDOW_WIDTH-width)/2, height/2) tag:2];
        
        _varieties3 = [self setupVarietiesViewWithFrame:CGRectMake(_varieties2.right, 0, (WINDOW_WIDTH-width)/2, height) tag:3];
        
        _varieties4 = [self setupVarietiesViewWithFrame:CGRectMake(width, height/2, (WINDOW_WIDTH-width)/2, height/2) tag:4];
        
        _varieties5 = [self setupVarietiesViewWithFrame:CGRectMake(_varieties4.right, height/2, (WINDOW_WIDTH-width)/2, height/2) tag:5];
        
        [self.varietiesView.layer addSublayer:[WPBezierPath drowLineWithMoveToPoint:CGPointMake(0, 0) moveForPoint:CGPointMake(WINDOW_WIDTH, 0)]];
        [self.varietiesView.layer addSublayer:[WPBezierPath drowLineWithMoveToPoint:CGPointMake(width, 0) moveForPoint:CGPointMake(width, height)]];
        [self.varietiesView.layer addSublayer:[WPBezierPath drowLineWithMoveToPoint:CGPointMake(width, _varieties2.bottom) moveForPoint:CGPointMake(WINDOW_WIDTH, _varieties2.bottom)]];
        [self.varietiesView.layer addSublayer:[WPBezierPath drowLineWithMoveToPoint:CGPointMake(_varieties2.right, 0) moveForPoint:CGPointMake(_varieties2.right, height)]];
    }
    return _varietiesView;
}
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = WhiteColor;
        
        [self addSubview:self.guideImageView];
        [self addSubview:self.varietiesView];
    }
    return self;
}

-(UIButton *)setupVarietiesViewWithFrame:(CGRect)frame tag:(NSInteger)tag{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.tag = tag;
    [button addTarget:self action:@selector(gojimai) forControlEvents:UIControlEventTouchUpInside];
    [_varietiesView addSubview:button];
    return button;
}

-(void)gojimai{
    
}

@end

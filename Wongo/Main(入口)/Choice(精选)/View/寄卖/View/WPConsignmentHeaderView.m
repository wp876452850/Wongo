//
//  WPConsignmentHeaderView.m
//  Wongo
//
//  Created by  WanGao on 2017/10/25.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPConsignmentHeaderView.h"
#import "WPVarietiesButton.h"
#import "WPConsignmentClassOneModel.h"

@interface WPConsignmentHeaderView ()

@property (nonatomic,strong)UIImageView * guideImageView;
//标题
@property (nonatomic,strong)UILabel * titleLabel;
//品种分类视图
@property (nonatomic,strong)UIView * varietiesView;
//品种1
@property (nonatomic,strong)WPVarietiesButton * varieties1;
//品种2
@property (nonatomic,strong)WPVarietiesButton * varieties2;
//品种3
@property (nonatomic,strong)WPVarietiesButton * varieties3;
//品种4
@property (nonatomic,strong)WPVarietiesButton * varieties4;
//品种5
@property (nonatomic,strong)WPVarietiesButton * varieties5;

@property (nonatomic,strong)NSMutableArray * dataSourceArray;
@end
@implementation WPConsignmentHeaderView
-(UIImageView *)guideImageView{
    if (!_guideImageView) {
        _guideImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jimaishangmiandetu"]];
        _guideImageView.frame = CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_WIDTH*0.4);
        _guideImageView.backgroundColor = RandomColor;        
    }
    return _guideImageView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.guideImageView.bottom, WINDOW_WIDTH, 40)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = WhiteColor;
        _titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
        _titleLabel.text = @"您想要什么";
    }
    return _titleLabel;
}

-(UIView *)varietiesView{
    if (!_varietiesView) {
        _varietiesView = [[UIView alloc]initWithFrame:CGRectMake(0, _titleLabel.bottom, WINDOW_WIDTH, 180)];
        CGFloat width  = 143*(WINDOW_WIDTH/375);
        
        CGFloat height = 180 * (WINDOW_WIDTH/375);
        
        _varieties1 = [self setupVarietiesViewWithFrame:CGRectMake(0, 0, width, height) tag:0];
        
        _varieties2 = [self setupVarietiesViewWithFrame:CGRectMake(width, 0, (WINDOW_WIDTH-width)/2, height/2) tag:1];
        
        _varieties3 = [self setupVarietiesViewWithFrame:CGRectMake(_varieties2.right, 0, (WINDOW_WIDTH-width)/2, height/2) tag:2];
        
        _varieties4 = [self setupVarietiesViewWithFrame:CGRectMake(width, height/2, (WINDOW_WIDTH-width)/2, height/2) tag:3];
        
        _varieties5 = [self setupVarietiesViewWithFrame:CGRectMake(_varieties4.right, height/2, (WINDOW_WIDTH-width)/2, height/2) tag:4];
        
        [self.varietiesView.layer addSublayer:[WPBezierPath drowLineWithMoveToPoint:CGPointMake(0, 0) moveForPoint:CGPointMake(WINDOW_WIDTH, 0)]];
        [self.varietiesView.layer addSublayer:[WPBezierPath drowLineWithMoveToPoint:CGPointMake(width, 0) moveForPoint:CGPointMake(width, height)]];
        [self.varietiesView.layer addSublayer:[WPBezierPath drowLineWithMoveToPoint:CGPointMake(width, _varieties2.bottom) moveForPoint:CGPointMake(WINDOW_WIDTH, _varieties2.bottom)]];
        [self.varietiesView.layer addSublayer:[WPBezierPath drowLineWithMoveToPoint:CGPointMake(_varieties2.right, 0) moveForPoint:CGPointMake(_varieties2.right, height)]];
    }
    return _varietiesView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
        [self loadDatas];
        [self addSubview:self.guideImageView];
        [self addSubview:self.titleLabel];
        
        [self.layer addSublayer:[WPBezierPath drowLineWithMoveToPoint:CGPointMake(WINDOW_WIDTH - 60, _titleLabel.centerY) moveForPoint:CGPointMake(WINDOW_WIDTH - 90, _titleLabel.centerY) lineColor:TitleBlackColor]];
        [self.layer addSublayer:[WPBezierPath drowLineWithMoveToPoint:CGPointMake(60, _titleLabel.centerY) moveForPoint:CGPointMake(90, _titleLabel.centerY) lineColor:TitleBlackColor]];
    }
    return self;
}

-(void)loadDatas{
    __block typeof(self)weakSelf = self;
    self.dataSourceArray = [NSMutableArray arrayWithCapacity:3];
    [WPNetWorking createPostRequestMenagerWithUrlString:QueryClassoneLog params:nil datas:^(NSDictionary *responseObject) {
        NSArray * listc = responseObject[@"listc"];
        for (int i = 0; i<listc.count; i++) {
            WPConsignmentClassOneModel * model = [WPConsignmentClassOneModel mj_objectWithKeyValues:listc[i]];
            if ([model.cid floatValue] == 3) {
                [weakSelf.dataSourceArray insertObject:model atIndex:0];
            }else
            [weakSelf.dataSourceArray addObject:model];
        }
        [weakSelf addSubview:weakSelf.varietiesView];
    }];
}

-(WPVarietiesButton *)setupVarietiesViewWithFrame:(CGRect)frame tag:(NSInteger)tag{
    WPConsignmentClassOneModel * model = self.dataSourceArray[tag];
    WPVarietiesButton * button = [[WPVarietiesButton alloc]initWithImage:nil title:model.cname frame:frame];
    [button.varietiesImageView sd_setImageWithURL:[NSURL URLWithString:model.curl] placeholderImage:[self getPlaceholderImage]];
    button.frame = frame;
    button.tag = tag;
    [button addTarget:self action:@selector(gojimai) forControlEvents:UIControlEventTouchUpInside];
    [_varietiesView addSubview:button];
    return button;
}

-(void)gojimai{
    
}

@end

//
//  WPProgressTableViewCell.m
//  Wongo
//
//  Created by rexsu on 2017/3/13.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPProgressTableViewCell.h"
#import "ProgressView.h"
#define Progress_Width_Height (WINDOW_WIDTH - 80) /3

#define States @[@"未开始",@"进行中"]

static NSString * price;
static NSString * isrecommend;
static NSString * progress;

@interface WPProgressTableViewCell ()
{
    ProgressView * priceProgress;
    ProgressView * progressProgress;
    ProgressView * dateProgress;
}
@end
@implementation WPProgressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:self]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}


-(void)setModel:(WPDreamingModel *)model{
    _model      = model;
    price       = model.price;
    isrecommend = model.isrecommend;
    progress    = model.progress;
    
    [self createProgress];
    
}
//创建进度条
-(void)createProgress{
    progress = [NSString stringWithFormat:@"%ld",_model.rounds - 1];
    if (!priceProgress) {
        //创建金额进度条
        priceProgress    = [ProgressView createProgressWithFrame:CGRectMake(20, 10, Progress_Width_Height, Progress_Width_Height) backColor:ColorWithRGB(188, 229, 219) color:ColorWithRGB(72, 208, 180) proportion:1];
        [self.contentView addSubview:priceProgress];
    }
    if (!progressProgress) {
        //创建进度进度条
        progressProgress    = [ProgressView createProgressWithFrame:CGRectMake(30+Progress_Width_Height, 0, Progress_Width_Height+20, Progress_Width_Height+20) backColor:ColorWithRGB(252, 211, 145) color:ColorWithRGB(252, 114, 0) proportion:[progress floatValue]/10];
        [self.contentView addSubview:progressProgress];
    }
    if (!dateProgress) {
        //创建时间进度条
        dateProgress    = [ProgressView createProgressWithFrame:CGRectMake(60 +Progress_Width_Height*2, 10, Progress_Width_Height, Progress_Width_Height) backColor:ColorWithRGB(203, 192, 221) color:ColorWithRGB(146, 117, 179) proportion:1];
        [self.contentView addSubview:dateProgress];
    }
    NSString * state = States[[isrecommend integerValue]];
    priceProgress.data              = state;
    priceProgress.dataName          = @"造梦状态";
    [priceProgress showContentData];
    
    
    progressProgress.data              = [NSString stringWithFormat:@"第%ld轮",_model.rounds - 1];
    progressProgress.dataName          = @"轮次";
    [progressProgress showContentData];
    progressProgress.dataLabelFont = 25;
    progressProgress.dataLabelBold = YES;
    
    dateProgress.data              = [NSString stringWithFormat:@"10:20"];
    dateProgress.dataName          = @"时间";
    [dateProgress showContentData];
}
@end

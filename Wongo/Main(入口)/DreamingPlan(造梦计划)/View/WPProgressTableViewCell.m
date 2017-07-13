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

static NSString * price;
static NSString * unit;
static NSString * progress;
@implementation WPProgressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}


-(void)setModel:(WPDreamingModel *)model{
    _model      = model;
    price       = model.price;
    unit        = model.unit;
    progress    = model.progress;
    [self createProgress];
    
}
//创建进度条
-(void)createProgress{
    //创建金额进度条
    ProgressView * priceProgress    = [ProgressView createProgressWithFrame:CGRectMake(20, 10, Progress_Width_Height, Progress_Width_Height) backColor:ColorWithRGB(188, 229, 219) color:ColorWithRGB(72, 208, 180) proportion:1];
    priceProgress.data              = [NSString stringWithFormat:@"%@%@",unit,price];
    priceProgress.dataName          = @"金额";
    [priceProgress showContentData];
    
    //创建进度进度条
    ProgressView * progressProgress    = [ProgressView createProgressWithFrame:CGRectMake(30+Progress_Width_Height, 0, Progress_Width_Height+20, Progress_Width_Height+20) backColor:ColorWithRGB(252, 211, 145) color:ColorWithRGB(252, 114, 0) proportion:[progress floatValue]];
    progressProgress.data              = [NSString stringWithFormat:@"%.0f%%",[progress floatValue]*100];
    progressProgress.dataName          = @"进度";
    [progressProgress showContentData];
    progressProgress.dataLabelFont = 25;
    progressProgress.dataLabelBold = YES;
    //创建时间进度条
    ProgressView * dateProgress    = [ProgressView createProgressWithFrame:CGRectMake(60 +Progress_Width_Height*2, 10, Progress_Width_Height, Progress_Width_Height) backColor:ColorWithRGB(203, 192, 221) color:ColorWithRGB(146, 117, 179) proportion:1];
    dateProgress.data              = [NSString stringWithFormat:@"10:20"];
    dateProgress.dataName          = @"时间";
    [dateProgress showContentData];
    
    [self.contentView addSubview:priceProgress];
    [self.contentView addSubview:progressProgress];
    [self.contentView addSubview:dateProgress];
}
@end

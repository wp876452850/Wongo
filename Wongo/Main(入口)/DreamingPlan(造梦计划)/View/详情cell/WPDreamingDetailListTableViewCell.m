//
//  WPDreamingDetailListTableViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/8/21.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPDreamingDetailListTableViewCell.h"
#import "WPListxiViewController.h"
#import "WPListModel.h"
#define ListWidth WINDOW_WIDTH - 50
#define ImageWidthAndHeight (ListWidth - 15 - 6*8) / 8

@interface WPDreamingDetailListTableViewCell ()

@end
@implementation WPDreamingDetailListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:self]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setDataSourceArray:(NSMutableArray *)dataSourceArray{
    _dataSourceArray = dataSourceArray;
    
    [self.contentView removeAllSubviews];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(17, 5, 200, 15)];
    label.text = [NSString stringWithFormat:@"%ld  人参与",_dataSourceArray.count];
    label.font = [UIFont boldSystemFontOfSize:12.f];
    label.textColor = ColorWithRGB(46, 119, 160);
    [self.contentView addSubview:label];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(WINDOW_WIDTH-50, 20, 50, 50);
    [button setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    
    NSInteger imageCount = _dataSourceArray.count;
    if (imageCount > 7) {
        imageCount = 7;
    }
    for (int i = 0; i< imageCount; i++) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * 45 + 15, 25, ImageWidthAndHeight , ImageWidthAndHeight)];
        WPListModel * model = [WPListModel mj_objectWithKeyValues:dataSourceArray[i]];
        imageView.centerY = button.centerY;
        [self.contentView addSubview:imageView];
        imageView.backgroundColor = WongoGrayColor;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = imageView.height /2;
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:nil];
    }
}
-(void)buttonClick:(UIButton *)sender{
    WPListxiViewController * vc = [[WPListxiViewController alloc]initWithDataSourceArray:self.dataSourceArray];
    [[self findViewController:self].navigationController pushViewController:vc animated:YES];
}
@end

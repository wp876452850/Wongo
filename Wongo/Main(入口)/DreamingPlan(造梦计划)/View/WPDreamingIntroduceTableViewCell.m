//
//  WPDreamingIntroduceTableViewCell.m
//  test222
//
//  Created by rexsu on 2017/5/11.
//  Copyright © 2017年 Winny. All rights reserved.
//  造梦详情-物品介绍-文字内容

#import "WPDreamingIntroduceTableViewCell.h"
#import "Masonry.h"
#import "UIView+Extension.h"
#define Window_Width [UIScreen mainScreen].bounds.size.width
#define ImageWidth (Window_Width-70)/4

@interface WPDreamingIntroduceTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *pushTime;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsIntroduce;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;

@end
@implementation WPDreamingIntroduceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _headerView.layer.masksToBounds = YES;
    _headerView.layer.cornerRadius  = _headerView.height/2;
    [_goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(Window_Width - 20, Window_Width-20));
        make.top.mas_equalTo(_goodsIntroduce.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(10);
    }];
    
    for (int i = 0; i < 4; i++) {
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(i*(ImageWidth+10)+20,_goodsIntroduce.bottom,ImageWidth,ImageWidth)];
        image.backgroundColor = RandomColor;
        [self.contentView addSubview:image];
    }
}

-(void)setModel:(WPDreamingGoodsIntroduceModel *)model{
    _model = model;
}
@end

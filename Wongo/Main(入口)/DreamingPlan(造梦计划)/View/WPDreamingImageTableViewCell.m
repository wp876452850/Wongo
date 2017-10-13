//
//  WPDreamingImageTableViewCell.m
//  test222
//
//  Created by rexsu on 2017/5/11.
//  Copyright © 2017年 Winny. All rights reserved.
//  造梦详情-物品介绍 Main图

#import "WPDreamingImageTableViewCell.h"

@interface WPDreamingImageTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
/**状态(进行中)*/
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
/**状态框(已完成)*/
@property (weak, nonatomic) IBOutlet UILabel *logoLabelOK;
/**状态(已完成)*/
@property (weak, nonatomic) IBOutlet UIImageView *logoImageOK;
/**发布时间*/
@property (weak, nonatomic) IBOutlet UILabel *pushTime;
/**头像*/
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
/**用户名*/
@property (weak, nonatomic) IBOutlet UILabel *userName;
/**支持*/
@property (weak, nonatomic) IBOutlet UIButton *thumup;

@end
@implementation WPDreamingImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headerImage.layer.cornerRadius = 25.f;
    self.headerImage.layer.masksToBounds = YES;
    self.headerImage.layer.borderWidth = .5f;
    self.headerImage.layer.borderColor = WongoGrayColor.CGColor;
}

-(void)setModel:(WPDreamingIntroduceImageModel *)model{
    _model = model;
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:_model.prourl] placeholderImage:[UIImage imageNamed:@"loadimage"]];
    _goodsName.text = _model.proname;
    _pushTime.text = _model.pbutime;
    _userName.text = _model.uname;
    
}
-(void)showOK{
    self.logoImageOK.hidden = NO;
    self.logoLabelOK.hidden = NO;
    self.logoImage.hidden = YES;
    }
-(void)showOngoing
{
    self.logoImage.hidden = NO;
    self.logoImageOK.hidden = YES;
    self.logoLabelOK.hidden = YES;
}
@end

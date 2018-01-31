//
//  WPDreamingImageTableViewCell.m
//  test222
//
//  Created by rexsu on 2017/5/11.
//  Copyright © 2017年 Winny. All rights reserved.
//  造梦详情-物品介绍 Main图

#import "WPDreamingImageTableViewCell.h"
#import "WPStoreViewController.h"

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

@property (weak, nonatomic) IBOutlet UIButton *thumpButton;

@end
@implementation WPDreamingImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headerImage.layer.cornerRadius = 25.f;
    self.headerImage.layer.masksToBounds = YES;
    self.headerImage.layer.borderWidth = .5f;
    self.headerImage.layer.borderColor = WongoGrayColor.CGColor;
    
    [self.thumpButton setImage:[UIImage imageNamed:@"shopDreamingthumup_normal"] forState:UIControlStateNormal];
    [self.thumpButton setImage:[UIImage imageNamed:@"shopDreamingthumup_select"] forState:UIControlStateNormal];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goStore)];
    [self.headerImage addGestureRecognizer:tap];
}
-(void)goStore{
    WPStoreViewController * vc = [[WPStoreViewController alloc]initWithUid:_model.uid];
    vc.isPresen = YES;
    [[self findViewController:self] presentViewController:vc animated:YES completion:nil];
    
}
-(void)setModel:(WPDreamingIntroduceImageModel *)model{
    _model = model;
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:_model.url] placeholderImage:[UIImage imageNamed:@"loadimage"]];
    if (!model.praise||[model.praise isKindOfClass:[NSNull class]])model.praise = @"0";
    [_thumup setTitle:[NSString stringWithFormat:@"支持数:%@人",model.praise] forState:UIControlStateNormal];
    _goodsName.text = _model.proname;
    _pushTime.text = _model.pbutime;
    _userName.text = _model.uname;
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:model.userUrl] placeholderImage:[UIImage imageNamed:@"loadimage"]];
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
- (IBAction)thumup:(id)sender {
    
    
}


@end

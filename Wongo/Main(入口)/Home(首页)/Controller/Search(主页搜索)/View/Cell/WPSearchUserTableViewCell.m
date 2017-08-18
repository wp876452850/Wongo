//
//  WPSearchUserTableViewCell.m
//  Wongo
//
//  Created by rexsu on 2017/2/20.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPSearchUserTableViewCell.h"

@interface WPSearchUserTableViewCell ()
{
    ChatBlock _chatBlock;
}
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *signature;
@property (weak, nonatomic) IBOutlet UILabel *fansNumber;
@property (weak, nonatomic) IBOutlet UILabel *goodsNumber;
@property (weak, nonatomic) IBOutlet UIButton *attention;
@property (weak, nonatomic) IBOutlet UIButton *chat;
//对方用户ID
@property (nonatomic,strong)NSString * userID;

@end
@implementation WPSearchUserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_attention setTitleColor:SelfOrangeColor forState:UIControlStateNormal];
    [_attention setTitleColor:GRAY_COLOR forState:UIControlStateSelected];
    [_attention setTitle:@"+ 关注" forState:UIControlStateNormal];
    [_attention setTitle:@"已关注" forState:UIControlStateSelected];
    _attention.layer.masksToBounds  = YES;
    _attention.layer.cornerRadius   = 5;
    _attention.layer.borderWidth    = 1;
    _attention.titleLabel.font      = [UIFont systemFontOfSize:15];
    
    _chat.layer.masksToBounds   = YES;
    _chat.layer.borderWidth     = 1;
    _chat.layer.borderColor     = SelfOrangeColor.CGColor;
    _chat.layer.cornerRadius    = 5;
    _chat.titleLabel.font       = [UIFont systemFontOfSize:15];
    [_chat setTitleColor:SelfOrangeColor forState:UIControlStateNormal];
    [_chat setTitle:@"发私信" forState:UIControlStateNormal];
    
    _headImage.layer.masksToBounds  = YES;
    _headImage.layer.cornerRadius   = _headImage.width/2;
    
    
}

-(void)setModel:(WPSearchUserModel *)model{
    _model = model;
    
    [_headImage sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"broken"]];
    
    _userName.text                  = model.uname;
    _signature.text                 = model.signature;
    _fansNumber.text                = @"粉丝：0";
    _goodsNumber.text               = [NSString stringWithFormat:@"商品：%@",model.goodsNum];
    _attention.selected             = [model.attention boolValue];
    UIColor * color                 = _attention.selected?GRAY_COLOR:SelfOrangeColor;
    _attention.layer.borderColor    = color.CGColor;
    
    _userID                         = model.uid;
    
}
- (IBAction)attentionClick:(UIButton *)sender {
    
    if ([self determineWhetherTheLogin]) {
        _attention.selected         = !_attention.selected;
        UIColor * color             = sender.selected?GRAY_COLOR:SelfOrangeColor;
        sender.layer.borderColor    = color.CGColor;
        [self requestServer];
    }
}
//关注
-(void)requestServer{
    //请求服务器点击时进行操作
    
}

- (IBAction)chatClick:(UIButton *)sender {
    
    if ([self determineWhetherTheLogin]) {
        if (_chatBlock) {
            _chatBlock(_userID);
        }
    }
}

-(void)goChatWithBlock:(ChatBlock)block{
    
    _chatBlock = block;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}


@end

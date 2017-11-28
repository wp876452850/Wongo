//
//  WPFansTableViewCell.m
//  Wongo
//
//  Created by rexsu on 2017/2/23.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPFansTableViewCell.h"

@interface WPFansTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView    *header;
@property (weak, nonatomic) IBOutlet UILabel        *userName;
@property (weak, nonatomic) IBOutlet UILabel        *signature;
@property (weak, nonatomic) IBOutlet UIButton       *attention;

@end

@implementation WPFansTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_attention setTitle:@"+关注" forState:UIControlStateNormal];
    [_attention setTitle:@"已关注" forState:UIControlStateSelected];
    [_attention setTitleColor:GRAY_COLOR forState:UIControlStateNormal];
    [_attention setTitleColor:SelfThemeColor forState:UIControlStateSelected];
    self.header.layer.cornerRadius = _header.height/2;
    _attention.layer.masksToBounds = YES;
    _attention.layer.cornerRadius  = _attention.height/2;
    _attention.layer.borderWidth   = 1;
    _attention.layer.borderColor   = SelfThemeColor.CGColor;
}

-(void)setModel:(WPFansModel *)model{
    _model = model;
    [_header sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"loadimage"]];
    _userName.text = model.uname;
    _attention.selected = YES;
    _signature.text = model.signature;
}

- (IBAction)attentionClick:(UIButton *)sender {
    
    [self focusOnTheUserWithSender:sender uid:_model.uid];
    if (sender.selected) {
        sender.layer.borderColor   = GRAY_COLOR.CGColor;
    }
    else{
        sender.layer.borderColor   = SelfThemeColor.CGColor;
    }
    
}

@end

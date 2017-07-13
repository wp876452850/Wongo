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
    [_attention setTitleColor:SelfOrangeColor forState:UIControlStateNormal];
    [_attention setTitleColor:GRAY_COLOR forState:UIControlStateSelected];
    _attention.layer.masksToBounds = YES;
    _attention.layer.cornerRadius  = _attention.height/2;
    _attention.layer.borderWidth   = 1;
    _attention.layer.borderColor   = SelfOrangeColor.CGColor;
}



- (IBAction)attentionClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.layer.borderColor   = GRAY_COLOR.CGColor;
    }
    else{
        sender.layer.borderColor   = SelfOrangeColor.CGColor;
    }
}

@end

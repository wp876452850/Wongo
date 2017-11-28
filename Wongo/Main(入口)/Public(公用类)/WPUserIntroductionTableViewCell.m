//
//  WPUserIntroductionTableViewCell.m
//  Wongo
//
//  Created by rexsu on 2017/3/17.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPUserIntroductionTableViewCell.h"

@interface WPUserIntroductionTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView    * userImage;
@property (weak, nonatomic) IBOutlet UILabel        * userName;
@property (weak, nonatomic) IBOutlet UILabel        * signature;
@property (weak, nonatomic) IBOutlet UIButton       * collectButton;
@property (nonatomic,strong)NSString                * uid;
@end

@implementation WPUserIntroductionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_collectButton setTitle:@"+关注" forState:UIControlStateNormal];
    [_collectButton setTitle:@"已关注" forState:UIControlStateSelected];
    [_collectButton setTitleColor:SelfThemeColor forState:UIControlStateNormal];
    _collectButton.layer.masksToBounds = YES;
    _collectButton.layer.cornerRadius  = _collectButton.height/2;
    _collectButton.layer.borderWidth   = 1;
    _collectButton.layer.borderColor   = SelfThemeColor.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

-(void)setModel:(WPUserIntroductionModel *)model{
    _model                  = model;
    _userName.text          = model.uname;
    _signature.text         = model.signature;
    _uid                    = model.uid;
    _collectButton.selected = [model.collect boolValue];
    [_userImage sd_setImageWithURL:[NSURL URLWithString:model.url]];
}

- (IBAction)sender:(UIButton *)sender {
    
    [[self findViewController:self] showAlertNotOpenedWithBlock:nil];
    return;
    
    if ([_uid isEqualToString:[self getSelfUid]]) {
        UIViewController * vc = [self findViewController:self];
        [vc showAlertWithAlertTitle:@"提示" message:@"无法关注自己" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
        return;
    }
    sender.selected = !sender.selected;
    
}
@end

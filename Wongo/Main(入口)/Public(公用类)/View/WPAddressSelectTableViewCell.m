//
//  WPAddressSelectTableViewCell.m
//  Wongo
//
//  Created by rexsu on 2017/3/23.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPAddressSelectTableViewCell.h"

@interface WPAddressSelectTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *address;

@property (nonatomic,assign)NSInteger  adid;

@end
@implementation WPAddressSelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.select setImage:[UIImage imageNamed:@"select_normal_address"] forState:UIControlStateNormal];
    [self.select setImage:[UIImage imageNamed:@"select_select_address"] forState:UIControlStateSelected];
    self.select.userInteractionEnabled = NO;
}
- (IBAction)selectButtonClick:(UIButton *)sender
{
    if (sender) {
        sender.selected = !sender.selected;
    }
}

-(void)setModel:(WPAddressModel *)model{
    _model = model;
    _userName.text      = [NSString stringWithFormat:@"收件人:%@",model.consignee];
    _phoneNumber.text   = [NSString stringWithFormat:@"电话:%@",model.phone];
    _address.text       = [NSString stringWithFormat:@"地址:%@",model.address];
    _adid               = model.adid;
}
@end

//
//  WPAddressManageTableViewCell.m
//  Wongo
//
//  Created by rexsu on 2016/12/26.
//  Copyright © 2016年 Wongo. All rights reserved.
//

#import "WPAddressManageTableViewCell.h"
#import "WPAddressEditViewController.h"
#import "WPAddressViewController.h"

@interface WPAddressManageTableViewCell ()
{
    DeleteAddressBlock _deleteBlock;
}
/**收件人*/
@property (weak, nonatomic) IBOutlet UILabel *recipient;
/**电话*/
@property (weak, nonatomic) IBOutlet UILabel *phone;
/**地址*/
@property (weak, nonatomic) IBOutlet UILabel *address;
/**编辑*/
@property (weak, nonatomic) IBOutlet UIButton *edit;
/**删除*/
@property (weak, nonatomic) IBOutlet UIButton *deleteAddress;
/**地址id*/
@property (nonatomic,strong)NSString * adid;

@end
@implementation WPAddressManageTableViewCell

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

- (IBAction)delete:(UIButton *)sender {
    [[self findViewController:self] showAlertWithAlertTitle:@"提示" message:@"是否删除地址" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确认",@"取消"] block:^{
        [WPNetWorking createPostRequestMenagerWithUrlString:DeleteAddressedUrl params:@{@"adid":_model.adid} datas:^(NSDictionary *responseObject) {
            if (_deleteBlock) {
                _deleteBlock();
            }
        }];
    }];
}


- (IBAction)goEdit:(UIButton *)sender
{
    
    NSMutableDictionary * dateSource = [NSMutableDictionary dictionaryWithCapacity:3];
    [dateSource setObject:self.recipient.text forKey:@"recipient"];
    [dateSource setObject:self.phone.text forKey:@"phone"];    
    NSString * address = [self.address.text getStringSegmentationRegionWithString:self.address.text];
    NSArray * array = [address componentsSeparatedByString:@"-"];
    [dateSource setObject:array.lastObject forKey:@"detailAddress"];
    NSString * detailAddress = array.lastObject;
    NSString * region = [_address.text stringByReplacingOccurrencesOfString:detailAddress withString:@""];
    [dateSource setObject:region forKey:@"address"];
    [dateSource setObject:_adid forKey:@"adid"];
    WPTabBarController * tabBar = [WPTabBarController sharedTabbarController];
    UINavigationController * nav = [tabBar.childViewControllers lastObject];
    WPAddressEditViewController * vc = [[WPAddressEditViewController alloc]initWithStyle:WPAddressEditStyle dateSource:dateSource];
    //去编辑界面
    [nav pushViewController:vc animated:YES];
    vc.saveBlock = ^(NSString *recipient,NSString *phone,NSString *address,NSString *detailAddress,NSString * adid){
        self.recipient.text = recipient;
        self.phone.text = phone;
        self.address.text = [NSString stringWithFormat:@"%@%@",address,detailAddress];
    };
    
}

-(void)setModel:(WPAddressModel *)model{
    _model = model;
    _recipient.text = model.consignee;
    _phone.text     = model.phone;
    _address.text   = model.address;
    _adid           = model.adid;
}

-(void)deleteAddressWithBlock:(DeleteAddressBlock)block{
    _deleteBlock = block;
}

@end

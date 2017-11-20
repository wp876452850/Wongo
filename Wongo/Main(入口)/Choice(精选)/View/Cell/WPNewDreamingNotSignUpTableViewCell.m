//
//  WPNewDreamingNotSignUpTableViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/8/18.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPNewDreamingNotSignUpTableViewCell.h"
#import "WPPushDreamingViewController.h"
#import "WPNewPushDreamingViewController.h"

@interface WPNewDreamingNotSignUpTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *signUpNumber;
@property (weak, nonatomic) IBOutlet UIButton *signUp;
@property (weak, nonatomic) IBOutlet UIImageView *userbg;

@end
@implementation WPNewDreamingNotSignUpTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.image.layer.masksToBounds = YES;
    self.image.layer.cornerRadius = 20;
    self.image.layer.borderColor = WhiteColor.CGColor;
    self.image.layer.borderWidth = 1.f;
    self.signUp.layer.masksToBounds = YES;
    self.signUp.layer.cornerRadius = 8.0f;
    self.userbg.layer.masksToBounds = YES;
    self.userbg.layer.cornerRadius = 20.f;
    
}

-(void)setModel:(WPDreamingMainGoodsModel *)model{
    _model = model;
}

- (IBAction)goSignUp:(UIButton *)sender
{
//    WPPushDreamingViewController * vc = [[WPPushDreamingViewController alloc]initWithSubid:_model.subid];
    //vc.isPush = YES;
    WPNewPushDreamingViewController * vc = [[WPNewPushDreamingViewController alloc]init];
    vc.subid = _model.subid;
    [[self findViewController:self].navigationController pushViewControllerAndHideBottomBar:vc animated:YES];
    
}
- (IBAction)help:(id)sender {
    [[self findViewController:self] showAlertWithAlertTitle:@"造梦规则" message:@"“造梦”专区。碗糕用户可在此发起“造梦”招募，通过与其他用户进行有价值的物品多环节交换，换取所需物品或最接近所需物品价值的物品。“造梦”过程实际是多环节等价交换的过程，但发起者可通过发起招募，最终实现不等价交换，完成拉环变钻戒的梦想！碗糕全体用户均可参与其中，碗糕用户须上传个人物品，填写完整清楚的物品描述，且交纳一定的保证金之后，发布至专区页面便可成功发起“造梦”。发起者须在有限的五次交换中，尽量将物品的价值最大化，在最后获得所需物品或与所需物品价值相近的东西。当发起者成功完成五次不同的交换之后，无论发起者是否成功“造梦”，此次“造梦”结束。“造梦计划”是碗糕平台含公益性质的一大功能，旨在帮助更多有梦、追梦、有需要的人们完成自己所想。" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
}

@end

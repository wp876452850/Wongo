//
//  WPExchangeOrderCell.m
//  Wongo
//
//  Created by rexsu on 2017/3/22.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPExchangeOrderCell.h"
#import "WPPayDepositViewController.h"
#import "LYExchangeOrderDetailController.h"
#import "WPExchangeViewController.h"

#define TransactionStatus   @[@"交易关闭",@"申请中",@"等待同意",@"待支付保证金",@"待发货",@"待确认",@"待退保证金",@"退款成功",@"平台介入",@""]

#define RightButtonTitles   @[@"",@"申请中",@"同意交换",@"支付保证金", @"发货",  @"确认收货",@"待退保证金",@"退款成功",@"平台介入",@""]


@interface WPExchangeOrderCell ()
@property (weak, nonatomic) IBOutlet UIImageView    *myGoodsImage;
@property (weak, nonatomic) IBOutlet UILabel        *goodsName;
@property (weak, nonatomic) IBOutlet UILabel        *goodsPrice;
@property (weak, nonatomic) IBOutlet UIImageView    *partnerGoodsImage;
@property (weak, nonatomic) IBOutlet UILabel        *partnerGoodsName;
@property (weak, nonatomic) IBOutlet UILabel        *partnerGoodsPrice;
@property (weak, nonatomic) IBOutlet UIButton       *rightButton;
@property (weak, nonatomic) IBOutlet UIButton       *leftButton;
@property (weak, nonatomic) IBOutlet UILabel        *transactionStatus;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;

@end
@implementation WPExchangeOrderCell
- (void)setHideSomeInDetail:(BOOL)hideSomeInDetail{
    _hideSomeInDetail = hideSomeInDetail;
    self.leftButton.hidden = hideSomeInDetail;
    self.rightButton.hidden = hideSomeInDetail;
    self.transactionStatus.hidden = hideSomeInDetail;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UITapGestureRecognizer * myImageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myImageClick:)];
    UITapGestureRecognizer * otherImageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(otherImageClick:)];
    _leftButton.hidden = YES;
    [_myGoodsImage addGestureRecognizer:myImageTap];
    [_partnerGoodsImage addGestureRecognizer:otherImageTap];
}
-(void)myImageClick:(UITapGestureRecognizer *)tap{
    if (!_model.myModel.gid.length) {
        return;
    }
    WPExchangeViewController * vc   = [WPExchangeViewController createExchangeGoodsWithUrlString:ExchangeDetailGoodsUrl params:@{@"gid":_model.myModel.gid} fromOrder:YES];
    [[self findViewController:self].navigationController pushViewController:vc animated:YES];
}

-(void)otherImageClick:(UITapGestureRecognizer *)tap{
    if (!_model.partnerModel.gid.length) {
        return;
    }
    WPExchangeViewController * vc   = [WPExchangeViewController createExchangeGoodsWithUrlString:ExchangeDetailGoodsUrl params:@{@"gid":_model.partnerModel.gid} fromOrder:YES];
    [[self findViewController:self].navigationController pushViewController:vc animated:YES];
}

-(void)setModel:(WPExchangeOrderModel *)model{
    _model = model;
    
    [_myGoodsImage sd_setImageWithURL:[NSURL URLWithString:model.myModel.url] placeholderImage:nil];
    [_partnerGoodsImage sd_setImageWithURL:[NSURL URLWithString:model.partnerModel.url] placeholderImage:[UIImage imageNamed:@"loadimage"]];
    _goodsName.text         = model.myModel.gname;
    _goodsPrice.text        = [NSString stringWithFormat:@"￥%@",model.myModel.price];
    _partnerGoodsName.text  = model.partnerModel.gname;
    _partnerGoodsPrice.text =  [NSString stringWithFormat:@"￥%@",model.partnerModel.price];
    
    NSString *rightTitle = @"";
    if (model.state <= RightButtonTitles.count && model.state >= 0) {
        rightTitle = RightButtonTitles[model.state];
    }
    NSString *transcationStatusTitle = @"";
    if (model.state <= TransactionStatus.count && model.state >= 0) {
        transcationStatusTitle = TransactionStatus[model.state];
    }
    
    if (model.state == 4) {
        if (!model.emp) {
            rightTitle = @"等待对方支付";
            transcationStatusTitle = @"等待对方支付保证金";
        }
        if (model.hasSss && model.sss == 0) {//对方已发货，自己没有
            rightTitle = @"发货";
            transcationStatusTitle = @"待发货";
        }
    }
    if (model.state == 5) {
        if (model.sss == 1) {//对方未发货
            rightTitle = @"等待对方发货";
            transcationStatusTitle = @"等待对方发货";
        }else if(model.hasEsc && model.esc == 0)
             {//自己已确认对方没有
                rightTitle = @"等待对方确认";
                transcationStatusTitle = @"等待对方确认";
        }
        if (model.ptjr == 2) {//2对方未确认收货自己申请平台介入
            rightTitle = @"平台介入";
            transcationStatusTitle = @"平台介入";
        }
    }
    if (model.state == 6) {
        if (model.esc == 1) {//对方确认，自己没有
            rightTitle = @"确认";
            transcationStatusTitle = @"待收货";
        }
        if (!model.hasEsc && model.hasSuc && model.suc == 1){//退款成功
            rightTitle = @"退款成功";
            transcationStatusTitle = @"退款成功";
        }
        if (model.hasSuc && model.suc == 0){
            rightTitle = @"退款失败";
            transcationStatusTitle = @"退款失败";
        }
        if (model.ptjr == 1) {//1对方确认收货自己申请平台介入
            rightTitle = @"平台介入";
            transcationStatusTitle = @"平台介入";
        }
    }
    
    [_rightButton setTitle:rightTitle forState:UIControlStateNormal];
    _transactionStatus.text = [NSString stringWithFormat:@"交易状态: %@",transcationStatusTitle];
    if (model.state  != 0) {
        _rightButton.backgroundColor = SelfOrangeColor;
    }else{
        _rightButton.backgroundColor = [UIColor clearColor];
    }
}
- (IBAction)rightButtonClick:(UIButton *)sender {
    NSInteger state = _model.state;
    switch (state) {
        case 2:
        {
            //同意交换
            __weak typeof(self) weakSelf = self;
            [[self findViewController:self] showAlertWithAlertTitle:@"确认与Ta交换？" message:nil preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确认",@"取消"] block:^{
                [WPNetWorking createPostRequestMenagerWithUrlString:UpdateOrderUrl params:@{@"ordernum":self.model.ordernum} datas:^(NSDictionary *responseObject) {
                    int result = 0;
                    if ([responseObject isKindOfClass:[NSDictionary class]] && (result = [responseObject[@"flag"] intValue])==1) {
                        weakSelf.model.state = 3;
                        [weakSelf setModel:weakSelf.model];
                        [[weakSelf findViewController:weakSelf] showAlertWithAlertTitle:@"操作成功" message:nil preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"好的"]];
                    }else{
                         [[weakSelf findViewController:weakSelf] showAlertWithAlertTitle:@"操作失败" message:nil preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"好的"]];
                    }
                }];
            }];
            
        }
            break;
        case 3:
        {
            
            //支付保证金
            WPPayDepositViewController * vc = [[WPPayDepositViewController alloc]initWithOrderNumber:self.model.oid price:[self.model.myModel.price floatValue] aliPayUrl:AliPayUrl];
//            vc.model = self.model;
            [[self findViewController:self].navigationController pushViewController:vc animated:YES];
        }
            break;
        
        default:{
            [[self findViewController:self].navigationController pushViewController:[LYExchangeOrderDetailController controllerWithModel:self.model] animated:YES];
        }
            break;
            
    }
}
- (IBAction)leftButtonClick:(UIButton *)sender {
    //中断交换
    
}

@end





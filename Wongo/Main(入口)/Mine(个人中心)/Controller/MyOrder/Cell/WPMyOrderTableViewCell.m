//
//  WPMyOrderTableViewCell.m
//  Wongo
//
//  Created by rexsu on 2016/12/20.
//  Copyright © 2016年 Wongo. All rights reserved.
//

#import "WPMyOrderTableViewCell.h"
#import "LYConversationController.h"
#import "WPPayDepositViewController.h"

#define StatusTitles @[@"待发货",@"待收货",@"已收货",@"",@"",@"",@""]
#define StatusButtonTitles @[@"提醒发货",@"确认收货",@"",@"",@"",@"",@""]

@interface WPMyOrderTableViewCell ()

/**店铺名称*/
@property (weak, nonatomic) IBOutlet UILabel *shopName;
/**付款状态*/
@property (weak, nonatomic) IBOutlet UILabel *paymentStatus;
/**商品图片*/
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
/**商品名字*/
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
/**规格*/
@property (weak, nonatomic) IBOutlet UILabel *specifications;
/**数量*/
@property (weak, nonatomic) IBOutlet UILabel *number;
/**价格*/
@property (weak, nonatomic) IBOutlet UILabel *price;
/**总数*/
@property (weak, nonatomic) IBOutlet UILabel *totalNumber;
/**总价*/
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
/**运费*/
@property (weak, nonatomic) IBOutlet UILabel *freight;
/**联系卖家*/
@property (weak, nonatomic) IBOutlet UIButton *contactSeller;
/**左边按钮*/
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
/**右边按钮*/
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end

@implementation WPMyOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.rightButton.layer.masksToBounds = YES;
    self.rightButton.layer.cornerRadius  = 5;
    self.contactSeller.layer.masksToBounds = YES;
    self.contactSeller.layer.cornerRadius  = 5;
}

-(void)setModel:(WPMyOrderModel *)model {
    _model = model;
    NSString *statusTitle = nil;
    NSString *statusButtonTitle = nil;
    if ([[self getSelfUid] isEqualToString:model.fromuser]) {//发货人
        switch (model.state) {
            case 0:
                statusTitle = @"等待对方支付保证金";
                self.rightButton.hidden = YES;
                break;
            case 1:
                statusTitle = @"待发货";
                statusButtonTitle = @"发货";
                self.rightButton.hidden = NO;
                break;
            case 2:
                statusTitle = @"已发货";
                self.rightButton.hidden = YES;
                break;
            case 3:
                statusTitle = @"交易完成";
                self.rightButton.hidden = YES;
                break;
            case 4:
                statusTitle = @"平台介入";
                self.rightButton.hidden = YES;
                break;
                
            default:
                break;
        }
    }else{//收货人
        switch (model.state) {
            case 0:
                statusTitle = @"待交保证金";
                statusButtonTitle = @"支付保证金";
                self.rightButton.hidden = NO;
                break;
            case 1:
                statusTitle = @"等待发货";
                self.rightButton.hidden = YES;
                break;
            case 2:
                statusTitle = @"待收货";
                statusButtonTitle = @"确认收货";
                self.rightButton.hidden = NO;
                break;
            case 3:
                statusTitle = @"交易完成";
                self.rightButton.hidden = YES;
                break;
            case 4:
                statusTitle = @"平台介入";
                self.rightButton.hidden = YES;
                break;
            default:
                break;
        }
    }
    _shopName.text = model.uname;
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:model.url]];
    _goodsName.text = model.proname;
    _paymentStatus.text = statusTitle;
    _specifications.text = model.remark;
    _price.text = [NSString stringWithFormat:@"￥%@",model.price];
    _totalPrice.text = [NSString stringWithFormat:@"￥%@",model.price];
    [_rightButton setTitle:statusButtonTitle forState:UIControlStateNormal];
}

- (IBAction)rightButtonClick:(UIButton *)sender {
    if ([[self getSelfUid] isEqualToString:self.model.fromuser]) {//发货人
        switch (self.model.state) {
            case 1:{//收货
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"发货" message:@"输入物流信息" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
                    textField.placeholder = @"输入物流公司";
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
                }];
                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    textField.placeholder = @"输入单号";
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
                }];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    UITextField *com = alertController.textFields.firstObject;
                    UITextField *num = alertController.textFields.lastObject;
                    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
                    [SVProgressHUD showWithStatus:@"发货..."];
                    [WPNetWorking createPostRequestMenagerWithUrlString:UpdatePlorderUrl params:@{@"ploid":self.model.ploid,@"lognum":num.text,@"logcompany":com.text} datas:^(NSDictionary *responseObject) {
                        if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject[@"flag"] intValue] == 1) {
                            self.model.state = 2;
                            [self setModel:self.model];
                            [SVProgressHUD showSuccessWithStatus:@"发货完成"];
                        }else{
                            [SVProgressHUD showInfoWithStatus:@"失败，请重试"];
                        }
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [SVProgressHUD dismiss];
                        });
                    } failureBlock:^{
                        [SVProgressHUD dismiss];
                    }];
                }];
                okAction.enabled = NO;
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
                }];
                [alertController addAction:okAction];
                [alertController addAction:cancelAction];
                [[self findViewController:self] presentViewController:alertController animated:YES completion:nil];
                
            }
                break;
            default:
                break;
        }
    }else{//收货人
        switch (self.model.state) {
            case 0:{//支付保证金
                WPPayDepositViewController *payVC = [[WPPayDepositViewController alloc] initWithParams:@{@"ploid":self.model.ploid,@"amount":@([self.model.price floatValue]*.3f)} price:[self.model.price floatValue] aliPayUrl:AliPayProductUrl];
                [[self findViewController:self].navigationController pushViewController:payVC animated:YES];
            }
                break;

            case 2://确认收货
            {
            
                [SVProgressHUD showWithStatus:@"确认中..."];
                [WPNetWorking createPostRequestMenagerWithUrlString:UpdatePlorderStateUrl params:@{@"ploid":self.model.ploid} datas:^(NSDictionary *responseObject) {
                    if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject[@"flag"] intValue] == 1) {
                        self.model.state = 3;
                        [self setModel:self.model];
                        [SVProgressHUD showSuccessWithStatus:@"确认成功"];
                    }else{
                        [SVProgressHUD showInfoWithStatus:@"确认失败，请重试"];
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                    });
                } failureBlock:^{
                    [SVProgressHUD dismiss];
                }];
            }
                break;
            default:
                break;
        }
    }
}
- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)[self findViewController:self].presentedViewController;
    if ([alertController isKindOfClass:[UIAlertController class]]) {
        UITextField *com = alertController.textFields.firstObject;
        UITextField *num = alertController.textFields.lastObject;
        UIAlertAction *okAction = alertController.actions.firstObject;
        okAction.enabled = com.hasText && num.hasText;
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)leftButtonClick:(UIButton *)sender {
   
}
- (IBAction)connect:(UIButton *)sender {
    [self determineWhetherTheLogin];
    NSString *uid = @"";
    NSString *title = @"";
    if ([[self getSelfUid] isEqualToString:self.model.fromuser]) {
        uid = self.model.touser;
        title = self.model.shouname;
    }else{
        uid = self.model.fromuser;
        title = self.model.uname;
    }
    LYConversationController *vc = [[LYConversationController alloc] initWithConversationType:ConversationType_PRIVATE targetId:uid];
    vc.title = title;
    [[self findViewController:self].navigationController pushViewController:vc animated:YES];
}

@end

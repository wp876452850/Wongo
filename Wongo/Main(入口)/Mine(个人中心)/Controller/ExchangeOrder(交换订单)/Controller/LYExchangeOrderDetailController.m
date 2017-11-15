//
//  LYExchangeOrderDetailController.m
//  Wongo
//
//  Created by  WanGao on 2017/6/2.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "LYExchangeOrderDetailController.h"
#import "WPExchangeOrderCell.h"
#import "LYExchangeAdressController.h"
#import "WPPayDepositViewController.h"
#import "LYExchangeOrderDetialModel.h"

#define RightButtonTitles  @[@"交易关闭",@"申请中",@"同意交换",@"支付保证金", @"发货",  @"确认收货",@"待退保证金",@"",@"平台介入",@""]

@interface LYExchangeOrderDetailController ()
/**订单详情 */
@property (nonatomic, strong) LYExchangeOrderDetialModel *detailModel;

/**订单模型*/
@property (nonatomic, strong) WPExchangeOrderModel *model;

/**对方支付信息*/
@property (nonatomic, strong) UILabel *payL;

/**对方发货物流信息*/
@property (nonatomic, strong) UILabel *expL;

/**聊天按钮 */
@property (nonatomic, strong) UIButton *chatBtn;

/**查看地址按钮 */
@property (nonatomic, strong) UIButton *addrBtn;
@property (nonatomic, strong) UILabel *addrL;

/**物流公司 */
@property (nonatomic, strong) UITextField *expCompany;

/**物流单号 */
@property (nonatomic, strong) UITextField *expNum;

/**第一个按钮 */
@property (nonatomic, strong) UIButton *btnA;

/**第二个按钮 */
@property (nonatomic, strong) UIButton *btnB;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, strong) UILabel *rightNavL;
@end

@implementation LYExchangeOrderDetailController
+ (instancetype)controllerWithModel:(WPExchangeOrderModel *)model{
    LYExchangeOrderDetailController *vc = [[LYExchangeOrderDetailController alloc] init];
    vc.model = model;
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorWithRGB(230, 230, 230);
    [self setNavigation];
    [self setGoods];
    [self setBottomBtn];
    [self setExpressLabelAndAmountL];
    [self setMidBtns];
    [self setExpressView];
    self.btnA.hidden = YES;
    [self setState];
    [self loadDetailInfo];
}
- (void)loadDetailInfo{
    [self.indicator startAnimating];
    [WPNetWorking createPostRequestMenagerWithUrlString:QueryOrder params:@{@"oid":self.model.oid,@"uid":self.getSelfUid} datas:^(NSDictionary *responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            LYExchangeOrderDetialModel *model = [LYExchangeOrderDetialModel mj_objectWithKeyValues:responseObject];
            self.detailModel = model;
            if (model.lognum) {
                self.expL.text = [NSString stringWithFormat:@"对方已发:%@\n单号:%@",model.logcompany,model.lognum];
            }
            if (model.paymoney) {
                self.payL.text = [NSString stringWithFormat:@"对方已支付:￥%@",model.paymoney];
            }
        }
        [self.indicator stopAnimating];
    } failureBlock:^{
        [self.indicator stopAnimating];
    }];
}
- (void)setState{
    
    NSString *stateTitle = @"";
    if (self.model.state <= RightButtonTitles.count && self.model.state >= 0) {
        stateTitle = RightButtonTitles[self.model.state];
    }
    
    
   switch (self.model.state) {
       case 0: case 8://交易关闭
            self.expNum.hidden = YES;
            self.expCompany.hidden = YES;
            self.btnB.hidden = YES;
            self.addrBtn.hidden = YES;
            self.addrL.hidden = YES;
            break;
        case 1://等待同意
            self.expNum.hidden = YES;
            self.expCompany.hidden = YES;
            self.addrBtn.hidden = YES;
            self.addrL.hidden = YES;
            self.btnB.hidden = YES;
            break;
        case 2://收到申请
            self.expNum.hidden = YES;
            self.expCompany.hidden = YES;
            self.addrBtn.hidden = YES;
            self.addrL.hidden = YES;
            break;
        case 3://支付
            self.expNum.hidden = YES;
            self.expCompany.hidden = YES;
            self.addrBtn.hidden = YES;
            self.addrL.hidden = YES;
            break;
        case 4://发货
           if (!self.model.emp && !self.model.hasSss) {//对方未支付，自己支付
               self.expNum.hidden = YES;
               self.expCompany.hidden = YES;
               //                self.addrBtn.hidden = YES;
               //                self.addrL.hidden = YES;
               self.btnB.hidden = YES;
               stateTitle = @"等待对方支付";
           }
           if (self.model.hasSss && self.model.sss == 0) {//对方已发货，自己没有
               
           }
            break;
        case 5://确认收货
           self.expNum.hidden = YES;
           self.expCompany.hidden = YES;
           self.btnA.hidden = NO;
           [self.btnA setTitle:@"申请平台介入" forState:UIControlStateNormal];
           if (self.model.sss == 1){//对方未发货
               self.btnB.hidden = YES;
               self.expNum.hidden = YES;
               self.expCompany.hidden = YES;
               stateTitle = @"等待对方发货";
               self.btnA.hidden = YES;
           }
           if(self.model.sss == 0 && self.model.hasSss){
               self.expNum.hidden = YES;
               self.expCompany.hidden = YES;
           }
           if(self.model.hasEsc && self.model.esc == 0){//自己已确认对方没有
               stateTitle = @"等待对方确认";
               self.expNum.hidden = YES;
               self.expCompany.hidden = YES;
               self.btnB.hidden = YES;
               self.btnA.hidden = YES;
               self.addrBtn.hidden = YES;
               self.addrL.hidden = YES;
           }
           if (self.model.ptjr == 2){//2对方未确认收货自己申请平台介入
               self.btnB.hidden = YES;
               self.btnA.hidden = YES;
               stateTitle = @"平台介入";
           }
            break;
        case 6://交易完成
           
           if (!self.model.hasEsc && self.model.hasSuc && self.model.suc == 1){//退款成功
               stateTitle = @"退款成功";
           }
           if (self.model.hasSuc && self.model.suc == 0){
               stateTitle = @"退款失败";
           }
            self.expNum.hidden = YES;
            self.expCompany.hidden = YES;
            self.btnB.hidden = YES;
            self.addrBtn.hidden = YES;
            self.addrL.hidden = YES;
           if (self.model.esc == 1) {//对方确认，自己没有
               stateTitle = @"确认";
               self.btnB.hidden = NO;
               self.btnA.hidden = NO;
               [self.btnA setTitle:@"申请平台介入" forState:UIControlStateNormal];
           }
           if (self.model.ptjr == 1) {//1对方确认收货自己申请平台介入
               self.btnB.hidden = YES;
               self.btnA.hidden = YES;
               stateTitle = @"平台介入";
           }
            break;
        case 7:
           stateTitle = @"退款成功";
           self.expNum.hidden = YES;
           self.expCompany.hidden = YES;
           self.btnB.hidden = YES;
           self.addrBtn.hidden = YES;
           self.addrL.hidden = YES;
        default:
            break;
    }
    self.rightNavL.text = stateTitle;
    [self.btnB setTitle:stateTitle forState:UIControlStateNormal];
    [self.rightNavL sizeToFit];
}

- (void)btnAClick:(UIButton *)btn{
    btn.userInteractionEnabled = NO;
    if (!self.model.oid && !self.model.ordernum) {
        return;
    }
    [SVProgressHUD showWithStatus:@"申请中"];
    [WPNetWorking createPostRequestMenagerWithUrlString:UpdateOrderFalse params:@{@"oid":self.model.oid,@"ordernum":self.model.ordernum} datas:^(NSDictionary *responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject[@"flag"] intValue] == 1) {
            self.model.state = 8;
            [self setState];
            [SVProgressHUD showSuccessWithStatus:@"申请成功"];
            self.btnA.hidden = YES;
        }else{
            [SVProgressHUD showErrorWithStatus:@"申请失败"];
            btn.userInteractionEnabled = YES;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    } failureBlock:^{
        btn.userInteractionEnabled = YES;
    }];
}
- (void)btnBClick:(UIButton *)btn{
    switch (self.model.state) {
        case 0://交易关闭

            break;
        case 1://等待同意

            break;
        case 2: {//收到申请
            __weak typeof(self) weakSelf = self;
            [self showAlertWithAlertTitle:@"确认与Ta交换？" message:nil preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确认",@"取消"] block:^{
                [WPNetWorking createPostRequestMenagerWithUrlString:UpdateOrderUrl params:@{@"ordernum":self.model.ordernum} datas:^(NSDictionary *responseObject) {
                    int result = 0;
                    if ([responseObject isKindOfClass:[NSDictionary class]] && (result = [responseObject[@"flag"] intValue])==1) {
                        weakSelf.model.state = 3;
                        [weakSelf setState];
                        [weakSelf  showAlertWithAlertTitle:@"操作成功" message:nil preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"好的"]];
                    }else{
                        [weakSelf  showAlertWithAlertTitle:@"操作失败" message:nil preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"好的"]];
                    }
                }];
            }];
             }
            break;
        case 3:{ //支付保证金
            WPPayDepositViewController * vc = [[WPPayDepositViewController alloc]initWithParams:@{@"oid":self.model.oid,@"amount":@(0.01)} price:[self.model.partnerModel.price floatValue] aliPayUrl:AliPayUrl];
//            WPPayDepositViewController * vc = [[WPPayDepositViewController alloc]initWithParams:@{@"oid":self.model.oid,@"amount":@([self.model.partnerModel.price floatValue]*.3f)} price:[self.model.partnerModel.price floatValue] aliPayUrl:AliPayUrl];

            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4://发货
            if (self.model.emp || self.model.hasSss) {//对方支付完成
                    if ([self.expCompany hasText] && [self.expNum hasText]) {
                        [SVProgressHUD showWithStatus:@"发货中..."];
                        [WPNetWorking createPostRequestMenagerWithUrlString:UpdateOrderLogUrl params:@{@"oid":self.model.oid,@"lognum":self.expNum.text,@"logcompany":self.expCompany.text} datas:^(NSDictionary *responseObject) {
                            
                            if([responseObject isKindOfClass:[NSDictionary class]] && [responseObject [@"flag"] intValue] == 1){
                                [SVProgressHUD showSuccessWithStatus:@"发货成功"];
                                self.model.state = 5;
                                self.model.sss = self.model.hasSss?0:1;
                                [self setState];
                            }else{
                                [SVProgressHUD showErrorWithStatus:@"发货失败,重试"];
                            }
                            
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [SVProgressHUD dismiss];
                            });
                            
                        } failureBlock:^{
                            
                            [SVProgressHUD dismiss];
                        }];
                    }else{
                        [self showAlertWithAlertTitle:@"物流单号和公司不能为空" message:@"" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确认"]];
                    }
            }
            break;
        case 5://确认收货
        {
            if (self.model.sss == 0) {//对方已发货
                [self showAlertWithAlertTitle:@"请确认已经收到货了" message:@"" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"收到了",@"未收到"] block:^{
                    
                    [SVProgressHUD showWithStatus:@"确认中..."];
                    [WPNetWorking createPostRequestMenagerWithUrlString:ConfirmReceiptUrl params:@{@"oid":self.model.oid,@"ordernum":self.model.ordernum} datas:^(NSDictionary *responseObject) {
                        if([responseObject isKindOfClass:[NSDictionary class]] && [responseObject [@"flag"] intValue] == 1){
                            [SVProgressHUD showSuccessWithStatus:@"确认成功"];
                            self.model.esc = 0;
                            self.model.hasEsc = YES;
                            [self setState];
                        }else{
                            [SVProgressHUD showErrorWithStatus:@"确认失败,重试"];
                        }
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [SVProgressHUD dismiss];
                        });
                    } failureBlock:^{
                        [SVProgressHUD dismiss];
                    }];
                }];
                
            }
        }
            break;
        case 6://交易完成
            if (self.model.esc == 1) {//对方确认，自己没有
                [self showAlertWithAlertTitle:@"请确认已经收到货了" message:@"" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"收到了",@"未收到"] block:^{
                    
                    [SVProgressHUD showWithStatus:@"确认中..."];
                    [WPNetWorking createPostRequestMenagerWithUrlString:ConfirmReceiptUrl params:@{@"oid":self.model.oid,@"ordernum":self.model.ordernum} datas:^(NSDictionary *responseObject) {
                        if([responseObject isKindOfClass:[NSDictionary class]] && [responseObject [@"flag"] intValue] == 1){
                            [SVProgressHUD showSuccessWithStatus:@"确认成功"];
                            self.model.esc = 0;
                            self.model.hasEsc = YES;
                            [self setState];
                        }else{
                            [SVProgressHUD showErrorWithStatus:@"确认失败,重试"];
                        }
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [SVProgressHUD dismiss];
                        });
                    } failureBlock:^{
                        [SVProgressHUD dismiss];
                    }];
                }];
            }
            break;
        case 7:
            
            break;
            
        default:
            break;
    }
}

/**去处理地址信息*/
- (void)gotoDeailWithAdress:(UIButton *)btn{
    LYExchangeAdressController *vc = [[LYExchangeAdressController alloc] init];
    vc.model = self.model;
    vc.detailModel = self.detailModel;
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 设置物流信息框
 */
- (void)setExpressView{
    UITextField *expCompany = [[UITextField alloc] initWithFrame:CGRectMake(5, 410, WINDOW_WIDTH - 10, 35)];
    expCompany.borderStyle = UITextBorderStyleNone;
    expCompany.layer.cornerRadius = 2.5;
    expCompany.layer.masksToBounds = YES;
    expCompany.backgroundColor = ColorWithRGB(245, 245, 245);
    expCompany.placeholder = @"输入物流公司";
    expCompany.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:expCompany];
    self.expCompany = expCompany;
    UITextField *expNum = [[UITextField alloc] initWithFrame:CGRectMake(5, 450, WINDOW_WIDTH - 10, 35)];
    expNum.borderStyle = UITextBorderStyleNone;
    expNum.layer.cornerRadius = 2.5;
    expNum.layer.masksToBounds = YES;
    expNum.backgroundColor = ColorWithRGB(245, 245, 245);
    expNum.placeholder = @"输入物流单号";
    expNum.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:expNum];
    self.expNum = expNum;
}
/**设置对方发货信息 */
- (void)setExpressLabelAndAmountL{
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 294 , WINDOW_WIDTH, 50)];
    bg.backgroundColor = [UIColor whiteColor];
    UILabel *payL = [[UILabel alloc] initWithFrame:CGRectMake(WINDOW_WIDTH - 180, 15, 170, 20)];
//    payL.backgroundColor = [UIColor redColor];
    payL.font = [UIFont systemFontOfSize:13];
    payL.textColor = [UIColor lightGrayColor];
    payL.textAlignment = NSTextAlignmentRight;
    payL.numberOfLines = 0;
    self.payL = payL;
    [bg addSubview:payL];
    
    UILabel *expL = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 180, 40)];
    expL.font = [UIFont systemFontOfSize:13];
    expL.textColor = [UIColor lightGrayColor];
    expL.numberOfLines = 0;
 
    self.expL = expL;
    [bg addSubview:expL];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:expL.frame];
    [btn addTarget:self action:@selector(copyExpNum:) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:btn];
    [self.view addSubview:bg];
    
    CALayer *line = [[CALayer alloc] init];
    line.frame = CGRectMake(0, 50, WINDOW_WIDTH, 0.5);
    line.backgroundColor = [UIColor lightGrayColor].CGColor;
    [bg.layer addSublayer:line];
}
- (void)copyExpNum:(UIButton *)tap{
    if (!self.detailModel.lognum) {
        return;
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.detailModel.lognum;
    [SVProgressHUD showSuccessWithStatus:@"单号已复制到剪贴板"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}
/**
 设置聊天 地址按钮
 */
- (void)setMidBtns{
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 345, WINDOW_WIDTH, 50)];
    bg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bg];
    _addrBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, WINDOW_WIDTH - 10, 40)];
    _addrBtn.backgroundColor = [UIColor whiteColor];
    [_addrBtn setTitle:@"收货地址" forState:UIControlStateNormal];
    _addrBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_addrBtn setTitleColor:ColorWithRGB(150, 150, 150) forState:UIControlStateNormal];
    [_addrBtn addTarget:self action:@selector(gotoDeailWithAdress:) forControlEvents:UIControlEventTouchUpInside];
    [_addrBtn setImage:[UIImage imageNamed:@"address"] forState:UIControlStateNormal];
    _addrBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -WINDOW_WIDTH * 0.68, 0, 0);
    _addrBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10-WINDOW_WIDTH * 0.68, 0, 0);
    _addrBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [bg addSubview:_addrBtn];
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    arrow.frame = CGRectMake(WINDOW_WIDTH - 20, 18.5, 7, 13);
    [bg addSubview:arrow];
//    UILabel *addrL = [[UILabel alloc]init];
//    addrL.text = @"收货地址";
//    addrL.textColor = [UIColor lightGrayColor];
//    addrL.font = [UIFont systemFontOfSize:13];
//    [addrL sizeToFit];
//    CGPoint addCen = _addrBtn.center;
//    addCen.y += w-8;
//    addrL.center = addCen;
//    [self.view addSubview:addrL];
//    self.addrL = addrL;
    
//FIXME:聊天按钮
//    _chatBtn = [[UIButton alloc] initWithFrame:CGRectMake(WINDOW_WIDTH - w * 4, 320, w, w)];
//    _chatBtn.layer.cornerRadius = w * 0.5;
//    _chatBtn.layer.masksToBounds = YES;
//    _chatBtn.backgroundColor = SelfOrangeColor;
//    [self.view addSubview:_chatBtn];
//    [_chatBtn addTarget:self action:@selector(goToChat:) forControlEvents:UIControlEventTouchUpInside];
//    [_chatBtn setImage:[UIImage imageNamed:@"circle_normal"] forState:UIControlStateNormal];
//    UILabel *chatL = [[UILabel alloc]init];
//    chatL.text = @"私聊对方";
//    chatL.textColor = [UIColor lightGrayColor];
//    chatL.font = [UIFont systemFontOfSize:13];
//    [chatL sizeToFit];
//    CGPoint chatCen = _chatBtn.center;
//    chatCen.y += w-8;
//    chatL.center = chatCen;
//    [self.view addSubview:chatL];
    
    
}

- (void)goToChat:(UIButton *)btn{
    
}

/**
 设置底部按钮
 */
- (void)setBottomBtn{
    CGFloat h = 40;
    CGFloat m = 5;
    _btnB = [[UIButton alloc] initWithFrame:CGRectMake(m, WINDOW_HEIGHT - m - h, WINDOW_WIDTH - m * 2, h)];
    _btnB.backgroundColor = SelfOrangeColor;
    _btnB.layer.cornerRadius = 2.5;
    _btnB.layer.masksToBounds = YES;
    [_btnB addTarget:self action:@selector(btnBClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnB];
    
    _btnA = [[UIButton alloc] initWithFrame:CGRectMake(m, WINDOW_HEIGHT - 2 * (m + h), WINDOW_WIDTH - m * 2, h)];
    _btnA.layer.cornerRadius = 2.5;
    _btnA.layer.masksToBounds = YES;
    _btnA.backgroundColor = SelfOrangeColor;
    [_btnA addTarget:self action:@selector(btnAClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnA];
}
/**
 设置交换商品展示
 */
- (void)setGoods{
    WPExchangeOrderCell *cell = [[NSBundle mainBundle] loadNibNamed:@"WPExchangeOrderCell" owner:nil options:nil].lastObject;
    cell.frame = CGRectMake(0, 34, WINDOW_WIDTH, 250);
    cell.backgroundColor = [UIColor whiteColor];
    cell.model = self.model;
    cell.hideSomeInDetail = YES;
    [self.view insertSubview:cell belowSubview:self.myNavBar];
    [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)]];
}
- (void)endEdit{
    [self.view endEditing:YES];
}
/**
 设置导航栏
 */
- (void)setNavigation{
    self.myNavItem.title = @"订单详情";
    UILabel *rightBarItemL = [[UILabel alloc] init];
    self.rightNavL = rightBarItemL;
    
    rightBarItemL.textColor = [UIColor whiteColor];
    rightBarItemL.font = [UIFont systemFontOfSize:16];
    [rightBarItemL sizeToFit];
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    self.indicator.color = [UIColor whiteColor];
    self.indicator.hidesWhenStopped = YES;
    
    self.myNavItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:rightBarItemL],[[UIBarButtonItem alloc] initWithCustomView:self.indicator]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end

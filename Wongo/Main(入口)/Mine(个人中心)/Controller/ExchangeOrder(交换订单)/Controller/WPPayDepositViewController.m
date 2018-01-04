//
//  WPPayDepositViewController.m
//  Wongo
//
//  Created by rexsu on 2017/4/19.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPPayDepositViewController.h"
#import "WPMyNavigationBar.h"
#import "LYAliPayResult.h"
#import "LYAliPayResultController.h"

@interface WPPayDepositViewController ()
{
    PayMoneyBlock _payMoneyBlock;
}
/**导航*/
@property (strong, nonatomic) WPMyNavigationBar *nav;
/**平台说明*/
@property (weak, nonatomic) IBOutlet UILabel    * instructions;
/**金额*/
@property (weak, nonatomic) IBOutlet UILabel    * price;
/**支付宝按钮*/
@property (weak, nonatomic) IBOutlet UIButton   * zfbButton;
/**跳转第三方付款按钮*/
@property (weak, nonatomic) IBOutlet UIButton *pay;

@property (weak, nonatomic) IBOutlet UITextField * payAmountField;
//订单号
@property (nonatomic, strong) NSDictionary * params;
@property (nonatomic, assign) CGFloat myAmount;
@property (nonatomic,strong)NSString * aliPayUrl;
@end

@implementation WPPayDepositViewController

-(instancetype)initWithParams:(NSDictionary *)params price:(CGFloat)price aliPayUrl:(NSString *)aliPayUrl{
    if (self = [super init]) {
        self.params = params;
        self.myAmount = price;
        self.aliPayUrl = aliPayUrl;
    }
    return self;
}
-(WPMyNavigationBar *)nav
{
    if (!_nav) {
        _nav = [[WPMyNavigationBar alloc]init];
        _nav.title.text = @"支付保证金";
        [_nav.leftButton addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nav;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.nav];
    _pay.layer.masksToBounds = YES;
    _pay.layer.cornerRadius  = 5;
    self.payAmountField.text = [NSString stringWithFormat:@"￥%.2f",[self notRounding:self.myAmount afterPoint:2]];
    [[NSNotificationCenter defaultCenter] postNotificationName:AliPay_PaymentNotice object:self userInfo:@{@"payType":self.aliPayUrl}];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayBack:) name:self.aliPayUrl object:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**支付回调 */
- (void)alipayBack:(NSNotification *)note{
    [self.navigationController popViewControllerAnimated:NO];
//    NSDictionary *result = note.object;
//    __block typeof(self)weakSelf = self;
//    LYAliPayResult *res = [LYAliPayResult mj_objectWithKeyValues:result];
//    if (res.resultStatus == 9000||res.resultStatus == 8000 || res.resultStatus == 6004|| res.resultStatus == 6001) {
//        //9000	订单支付成功
//        //8000	正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
//        //6004	支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
//        if ([weakSelf.aliPayUrl isEqualToString:AliPaySignup]) {
//            if (_payMoneyBlock) {
//                _payMoneyBlock(res.resultStatus);
//            }
//            [weakSelf.navigationController popViewControllerAnimated:YES];
//            return;
//        }
//        LYAliPayResultController * vc = [[LYAliPayResultController alloc] init];
//        vc.result = res;
//        [self.navigationController pushViewController:vc animated:NO];
//    } else {
//        [SVProgressHUD showErrorWithStatus:res.memo];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
//        });
//    }
}

-(void)getStateBlock:(PayMoneyBlock)block{
    _payMoneyBlock = block;
}

/**选择支付方式按钮*/
- (IBAction)selectPayStyle:(UIButton *)sender {
    _pay.tag = 111;
}

/**前往选择的支付第三方*/
- (IBAction)jumpPayThird:(UIButton *)sender {
    // NOTE: 调用支付结果开始支付
    CGFloat f = [self notRounding:[self.payAmountField.text substringFromIndex:1].floatValue afterPoint:2];
    NSLog(@"%@",[self.payAmountField.text substringFromIndex:1]);
    CGFloat v = [self notRounding:self.myAmount * 0.3 afterPoint:2];
    if (f >= v) {
        __block typeof(self)weakSelf = self;
        [WPNetWorking createPostRequestMenagerWithUrlString:self.aliPayUrl params:self.params datas:^(NSDictionary *responseObject) {
            NSString *appScheme = @"wongo";
            [[AlipaySDK defaultService] payOrder:responseObject[@"orderStr"] fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
            }];

        }];
    }else{
        [self showAlertWithAlertTitle:nil message:@"保证金金额须为商品标价的30%以上！" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
    }
}
/**四舍五入*/
-(CGFloat)notRounding:(float)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
 
    return roundedOunces.floatValue;
}

/**限制输入的金额格式*/
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *str = [NSMutableString stringWithString:textField.text];
    [str replaceCharactersInRange:range withString:string];
    
    if (textField.text.length > 10) {
        return range.location < 11;
    }else{
        BOOL isHaveDian = YES;
        if ([textField.text rangeOfString:@"."].location==NSNotFound) {
            isHaveDian=NO;
        }
        if ([string length]>0)
        {
            unichar single=[string characterAtIndex:0];//当前输入的字符
            
            if ((single >='0' && single<='9') || single=='.')//数据格式正确
            {
                //首字母不能为小数点
                if([textField.text length]==0){
                    if(single == '.'){
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                if([textField.text length]==1 && [textField.text isEqualToString:@"0"]){
                    if(single != '.'){
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                if (single=='.')
                {
                    if(!isHaveDian)//text中还没有小数点
                    {
                        isHaveDian=YES;
                        return YES;
                    }else
                    {
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                else
                {
                    if (isHaveDian)//存在小数点
                    {
                        //判断小数点的位数
                        NSRange ran=[textField.text rangeOfString:@"."];
                        NSInteger tt=range.location-ran.location;
                        if (tt <= 2){
                            return YES;
                        }else{
                            return NO;
                        }
                    }
                    else
                    {
                        return YES;
                    }
                }
            }else{//输入的数据格式不正确
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        else
        {
            return YES;
        }
    }
}

@end

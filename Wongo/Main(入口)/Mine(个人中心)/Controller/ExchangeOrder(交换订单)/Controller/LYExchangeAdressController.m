//
//  LYExchangeAdressController.m
//  Wongo
//
//  Created by  WanGao on 2017/6/6.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "LYExchangeAdressController.h"
#import "WPAddressSelectViewController.h"
@interface LYExchangeAdressController ()
@property (weak, nonatomic) IBOutlet UILabel *myAddr;
@property (weak, nonatomic) IBOutlet UILabel *otherAddr;
@property (weak, nonatomic) IBOutlet UIButton *setMyAddr;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@end

@implementation LYExchangeAdressController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myNavItem.title = @"订单地址";
    self.indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.indicator.color = [UIColor whiteColor];
    self.indicator.hidesWhenStopped = YES;
    self.myNavItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.indicator];
    if (self.detailModel.myaddress) {
        self.myAddr.text = self.detailModel.myaddress;
        self.setMyAddr.hidden = YES;
    }
    if (self.detailModel.address) {
        self.otherAddr.text = self.detailModel.address;
    }
}

- (IBAction)setMyAddrClick:(UIButton *)sender {
    WPAddressSelectViewController * vc = [[WPAddressSelectViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
    [vc getAdidAndAddressWithBlock:^(WPAddressModel *address) {
        [self.indicator startAnimating];
        NSString *addr = [NSString stringWithFormat:@"%@\n%@\n%@\n",address.consignee,address.phone,address.address];
        self.myAddr.text = addr;
        
        [WPNetWorking createPostRequestMenagerWithUrlString:UpdateOrderAddressUrl params:@{@"ordernum":self.model.ordernum,@"uid":self.getSelfUid,@"address":addr} datas:^(NSDictionary *responseObject) {
            [self.indicator stopAnimating];
            int flag = 0;
            if ([responseObject isKindOfClass:[NSDictionary class]] && (flag = [responseObject[@"flag"] intValue]) == 1) {
                self.setMyAddr.hidden = YES;
                self.detailModel.myaddress = addr;
                [SVProgressHUD showSuccessWithStatus:@"设置成功！"];
            }else{
                [SVProgressHUD showErrorWithStatus:@"设置失败，请重试"];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        } failureBlock:^{
            [self.indicator stopAnimating];
        }];
        
    }];
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}

@end

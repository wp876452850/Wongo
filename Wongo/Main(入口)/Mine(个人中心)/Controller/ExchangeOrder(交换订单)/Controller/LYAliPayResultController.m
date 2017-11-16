//
//  LYAliPayResultController.m
//  Wongo
//
//  Created by  WanGao on 2017/6/6.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "LYAliPayResultController.h"

@interface LYAliPayResultController ()

@end

@implementation LYAliPayResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] init];
    label.textColor = SelfOrangeColor;
    if (self.result.resultStatus == 9000) {
        label.text = @"支付成功";
        label.textColor = [UIColor blackColor];
    }
    else if (self.result.resultStatus == 6001){
        label.text = @"取消支付";
        label.textColor = [UIColor blackColor];
    }
    else if (self.result.resultStatus == 8000){
        label.text = @"支付结果处理中,请勿重复支付";
        label.textColor = [UIColor blackColor];
    }

    else{
         label.text = @"支付结果未知,稍后查询订单,请勿重复支付！";
    }

    
    
    [label sizeToFit];
    label.center = self.view.center;
    label.centerY -= 70;
    [self.view addSubview:label];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH * 0.5, 38)];
    btn.center = self.view.center;
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = SelfOrangeColor.CGColor;
    [btn setTitle:@"返回首页" forState:UIControlStateNormal];
    [btn setTitleColor:SelfOrangeColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(gotoHome:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)gotoHome:(UIButton *)btn{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end

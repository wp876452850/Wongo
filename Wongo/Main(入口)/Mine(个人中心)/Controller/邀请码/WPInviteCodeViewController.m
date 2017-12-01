//
//  WPInviteCodeViewController.m
//  Wongo
//
//  Created by  WanGao on 2017/11/30.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPInviteCodeViewController.h"
#import "WPMyInviteCodeViewController.h"
#import "WPFillInviteCodeViewController.h"

#define ViewControllers @[[WPMyInviteCodeViewController class],[WPFillInviteCodeViewController class]]
@interface WPInviteCodeViewController ()

@end

@implementation WPInviteCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myNavItem.title = @"邀请码";
}

- (IBAction)chakanzijiyaoqingma:(UIButton *)sender {
    id vc = [[ViewControllers[sender.tag] alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end

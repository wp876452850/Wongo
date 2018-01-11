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
@property (weak, nonatomic) IBOutlet UIButton *top;
@property (weak, nonatomic) IBOutlet UIButton *bottom;

@end

@implementation WPInviteCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myNavItem.title = @"邀请码";
    self.top.layer.cornerRadius = 5.f;
    self.bottom.layer.cornerRadius = 5.f;
}

- (IBAction)chakanzijiyaoqingma:(UIButton *)sender {
    id vc = [[ViewControllers[sender.tag] alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end

//
//  WPFillInviteCodeViewController.m
//  Wongo
//
//  Created by  WanGao on 2017/11/30.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPFillInviteCodeViewController.h"

@interface WPFillInviteCodeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation WPFillInviteCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myNavItem.title = @"填写邀请码";
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 5.f;
}

- (IBAction)action:(id)sender {
    
}

@end

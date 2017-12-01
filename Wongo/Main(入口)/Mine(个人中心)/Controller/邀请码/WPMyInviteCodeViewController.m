//
//  WPMyInviteCodeViewController.m
//  Wongo
//
//  Created by  WanGao on 2017/11/30.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPMyInviteCodeViewController.h"

@interface WPMyInviteCodeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *inviteCode;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation WPMyInviteCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myNavItem.title = @"我的邀请码";
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 5.f;
    [self loadData];
}

-(void)loadData{
    __block typeof(self)weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:UserGetUrl params:@{@"uid":[self getSelfUid]} datas:^(NSDictionary *responseObject) {
        weakSelf.inviteCode.text = responseObject[@"second"];
    }];
}
- (IBAction)copy:(UIButton *)sender {
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    
    NSString *string = self.inviteCode.text;
    
    [pab setString:string];
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:2.f];
    if (pab == nil) {
        hud.labelText = @"复制失败";
    }else
    {
        hud.labelText = @"复制成功";
    }
}

@end

//
//  UIViewController+WPCategory.m
//  Wongo
//
//  Created by rexsu on 2016/12/15.
//  Copyright © 2016年 Wongo. All rights reserved.
//

#import "UIViewController+WPCategory.h"
#import "LYBaseController.h"
#import "WPReportBox.h"
#import "LYConversationController.h"

@implementation UIViewController (WPCategory)

- (void)w_popViewController{
    [self.navigationController popViewControllerWithAnimation:YES];
}

- (void)w_dismissViewControllerAnimated{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)w_backGroudColor:(UIColor *)color
{
    self.view.backgroundColor = color;
}
- (void)w_changeBtnSelect:(UIButton *)sender{
    sender.selected = !sender.selected;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)showAlertWithAlertTitle:(NSString *)alertTitle message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle actionTitles:(NSArray *)actionTitles
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:alertTitle message:message preferredStyle:preferredStyle];
    for (int i = 0; i < actionTitles.count; i++) {
        UIAlertAction * action = [UIAlertAction actionWithTitle:actionTitles[i] style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        
    }
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)showAlertWithAlertTitle:(NSString *)alertTitle message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle actionTitles:(NSArray *)actionTitles block:(WPAlertBlock)block{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:alertTitle message:message preferredStyle:preferredStyle];
    for (int i = 0; i < actionTitles.count; i++) {
        UIAlertAction * action = [UIAlertAction actionWithTitle:actionTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (block&&i==0) {
                block();
            }
        }];
        [alert addAction:action];
        
    }
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)showAlertWithAlertTitle:(NSString *)alertTitle message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle actions:(NSArray *)actions{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:alertTitle message:message preferredStyle:preferredStyle];
    for (int i = 0; i < actions.count; i++) {
        UIAlertAction * action = actions[i];
        [alert addAction:action];
    }
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)showAlertNotOpenedWithBlock:(WPAlertBlock)block{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"功能暂未开放" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (block) {
            block();
        }
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)navigationLeftPop{
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

-(void)clickfunctionButtonWithGid:(NSString *)gid{
    UIAlertAction * report = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        LYBaseController * vc = [[LYBaseController alloc]init];
        vc.myNavItem.title = @"请选择举报原因";
        WPReportBox * reportBox = [WPReportBox createReportBoxWithGid:gid];
        [vc.view addSubview:reportBox];
        [vc.view sendSubviewToBack:reportBox];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    UIAlertAction * help = [UIAlertAction actionWithTitle:@"客服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self determineWhetherTheLogin]) {
            LYConversationController *vc = [[LYConversationController alloc] initWithConversationType:ConversationType_PRIVATE targetId:@"1"];
            vc.title = @"官方客服";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    UIAlertAction * share = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [WPShareController shareAppWithCurrentViewController:self];
    }];
    UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [self showAlertWithAlertTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet actions:@[report,help,share,cancle]];
}

-(void)clickfunctionButtonWithplid:(NSString *)plid{
    UIAlertAction * report = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        LYBaseController * vc = [[LYBaseController alloc]init];
        vc.myNavItem.title = @"请选择举报原因";
        WPReportBox * reportBox = [WPReportBox createReportBoxWithPlid:plid];
        [vc.view addSubview:reportBox];
        [vc.view sendSubviewToBack:reportBox];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    UIAlertAction * help = [UIAlertAction actionWithTitle:@"客服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self determineWhetherTheLogin]) {
            LYConversationController *vc = [[LYConversationController alloc] initWithConversationType:ConversationType_PRIVATE targetId:@"1"];
            vc.title = @"官方客服";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    UIAlertAction * share = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [WPShareController shareAppWithCurrentViewController:self];
    }];
    UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [self showAlertWithAlertTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet actions:@[report,help,share,cancle]];
}

- (void)showMBProgressHUDWithTitle:(NSString *)title{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    [hud hide:YES afterDelay:2.f];
}
@end

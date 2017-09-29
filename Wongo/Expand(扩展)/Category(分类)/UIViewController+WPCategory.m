//
//  UIViewController+WPCategory.m
//  Wongo
//
//  Created by rexsu on 2016/12/15.
//  Copyright © 2016年 Wongo. All rights reserved.
//

#import "UIViewController+WPCategory.h"

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

@end

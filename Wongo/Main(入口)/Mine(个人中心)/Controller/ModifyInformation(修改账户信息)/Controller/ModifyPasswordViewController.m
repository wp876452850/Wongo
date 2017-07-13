//
//  ModifyPasswordViewController.m
//  Wongo
//
//  Created by rexsu on 2017/5/5.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "WPMyNavigationBar.h"


@interface ModifyPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *originalPassword;
@property (weak, nonatomic) IBOutlet UITextField *changePassword;
@property (weak, nonatomic) IBOutlet UITextField *resultPassword;
@property (nonatomic,strong)WPMyNavigationBar * nav;
@end

@implementation ModifyPasswordViewController

-(WPMyNavigationBar *)nav{
    if (!_nav) {
        _nav = [[WPMyNavigationBar alloc]init];
        [_nav showRightButton];
        [_nav.rightButton setTitle:@"完成" forState:UIControlStateNormal];
        [_nav.leftButton addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
        [_nav.rightButton addTarget:self action:@selector(saveDatas) forControlEvents:UIControlEventTouchUpInside];
        _nav.title.text = @"修改密码";
    }
    return _nav;
}

-(void)saveDatas{
    if (![_resultPassword.text isEqualToString:_changePassword.text]) {
        [self showAlertWithAlertTitle:@"提示" message:@"密码不一致" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确认"]];
        return;
    }
    if (![self checkPassword:_resultPassword.text]) {
        [self showAlertWithAlertTitle:@"提示" message:@"密码须由6-16位英文字母、数字、字符组合而成,(不能为纯数字、纯字母)" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
        return;
    }
    
    
    [WPNetWorking createPostRequestMenagerWithUrlString:UpdateUserUrl params:@{@"uid":[self getSelfUid],@"password":_originalPassword.text,@"newpassword":_resultPassword.text} datas:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"flag"] integerValue]==0) {
            [self showAlertWithAlertTitle:@"提示" message:@"原密码错误" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
        }
        else{
            [self showAlertWithAlertTitle:@"提示" message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"] block:^{
                [self w_popViewController];
            }];
        }
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.nav];
    [self.originalPassword addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.changePassword addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.resultPassword addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

//限制输入长度
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 16) {
        textField.text = [textField.text substringToIndex:16];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end

//
//  RegisterViewController.m
//  MY
//
//  Created by rexsu on 2016/11/28.
//  Copyright © 2016年 Winny. All rights reserved.
//

#import "RegisterViewController.h"
#import "LYWanGaoUserAgreementController.h"

@interface RegisterViewController ()<UITextFieldDelegate>
{
    SuccessfulRegister _registerBlock;
}
@property (nonatomic,strong)WPCostomTextField * user;
@property (nonatomic,strong)WPCostomTextField * password;
@property (nonatomic,strong)WPCostomTextField * resultPassword;
@property (nonatomic,strong)WPCostomTextField * yaoqinma;
@property (nonatomic,strong)UIButton          * registerUser;
@property (nonatomic,strong)UIButton            * backButton;
@property (nonatomic, strong) UIButton *userAgreement;
@property (nonatomic,strong)UIImageView * bgImage;
@end

@implementation RegisterViewController
-(UIImageView *)bgImage{
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loginbg"]];
        _bgImage.frame = self.view.frame;
    }
    return _bgImage;
}
-(WPCostomTextField *)user{
    if (!_user) {
        _user = [WPCostomTextField createCostomTextFieldWithFrame:CGRectMake(100, 200, 100, 30) openRisingView:YES superView:self.view];
        _user.placeholder = @"请输入账号";
        _user.delegate    = self;
    }
    return _user;
}
-(WPCostomTextField *)password{
    if (!_password) {
        _password = [WPCostomTextField createCostomTextFieldWithFrame:CGRectMake(100, 300, 100, 30) openRisingView:YES superView:self.view];
        _password.placeholder       = @"请输入密码";
        _password.secureTextEntry   = YES;
        _password.delegate          = self;
    }
    return _password;
}
-(WPCostomTextField *)resultPassword{
    if (!_resultPassword) {
        _resultPassword = [WPCostomTextField createCostomTextFieldWithFrame:CGRectMake(100, 300, 100, 30) openRisingView:YES superView:self.view];
        _resultPassword.placeholder         = @"请确认密码";
        _resultPassword.secureTextEntry     = YES;
        _resultPassword.delegate            = self;
    }
    return _resultPassword;
}
-(WPCostomTextField *)yaoqinma{
    if (!_yaoqinma) {
        _yaoqinma = [WPCostomTextField createCostomTextFieldWithFrame:CGRectMake(100, 300, 100, 30) openRisingView:YES superView:self.view];
        _yaoqinma.placeholder         = @"请输入邀请码(选填)";
        _yaoqinma.secureTextEntry     = YES;
        _yaoqinma.delegate            = self;
    }
    return _yaoqinma;
}

-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setBackgroundImage:[UIImage imageNamed:@"loginback"] forState:UIControlStateNormal];
        _backButton.frame = CGRectMake(10, 15, 15, 25);
    }
    return _backButton;
}
- (UIButton *)userAgreement{
    if (!_userAgreement) {
        _userAgreement = [[UIButton alloc] init];
        [_userAgreement setTitleColor:SelfThemeColor forState:UIControlStateNormal];
        _userAgreement.titleLabel.font = [UIFont systemFontOfSize:14];
        [_userAgreement setTitle:@"注册即同意《碗糕用户服务协议》" forState:UIControlStateNormal];
        [_userAgreement sizeToFit];
        [_userAgreement addTarget:self action:@selector(agreement:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userAgreement;
}
- (void)agreement:(UIButton *)btn{
    [self presentViewController:[[LYWanGaoUserAgreementController alloc] init] animated:YES completion:nil];
}
-(UIButton *)registerUser{
    if (!_registerUser) {
        _registerUser = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerUser addTarget:self action:@selector(actionRegister) forControlEvents:UIControlEventTouchUpInside];
        [_registerUser setBackgroundImage:[UIImage imageNamed:@"registerbtn"] forState:UIControlStateNormal];
    }
    return _registerUser;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    self.navigationItem.title = @"注册";
    [self.view addSubview:self.bgImage];
    [self navigationLeftPop];
    [self.view addSubview:self.user];
    [self.view addSubview:self.password];
    [self.view addSubview:self.registerUser];
    [self.view addSubview:self.resultPassword];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.userAgreement];
    [self.view addSubview:self.yaoqinma];
    [self masonry];
    
}

-(void)masonry{
    [_user mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60);
        make.right.mas_equalTo(-60);
        make.bottom.mas_equalTo(-340);
        make.height.mas_equalTo(30);
    }];
    [_password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60);
        make.right.mas_equalTo(-60);
        make.bottom.mas_equalTo(-290);
        make.height.mas_equalTo(30);
    }];
    [_resultPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60);
        make.right.mas_equalTo(-60);
        make.bottom.mas_equalTo(-240);
        make.height.mas_equalTo(30);
    }];
    [_yaoqinma mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60);
        make.right.mas_equalTo(-60);
        make.bottom.mas_equalTo(-190);
        make.height.mas_equalTo(30);
    }];
    
    
    [_registerUser mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(-120);
        make.height.mas_equalTo(40);
    }];
    [_userAgreement mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_registerUser);
        make.top.equalTo(_registerUser.mas_bottom).offset(5);
    }];
    UILabel * label1 = [[UILabel alloc]init];
    [self.view addSubview:label1];
    UILabel * label2 = [[UILabel alloc]init];
    [self.view addSubview:label2];
    UILabel * label3 = [[UILabel alloc]init];
    [self.view addSubview:label3];
    UILabel * label4 = [[UILabel alloc]init];
    [self.view addSubview:label4];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_user.mas_bottom).offset(-1);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
    }];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_password.mas_bottom).offset(-1);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
    }];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_resultPassword.mas_bottom).offset(-1);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
    }];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_yaoqinma.mas_bottom).offset(-1);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
    }];
    label1.backgroundColor = ColorWithRGB(255, 204, 92);
    label2.backgroundColor = ColorWithRGB(255, 204, 92);
    label3.backgroundColor = ColorWithRGB(255, 204, 92);
    label4.backgroundColor = ColorWithRGB(255, 204, 92);
}
-(void)actionRegister{
#warning 发送请求
    self.view.userInteractionEnabled = NO;
    if (![self checkUserName:_user.text]) {
        [self showAlertWithAlertTitle:@"提示" message:@"账号须由6-16位英文字母、数字" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
        self.view.userInteractionEnabled = YES;
        return;
    }
    if (![_password.text isEqualToString:_resultPassword.text]) {
        [self showAlertWithAlertTitle:@"提示" message:@"确认密码不一致" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]block:^{
            self.view.userInteractionEnabled = YES;
        }];
        return;
    }
    if (![self checkPassword:_resultPassword.text]) {
        [self showAlertWithAlertTitle:@"提示" message:@"密码须由6-16位英文字母、数字、字符组合而成,(不能为纯数字、纯字母)" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
        self.view.userInteractionEnabled = YES;
        return;
    }
    
    [WPNetWorking createPostRequestMenagerWithUrlString:UseraddUrl params:@{@"uname":_user.text,@"password":_password.text,@"activation":_yaoqinma.text} datas:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"flag"] integerValue] == 1) {
            [self showAlertWithAlertTitle:@"提示" message:[responseObject objectForKey:@"msg"] preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"] block:^{
                if (_registerBlock) {
                    _registerBlock(_user.text,_password.text);
                }
                [self w_popViewController];
            }];
        }
        else{
            [self showAlertWithAlertTitle:@"提示" message:[responseObject objectForKey:@"msg"] preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]block:^{
                self.view.userInteractionEnabled = YES;
            }];
        }
    } failureBlock:^{
        self.view.userInteractionEnabled = YES;
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)getRegisterUserAndPasswordWithBlock:(SuccessfulRegister)block{
    _registerBlock = block;
}

//限制输入长度
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 16) {
        textField.text = [textField.text substringToIndex:16];
    }
}

@end

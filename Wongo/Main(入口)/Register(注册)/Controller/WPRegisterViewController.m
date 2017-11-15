//
//  WPRegisterViewController.m
//  Wongo
//
//  Created by  WanGao on 2017/11/14.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPRegisterViewController.h"
#import "LYWanGaoUserAgreementController.h"

@interface WPRegisterViewController ()<UITextFieldDelegate>
{
    SuccessfulRegister _registerBlock;
}
@property (nonatomic,strong)WPCostomTextField   * phoneNumber;
@property (nonatomic,strong)WPCostomTextField   * verificationCode;
@property (nonatomic,strong)UIButton            * registerUser;
@property (nonatomic,strong)UIButton            * backButton;
@property (nonatomic,strong)UIButton            * userAgreement;
@property (nonatomic,strong)UIButton            * verificationCodeButton;
@property (nonatomic,strong)UIImageView         * bgImage;

@end

@implementation WPRegisterViewController

-(UIImageView *)bgImage{
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loginbg"]];
        _bgImage.frame = self.view.frame;
    }
    return _bgImage;
}

-(WPCostomTextField *)phoneNumber{
    if (!_phoneNumber) {
        _phoneNumber = [WPCostomTextField createCostomTextFieldWithFrame:CGRectMake(100, 200, 100, 30) openRisingView:YES superView:self.view];
        _phoneNumber.placeholder    = @"请输入手机号";
        _phoneNumber.keyboardType   = UIKeyboardTypePhonePad;
        _phoneNumber.delegate       = self;
    }
    return _phoneNumber;
}

-(WPCostomTextField *)verificationCode{
    if (!_verificationCode) {
        _verificationCode = [WPCostomTextField createCostomTextFieldWithFrame:CGRectMake(100, 300, 100, 30) openRisingView:YES superView:self.view];
        _verificationCode.placeholder       = @"请输入验证码";
        _verificationCode.keyboardType      = UIKeyboardTypePhonePad;
        _verificationCode.delegate          = self;
        _verificationCode.userInteractionEnabled = NO;
    }
    return _verificationCode;
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
        [_userAgreement setTitleColor:SelfOrangeColor forState:UIControlStateNormal];
        _userAgreement.titleLabel.font = [UIFont systemFontOfSize:14];
        [_userAgreement setTitle:@"注册即同意《碗糕用户服务协议》" forState:UIControlStateNormal];
        [_userAgreement sizeToFit];
        [_userAgreement addTarget:self action:@selector(agreement:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userAgreement;
}

-(UIButton *)verificationCodeButton{
    if (!_verificationCodeButton) {
        _verificationCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _verificationCodeButton.backgroundColor = SelfOrangeColor;
        [_verificationCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_verificationCodeButton addTarget:self action:@selector(pushVerificationCode) forControlEvents:UIControlEventTouchUpInside];
        _verificationCodeButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _verificationCodeButton;
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
    [self.view addSubview:self.phoneNumber];
    [self.view addSubview:self.verificationCode];
    [self.view addSubview:self.registerUser];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.userAgreement];
    [self.view addSubview:self.verificationCodeButton];
    [self masonry];
}

-(void)masonry{
    __block typeof(self)weakSelf = self;
    [_phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60);
        make.right.mas_equalTo(-60);
        make.bottom.mas_equalTo(-340);
        make.height.mas_equalTo(30);
    }];
    [_verificationCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60);
        make.right.mas_equalTo(-120);
        make.bottom.mas_equalTo(-260);
        make.height.mas_equalTo(30);
    }];
    [_verificationCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(90);
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(-260);
        make.height.mas_equalTo(50);
    }];
    [_registerUser mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(-120);
        make.height.mas_equalTo(40);
    }];
    [_userAgreement mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.registerUser);
        make.top.equalTo(weakSelf.registerUser.mas_bottom).offset(5);
    }];
    
    UILabel * label1 = [[UILabel alloc]init];
    [self.view addSubview:label1];
    UILabel * label2 = [[UILabel alloc]init];
    [self.view addSubview:label2];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.phoneNumber.mas_bottom).offset(-1);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
    }];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.verificationCode.mas_bottom).offset(-1);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-120);
    }];
    label1.backgroundColor = ColorWithRGB(255, 204, 92);
    label2.backgroundColor = ColorWithRGB(255, 204, 92);
}

#pragma mark - 点击事件
//注册
-(void)actionRegister{
    
    
}
//发送验证码
-(void)pushVerificationCode{
    self.verificationCode.userInteractionEnabled = YES;
    
}
//碗糕服务协议
- (void)agreement:(UIButton *)btn{
    [self presentViewController:[[LYWanGaoUserAgreementController alloc] init] animated:YES completion:nil];
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

//
//  WPRegisterViewController.m
//  Wongo
//
//  Created by  WanGao on 2017/11/14.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPRegisterViewController.h"
#import "LYWanGaoUserAgreementController.h"
#import "WPTimerTool.h"

@interface WPRegisterViewController ()<UITextFieldDelegate>
{
    SuccessfulRegister _registerBlock;
}
/**电话号码*/
@property (nonatomic,strong)WPCostomTextField   * phoneNumber;
/**验证码*/
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
        [_userAgreement setTitleColor:SelfThemeColor forState:UIControlStateNormal];
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
        _verificationCodeButton.backgroundColor = SelfThemeColor;
        [_verificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_verificationCodeButton addTarget:self action:@selector(pushVerificationCode) forControlEvents:UIControlEventTouchUpInside];
        _verificationCodeButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _verificationCodeButton;
}

-(UIButton *)registerUser{
    if (!_registerUser) {
        _registerUser = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerUser.layer.masksToBounds = YES;
        _registerUser.layer.cornerRadius = 20.f;
        _registerUser.layer.borderWidth = 1.f;
        _registerUser.layer.borderColor = SelfThemeColor.CGColor;
        [_registerUser setTitleColor:SelfThemeColor forState:UIControlStateNormal];
        [_registerUser setTitle:@"注册" forState:UIControlStateNormal];
        [_registerUser addTarget:self action:@selector(actionRegister) forControlEvents:UIControlEventTouchUpInside];
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
        make.right.mas_equalTo(-121);
        make.bottom.mas_equalTo(-285);
        make.height.mas_equalTo(30);
    }];
    [_verificationCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(90);
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(-285);
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
    UILabel * label3 = [[UILabel alloc]init];
    [self.view addSubview:label3];
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
        make.right.mas_equalTo(-121);
    }];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.verificationCode.mas_bottom).offset(2);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-121);
    }];
    label1.backgroundColor = SelfThemeColor;
    label2.backgroundColor = SelfThemeColor;
    label3.textColor = TitleGrayColor;
    label3.text = @"注册后默认密码为123456,可在设置界面修改";
    label3.font = [UIFont systemFontOfSize:11.f];
}

#pragma mark - 点击事件
//注册
-(void)actionRegister{
    [WPNetWorking createPostRequestMenagerWithUrlString:UseraddUrl params:@{@"mobile":self.phoneNumber.text,@"compare":self.verificationCode.text} datas:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"flag"] integerValue] == 1) {
            [self showAlertWithAlertTitle:@"提示" message:[responseObject objectForKey:@"msg"] preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"] block:^{
                if (_registerBlock) {
                    _registerBlock(_phoneNumber.text,@"123456");
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
        
    }];
}
//发送验证码
-(void)pushVerificationCode{
    if (![self isMobileNumber:self.phoneNumber.text]) {
        [self showAlertWithAlertTitle:@"提示" message:@"电话号码格式不正确" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
        return;
    }
    self.verificationCode.userInteractionEnabled = YES;
    [WPTimerTool createCountdownWithTime:60 sender:self.verificationCodeButton block:^{
        
    }];
    [WPNetWorking createPostRequestMenagerWithUrlString:SendUrl params:@{@"mobile":self.phoneNumber.text} datas:^(NSDictionary *responseObject) {
        
    } failureBlock:^{
        NSLog(@"发送失败");
    }];
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

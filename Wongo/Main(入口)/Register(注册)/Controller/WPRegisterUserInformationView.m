//
//  WPRegisterUserInformationView.m
//  Wongo
//
//  Created by  WanGao on 2017/11/27.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPRegisterUserInformationView.h"
#import "WPCostomTextField.h"

@interface WPRegisterUserInformationView ()
@property (nonatomic,strong)NSString * phoneNumber;
@property (nonatomic,strong)NSString * compare;

@property (nonatomic,strong)UIButton * registerButton;
@property (nonatomic,strong)WPCostomTextField * userName;
@property (nonatomic,strong)WPCostomTextField * password;

@end

@implementation WPRegisterUserInformationView

-(WPCostomTextField *)userName{
    if (!_userName) {
        _userName = [WPCostomTextField createCostomTextFieldWithFrame:CGRectMake(100, 400, 100, 40) openRisingView:YES superView:self];
        _userName.placeholder       = @"请输入账号";
    }
    return _userName;
}
-(WPCostomTextField *)password{
    if (!_password) {
        _password = [WPCostomTextField createCostomTextFieldWithFrame:CGRectMake(100, 500, 100, 40) openRisingView:YES superView:self];
        _password.placeholder       = @"请输入密码";
        _password.secureTextEntry   = YES;
    }
    return _password;
}
-(UIButton *)registerButton{
    if (!_registerButton) {
        _registerButton.layer.masksToBounds = YES;
        _registerButton.layer.cornerRadius = 20.f;
        _registerButton.layer.borderWidth = 1.f;
        _registerButton.layer.borderColor = SelfThemeColor.CGColor;
        [_registerButton setTitleColor:SelfThemeColor forState:UIControlStateNormal];
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(actionRegister) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}


-(instancetype)initWithPhoneNumber:(NSString *)phoneNumber compare:(NSString *)compare{
    if (self = [super init]) {
        self.phoneNumber = phoneNumber;
        self.compare = compare;
        [self addSubview:self.registerButton];
        [self addSubview:self.password];
        [self addSubview:self.userName];
    }
    return self;
}


-(void)actionRegister{
#warning 发送请求
    
}

@end

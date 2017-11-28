//
//  LoginViewController.m
//  我的
//
//  Created by rexsu on 2016/11/28.
//  Copyright © 2016年 Winny. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "WPNetWorking.h"
#import <UMSocialCore/UMSocialCore.h>
#import "WPRegisterViewController.h"
#define icons @[@"sina",@"QQ",@"wechat"]

@interface LoginViewController ()

@property (nonatomic,strong)UIButton * loginBtn;
@property (nonatomic,strong)UIButton * registerBtn;
@property (nonatomic,strong)WPCostomTextField * user;
@property (nonatomic,strong)WPCostomTextField * password;
@property (nonatomic,strong)UIButton * backButton;
@property (nonatomic,strong)UIImageView * bgImage;

@end

@implementation LoginViewController
#pragma mark - 懒加载
-(UIButton *)loginBtn
{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.layer.cornerRadius = 20.f;
        _loginBtn.backgroundColor = SelfThemeColor;
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(clickLogin) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

-(UIButton *)registerBtn
{
    if (!_registerBtn) {
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerBtn.layer.masksToBounds = YES;
        _registerBtn.layer.cornerRadius = 20.f;
        _registerBtn.layer.borderWidth = 1.f;
        _registerBtn.layer.borderColor = SelfThemeColor.CGColor;
        [_registerBtn setTitleColor:SelfThemeColor forState:UIControlStateNormal];
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_registerBtn addTarget:self action:@selector(goRegister) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}

-(WPCostomTextField *)user{
    if (!_user) {
        _user = [WPCostomTextField createCostomTextFieldWithFrame:CGRectMake(100, 400, 100, 40) openRisingView:YES superView:self.view];
        _user.placeholder       = @"请输入账号";
        
    }
    return _user;
}

-(WPCostomTextField *)password{
    if (!_password) {
        _password = [WPCostomTextField createCostomTextFieldWithFrame:CGRectMake(100, 500, 100, 40) openRisingView:YES superView:self.view];
        _password.placeholder       = @"请输入密码";
        _password.secureTextEntry   = YES;
    }
    return _password;
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
-(UIImageView *)bgImage
{
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loginbg"]];
        _bgImage.frame = self.view.frame;
    }
    return _bgImage;
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
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(-180);
        make.height.mas_equalTo(40);
    }];
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(-120);
        make.height.mas_equalTo(40);
    }];
    UILabel * label1 = [[UILabel alloc]init];
    [self.view addSubview:label1];
    UILabel * label2 = [[UILabel alloc]init];
    [self.view addSubview:label2];
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
    label1.backgroundColor = SelfThemeColor;
    label2.backgroundColor = SelfThemeColor;
    
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, WINDOW_HEIGHT-90, 90, 20)];
    label.centerX = WINDOW_WIDTH/2;
    label.text = @"第三方登录";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13.f];
    label.textColor = SelfThemeColor;
    [self.view.layer addSublayer:[WPBezierPath drowLineWithMoveToPoint:CGPointMake(40, label.centerY) moveForPoint:CGPointMake(label.left - 10, label.centerY) lineColor:SelfThemeColor]];
    [self.view.layer addSublayer:[WPBezierPath drowLineWithMoveToPoint:CGPointMake(WINDOW_WIDTH-40, label.centerY) moveForPoint:CGPointMake(label.right + 10, label.centerY) lineColor:SelfThemeColor]];
    
    [self.view addSubview:label];
    
    for (int i = 0; i<3; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((WINDOW_WIDTH-35)/4*(i+1), WINDOW_HEIGHT-50, 30, 30);
        [button setImage:[UIImage imageNamed:icons[i]] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(thirdPartyLogin:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}
-(void)thirdPartyLogin:(UIButton *)sender{
    switch (sender.tag) {
        case 0:
        {
            [self getUserInfoForPlatform:UMSocialPlatformType_Sina];
        }
            break;
        case 1:
        {
            [self getUserInfoForPlatform:UMSocialPlatformType_QQ];
        }
            break;
        case 2:
        {
            [self getUserInfoForPlatform:UMSocialPlatformType_WechatSession];
        }
            break;
    }
}
#pragma mark - ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    self.navigationItem.title = @"登录";
    [self.view addSubview:self.bgImage];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.registerBtn];
    [self.view addSubview:self.user];
    [self.view addSubview:self.password];
    [self masonry];
    [self navigationLeftPop];
}
#pragma mark - 注册
//前往注册界面
-(void)goRegister{
    __weak LoginViewController * weakSelf = self;
    WPRegisterViewController * registerVC = [[WPRegisterViewController alloc]init];
//    RegisterViewController * registerVC = [[RegisterViewController alloc]init];
    [registerVC getRegisterUserAndPasswordWithBlock:^(NSString *user, NSString *password) {
        _user.text = user;
        _password.text = password;
        [weakSelf clickLogin];
    }];
    [self.navigationController pushViewController:registerVC animated:YES];
}
#pragma mark - 登录请求数据方式
//登录按钮
-(void)clickLogin{
    //进行数据请求后记录
    NSDictionary * params = @{@"uname":self.user.text,@"password":self.password.text};
    self.view.userInteractionEnabled = NO;
    __block LoginViewController * weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:LoginRequestUrl params:params datas:^(NSDictionary *responseObject) {
        [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"uname"] forKey:User_Name];
        UIImageView * headimage = [[UIImageView alloc]init];
        [headimage sd_setImageWithURL:[NSURL URLWithString:responseObject[@"url"]]];
        NSData * imageData = [NSKeyedArchiver archivedDataWithRootObject:headimage.image];
        [[NSUserDefaults standardUserDefaults]setObject:imageData forKey:User_Head];
        //记录用户信息
        if ([[responseObject objectForKey:@"flag"] isEqualToString:@"1"]) {
            [weakSelf loginSuccessWithSelf:weakSelf uid:responseObject[@"uid"]];
        }
        else{
            [weakSelf loginfailWithSelf:weakSelf];
        }
        
    } failureBlock:^{
        weakSelf.view.userInteractionEnabled = YES;
    }];
}

//第三方登录
-(void)ThirdPartyLoginWithSid:(NSString *)sid uname:(NSString *)uname url:(NSString *)url{
    __block typeof(self) weakSelf = self;
    //sid:获取的第三方平台账户uid
    [WPNetWorking createPostRequestMenagerWithUrlString:UseraddsUrl params:@{@"uname":uname,@"sid":sid,@"password":@"123456",@"url":url} datas:^(NSDictionary *responseObject) {
        if ([responseObject[@"flag"] integerValue] == 0) {
            [weakSelf loginfailWithSelf:weakSelf];
        }else
        [weakSelf loginSuccessWithSelf:weakSelf uid:responseObject[@"uid"]];
    } failureBlock:^{
        [weakSelf loginfailWithSelf:weakSelf];
    }];
}

//登录成功
-(void)loginSuccessWithSelf:(LoginViewController *)weakSelf uid:(NSString *)uid{
    
    [WPNetWorking createPostRequestMenagerWithUrlString:GetTokenUrl params:@{@"type":RCIMDEVTYPE,@"uid":uid} datas:^(NSDictionary *responseObject) {
        //记录token并登陆
        NSDictionary * dic = [responseObject objectForKey:@"token"];
        [[NSUserDefaults standardUserDefaults]setObject:[dic objectForKey:@"token"] forKey:User_Token];
        [[NSUserDefaults standardUserDefaults]setObject:[dic objectForKey:@"userId"] forKey:User_ID];
#pragma mark - 收藏 关注 点赞数据加载
        [NSMutableArray sharedFocusArray];
        [NSMutableArray sharedThumupArray];
        [NSMutableArray sharedCollectionArray];
        [NSMutableArray sharedThumupDreamingArray];
        [NSMutableArray sharedFansArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
        [[RCIM sharedRCIM] connectWithToken:[dic objectForKey:@"token"] success:^(NSString *userId) {
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        } error:^(RCConnectErrorCode status) {
            NSLog(@"登陆的错误码为:%ld", (long)status);
        } tokenIncorrect:^{
            NSLog(@"token错误");
            [WPNetWorking createPostRequestMenagerWithUrlString:GetTokenUrl params:@{@"type":RCIMDEVTYPE,@"uid":uid} datas:^(NSDictionary *responseObject) {
                //记录token并登陆
                NSDictionary * dic = [responseObject objectForKey:@"token"];
                [[NSUserDefaults standardUserDefaults]setObject:[dic objectForKey:@"token"] forKey:User_Token];
                [[NSUserDefaults standardUserDefaults]setObject:[dic objectForKey:@"userId"] forKey:User_ID];
                [[RCIM sharedRCIM] connectWithToken:[dic objectForKey:@"token"] success:^(NSString *userId) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    });
                } error:^(RCConnectErrorCode status) {
                    weakSelf.view.userInteractionEnabled = YES;
                } tokenIncorrect:^{
                    weakSelf.view.userInteractionEnabled = YES;
                }];
            }];
        }];
    }];
}

-(void)loginfailWithSelf:(LoginViewController *)weakSelf{
    [weakSelf showAlertWithAlertTitle:@"登录失败" message:@"账号/密码有误" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
    weakSelf.view.userInteractionEnabled = YES;
}



#pragma mark - 第三方登录操作

- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{
    [[UMSocialDataManager defaultManager] clearAllAuthorUserInfo];
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        NSLog(@" uid: %@", resp.uid);
        NSLog(@" openid: %@", resp.openid);
        NSLog(@" accessToken: %@", resp.accessToken);
        NSLog(@" refreshToken: %@", resp.refreshToken);
        NSLog(@" expiration: %@", resp.expiration);
        
        // 用户数据
        NSLog(@" name: %@", resp.name);
        NSLog(@" iconurl: %@", resp.iconurl);
        NSLog(@" gender: %@", resp.unionGender);
        
        // 第三方平台SDK原始数据
        NSLog(@" originalResponse: %@", resp.originalResponse);
        if (resp.uid.length>0) {
            [self ThirdPartyLoginWithSid:resp.uid uname:resp.name url:resp.iconurl];
        }
    }];
}
@end

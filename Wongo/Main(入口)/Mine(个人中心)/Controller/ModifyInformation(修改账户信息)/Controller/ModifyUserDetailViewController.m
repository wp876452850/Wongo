//
//  ModifyUserDetailViewController.m
//  Wongo
//
//  Created by rexsu on 2017/5/5.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "ModifyUserDetailViewController.h"
#import "WPCostomTextField.h"
#import "WPMyNavigationBar.h"
#import "WPMyViewController.h"

@interface ModifyUserDetailViewController ()<UITextViewDelegate>
@property (nonatomic,strong)NSString                * userNameString;
@property (nonatomic,strong)NSString                * signature;
@property (weak, nonatomic) IBOutlet UITextField    * userName;
@property (weak, nonatomic) IBOutlet UITextView     * signatureTextView;
@property (weak, nonatomic) IBOutlet UILabel        * limitLenghtLabel;
@property (nonatomic,strong)WPMyNavigationBar       * nav;
@end

@implementation ModifyUserDetailViewController
-(WPMyNavigationBar *)nav{
    if (!_nav) {
        _nav = [[WPMyNavigationBar alloc]init];
        [_nav showRightButton];
        [_nav.rightButton setTitle:@"保存" forState:UIControlStateNormal];
        [_nav.leftButton addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
        [_nav.rightButton addTarget:self action:@selector(saveDatas) forControlEvents:UIControlEventTouchUpInside];
        _nav.title.text = @"修改个人信息";
    }
    return _nav;
}
+(instancetype)createWithUserName:(NSString *)userName signature:(NSString *)signature{
    ModifyUserDetailViewController * vc = [[ModifyUserDetailViewController alloc]init];
    vc.userNameString   = userName;
    vc.signature        = signature;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.nav];
    
    
    self.userName.text                  = self.userNameString;
    self.signatureTextView.delegate     = self;
    self.signatureTextView.placeholder  = self.signature;
    self.signatureTextView.limitLength  = @(200);
    self.limitLenghtLabel.textAlignment = NSTextAlignmentRight;
    self.limitLenghtLabel.textColor     = [UIColor lightGrayColor];
    self.limitLenghtLabel.font          = [UIFont systemFontOfSize:13.];
    self.limitLenghtLabel.text          = [NSString stringWithFormat:@"%lu/%@",(unsigned long)self.signatureTextView.text.length,@(200)];
    
    [self.userName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    self.signatureTextView.layer.borderWidth = 1;
//    self.signatureTextView.layer.borderColor = ColorWithRGB(230, 230, 230).CGColor;
}

-(void)saveDatas{
    if (self.userName.text.length <= 0) {
        [self showAlertWithAlertTitle:@"提示" message:@"用户名不能为空" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
        return;
    }
    NSString * uname = @"";
    if (![_userNameString isEqualToString:_userName.text]) {
        uname = _userName.text;
    }
    WPMyViewController * vc = self.navigationController.viewControllers.firstObject;
    [WPNetWorking createPostRequestMenagerWithUrlString:UpdateUserUrl params:@{@"uname":uname,@"signature":_signatureTextView.text,@"uid":[self getSelfUid]} datas:^(NSDictionary *responseObject) {
        [self showAlertWithAlertTitle:@"提示" message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"] block:^{
            [vc.userInformationView loadDatas];
            [self w_popViewController];
        }];
    }];
}
//监控textView字数
- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length > 200 ) {
        textView.text = [textView.text substringToIndex:200];
    }
    self.limitLenghtLabel.text = [NSString stringWithFormat:@"%lu/%@",(unsigned long)textView.text.length,@(200)];
}
//限制输入长度
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 20) {
        textField.text = [textField.text substringToIndex:20];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end

//
//  WPIMChatViewController.m
//  Wongo
//
//  Created by  WanGao on 2017/11/28.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPIMChatViewController.h"
#import <RongIMLib/RongIMLib.h>

@interface WPIMChatViewController ()
@property (nonatomic,strong)NSString * userId;
@end

@implementation WPIMChatViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//链接融云服务器
-(void)linkToTheRongServer{
    __block typeof(self)weakSelf = self;
    [[RCIMClient sharedRCIMClient] connectWithToken:[self getUserToken]
                                            success:^(NSString *userId) {
                                                weakSelf.userId = userId;
                                                NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                                            } error:^(RCConnectErrorCode status) {
                                                NSLog(@"登陆的错误码为:%ld", (long)status);
                                            } tokenIncorrect:^{
                                                //token过期或者不正确。
                                                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                                                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                                                NSLog(@"token错误");
                                            }];
}


@end

//
//  AppDelegate.m
//  Wongo
//
//  Created by Winny on 2016/12/7.
//  Copyright © 2016年 Wongo. All rights reserved.
//

#import "AppDelegate.h"
#import "WPTabBarController.h"
#import "WPGuideViewController.h"
#import "WPUserIntroductionModel.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"

#define RONGCLOUD_IM_TOKEN  @"26yDFgVPSX8MPykDOdP86cpJiC88oLvizHSm/MXqzhfDeVfnPN76WyU+D/a3E1okCHM0fB1d5RVZjF4Wq3nO2Q=="//Token
/**友盟appkey*/
#define USHARE_APPKEY @"59ba345b75ca351ed90000a6"

/**
 *
 */

@interface AppDelegate ()<RCIMConnectionStatusDelegate,RCIMUserInfoDataSource,RCIMReceiveMessageDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#pragma mark - 引导页
    //判断是否第一次登录
    NSString * first = [[NSUserDefaults standardUserDefaults]objectForKey:FirstTimeTosStart];
    if (first.length<=0||!first) {
        WPGuideViewController * vc = [[WPGuideViewController alloc]init];
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
        self.window.rootViewController = nav;
        nav.navigationBarHidden = YES;
        [[NSUserDefaults standardUserDefaults]setObject:@"no" forKey:FirstTimeTosStart];
    }else{
        WPTabBarController * tabBar = [WPTabBarController sharedTabbarController];
        self.window.rootViewController = tabBar;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
#pragma mark - 即时聊天
    //初始化融云SDK
    [[RCIM sharedRCIM] initWithAppKey:RONGCLOUD_IM_APPKEY];
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    
    NSString * token = [[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
    if (token.length>0) {
        NSLog(@" token = %@",[[NSUserDefaults standardUserDefaults]objectForKey:User_Token]);
        [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        } error:^(RCConnectErrorCode status) {
            NSLog(@"登陆的错误码为:%ld", (long)status);
        } tokenIncorrect:^{
            NSLog(@"token错误");
            [WPNetWorking createPostRequestMenagerWithUrlString:GetTokenUrl params:@{@"type":RCIMDEVTYPE} datas:^(NSDictionary *responseObject) {
                //记录token并登陆
                NSDictionary * dic = [responseObject objectForKey:@"token"];
                [[NSUserDefaults standardUserDefaults]setObject:[dic objectForKey:@"token"] forKey:User_Token];
                [[NSUserDefaults standardUserDefaults]setObject:[dic objectForKey:@"userId"] forKey:User_ID];
                [[RCIM sharedRCIM] connectWithToken:[dic objectForKey:@"token"] success:^(NSString *userId) {
                } error:^(RCConnectErrorCode status) {
                } tokenIncorrect:^{
                }];
            }];
        }];
    }
    
    /**
     *    远程推送
     */
    
    /**
     * 统计推送打开率
     */
    [[RCIMClient sharedRCIMClient] recordLaunchOptionsEvent:launchOptions];
    
    /**
     * 获取融云推送服务扩展字段
     * nil 表示该启动事件不包含来自融云的推送服务
     */
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromLaunchOptions:launchOptions];
    if (pushServiceData) {
        NSLog(@"该启动事件包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"%@", pushServiceData[key]);
        }
    } else {
        NSLog(@"该启动事件不包含来自融云的推送服务");
    }
    
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, iOS 8
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#pragma mark - 分享
    
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_APPKEY];
    
    [self configUSharePlatforms];
    
    [self confitUShareSettings];
    
#pragma mark - 第三方登录

    
    return YES;
}



- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}

- (void)configUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx0917670ee24434e4" appSecret:@"0bcd448e908ed9c1bbe94949701db0e1" redirectURL:nil];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106339547"/*设置QQ平台的appID*/  appSecret:@"KEYBrnRPsrMOfPIuIHB" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
    /*
     设置新浪的appKey和appSecret
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"2803341004"  appSecret:@"38455b90bb576c0b39dca48c6cfe0ffe" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
}
#pragma mark 分享回调
// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

//**********************************************************************************//

//  注册用户通知设置
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"");
}
/**
 *  将得到的devicetoken 传给融云用于离线状态接收push ，您的app后台要上传推送证书
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    /**
     * 统计推送打开率
     */
    [[RCIMClient sharedRCIMClient] recordRemoteNotificationEvent:userInfo];
    
    /**
     * 获取融云推送服务扩展字段
     * nil 表示该启动事件不包含来自融云的推送服务
     */
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromRemoteNotification:userInfo];
    if (pushServiceData) {
        NSLog(@"该远程推送包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"key = %@, value = %@", key, pushServiceData[key]);
        }
    } else {
        NSLog(@"该远程推送不包含来自融云的推送服务");
    }
    
}


- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"您"
                              @"的帐号在别的设备上登录，您被迫下线！"
                              delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:User_ID];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:User_Token];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    [UIApplication sharedApplication].applicationIconBadgeNumber += 1;
    if (left == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE_REDDOT" object:nil];
    }
}
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *userInfo))completion{
    RCUserInfo *user = [[RCUserInfo alloc]init];
    if (userId == nil || [userId length] == 0) {
        user.userId = userId;
        user.portraitUri = @"";
        user.name = @"";
        completion(user);
        return;
    }
    //获取用户信息
    [WPNetWorking createPostRequestMenagerWithUrlString:UserGetUrl params:@{@"uid":userId} datas:^(NSDictionary *responseObject) {
        
        WPUserIntroductionModel *model = [WPUserIntroductionModel mj_objectWithKeyValues:responseObject];
        user.name = model.uname;
        user.portraitUri = model.url;
        completion(user);
        [[RCIM sharedRCIM] refreshUserInfoCache:user
                                     withUserId:userId];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"rcimReloadUserInfo" object:nil];
    }];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        //支付
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ALIPAY_DONE" object:resultDic];
            }];
        }
        return YES;
    }
    return result;
    
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if(![[UMSocialManager defaultManager] handleOpenURL:url]) {
        BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
        return result;
    }
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ALIPAY_DONE" object:resultDic];
        }];
    }
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [application setApplicationIconBadgeNumber:0];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [application setApplicationIconBadgeNumber:0];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

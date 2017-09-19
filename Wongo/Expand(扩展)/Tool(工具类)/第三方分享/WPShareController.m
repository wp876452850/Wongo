//
//  WPShareController.m
//  Wongo
//
//  Created by  WanGao on 2017/9/14.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPShareController.h"
#import <UShareUI/UShareUI.h>

@interface WPShareController ()
@property (nonatomic,strong)UIViewController * currentViewController;
@end
@implementation WPShareController
//分享app
+(void)shareAppWithCurrentViewController:(UIViewController *)currentViewController
{
    [self setPreDefinePlat];
    WPShareController * shareController = [[WPShareController alloc]init];
    shareController.currentViewController = currentViewController;
    [shareController showBottomNormalView];
    
    
}
//展示分享框
- (void)showBottomNormalView
{
    [UMSocialUIManager removeAllCustomPlatformWithoutFilted];
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_IconAndBGRadius;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {

    //在回调里面获得点击的
    if (platformType == UMSocialPlatformType_UserDefine_Begin+2) {
        NSLog(@"点击演示添加Icon后该做的操作");
        dispatch_async(dispatch_get_main_queue(), ^{
                
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加自定义icon"
                                                    message:@"具体操作方法请参考UShareUI内接口文档"
                                                    delegate:nil
                                                    cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                                    otherButtonTitles:nil];
                [alert show];
                
            });
        }
        else{
            [self shareWebPageToPlatformType:platformType];
        }
    }];

}
+(void)setPreDefinePlat{
    //设置用户自定义的平台
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_WechatTimeLine),
                                               @(UMSocialPlatformType_QQ),
                                               @(UMSocialPlatformType_Qzone),
                                               @(UMSocialPlatformType_Sina),
                                               ]];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"碗糕-让您的闲置帮您创造梦想" descr:@"碗糕app是一款以交换物品为基础，以小换大的交易方式，独特“众筹”模式为特色的应用软件" thumImage:[UIImage imageNamed:@"80"]];
    //设置网页地址
    shareObject.webpageUrl = @"https://itunes.apple.com/cn/app/%E7%A2%97%E7%B3%95-%E8%AE%A9%E4%BD%A0%E7%9A%84%E9%97%B2%E7%BD%AE%E5%B8%AE%E4%BD%A0%E5%88%9B%E9%80%A0%E6%A2%A6%E6%83%B3/id1237071053?mt=8";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self.currentViewController completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

@end

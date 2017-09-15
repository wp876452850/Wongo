//
//  WPShareController.m
//  Wongo
//
//  Created by  WanGao on 2017/9/14.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPShareController.h"
#import <UShareUI/UShareUI.h>

@implementation WPShareController

+(void)shareApp
{
    
}

+(void)setPreDefinePlat{
    //设置用户自定义的平台
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_WechatTimeLine),
                                               @(UMSocialPlatformType_WechatFavorite),
                                               @(UMSocialPlatformType_QQ),
                                               @(UMSocialPlatformType_Tim),
                                               @(UMSocialPlatformType_Qzone),
                                               @(UMSocialPlatformType_Sina),
                                               ]];
}

@end

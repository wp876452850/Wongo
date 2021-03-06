//
//  WongoParameterMacros.h
//  Wongo
//
//  Created by rexsu on 2017/3/22.
//  Copyright © 2017年 Winny. All rights reserved.
//

#ifndef WongoParameterMacros_h
#define WongoParameterMacros_h

#define WINDOW_BOUNDS [UIScreen mainScreen].bounds
#define WINDOW_WIDTH CGRectGetWidth(WINDOW_BOUNDS)
#define WINDOW_HEIGHT CGRectGetHeight(WINDOW_BOUNDS)
#define User_ID             @"user_id"
#define User_ID_ISChange    @"isChange"
#define User_Token          @"user_token"
#define User_Name           @"user_name"
#define User_Head           @"user_head"
#define ActivityKey         @"activity"
//首次开启应用
#define FirstTimeTosStart   @"firsttimetostart"


/**融云开发环境:0开发,1生产 */
#ifdef DEBUG
#define RCIMDEVTYPE @"1"
#else
#define RCIMDEVTYPE @"1"
#endif

#define RONGCLOUD_IM_APPKEY  ([RCIMDEVTYPE isEqualToString:@"1"] ? @"e5t4ouvpeiifa" : @"0vnjpoad0eewz") //appkey

#define Ali_App_Id          @"2016080200150163"
//支付宝支付通知标识名
#define AliPay_PaymentNotice  @"ALIPAY_DONE"

#define User_MobileVersion  [[[UIDevice currentDevice] systemVersion] floatValue]

//自定义色
#define RandomColor [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1]
#define ScreenThan 0.5
#define GRAY_COLOR [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1]
#define ColorWithRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
//自定义色
#define WongoGrayColor      ColorWithRGB(241, 240, 244)
#define WongoBlueColor      ColorWithRGB(27, 74, 108)
//活动页自定义色
#define WongoActivitGreenColor      ColorWithRGB(2, 188, 118)
#define WongoActivitYellowColor     ColorWithRGB(255, 188, 1)
#define WongoActivitBlueColor       ColorWithRGB(89, 203, 209)
//文字色
#define TitleBlackColor     ColorWithRGB(34, 34, 34)
#define TitleGrayColor      ColorWithRGB(128, 128, 128)
//主题色
#define SelfThemeColor      ColorWithRGB(72, 135, 190)
//线条颜色
#define AllBorderColor      ColorWithRGB(217, 217, 217)
//基础色
#define WhiteColor          ColorWithRGB(255,255,255)
#define BlackColor          ColorWithRGB(0,0,0)

//海报大小
#define RollPlayFrame       CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_WIDTH*0.6)
//交换主页海报图集
#define ExchangePosters     @[@"ExchangePosters3.jpg",@"ExchangePosters2.jpg"]
#define DreamingPosters     @[@"ExchangePosters4.jpg",@"ExchangePosters1.jpg"]

/**判断是否为我的二级界面,解决导航控制器问题*/
#define IsMySubViewController @"isYesOrNo"

#endif /* WongoParameterMacros_h */

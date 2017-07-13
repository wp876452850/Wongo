//
//  WPExchangeOrderDetailViewController.h
//  Wongo
//
//  Created by rexsu on 2017/4/19.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,WPOrderDetailType)
{
    OrderDetailGenerate    = 0,                    //生成订单样式
    OrderDetailSelect      = 1                     //查询订单样式
};

@interface WPExchangeOrderDetailViewController : UIViewController
-(instancetype)initWithOrderType:(WPOrderDetailType)orderType;
@end

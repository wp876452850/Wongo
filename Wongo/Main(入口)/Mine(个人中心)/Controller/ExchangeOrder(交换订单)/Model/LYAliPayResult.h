//
//  LYAliPayResult.h
//  Wongo
//
//  Created by  WanGao on 2017/6/5.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LYAliPayResult : NSObject
//memo = "\U7528\U6237\U4e2d\U9014\U53d6\U6d88";
//result = "";
//resultStatus = 6001;
@property (nonatomic, strong) NSString *memo;
@property (nonatomic, strong) NSString *result;
@property (nonatomic, assign) int resultStatus;

//返回码	含义
//9000	订单支付成功
//8000	正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
//4000	订单支付失败
//5000	重复请求
//6001	用户中途取消
//6002	网络连接出错
//6004	支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
//其它	其它支付错误
@end

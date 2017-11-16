//
//  WPPayDepositViewController.h
//  Wongo
//
//  Created by rexsu on 2017/4/19.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPExchangeOrderModel.h"

typedef void(^PayMoneyBlock)(NSInteger state);
@interface WPPayDepositViewController : UIViewController
//@property (nonatomic, strong) WPExchangeOrderModel *model;
-(instancetype)initWithParams:(NSDictionary *)params price:(CGFloat)price aliPayUrl:(NSString *)aliPayUrl;

//支付结果状态
-(void)getStateBlock:(PayMoneyBlock)block;

@end

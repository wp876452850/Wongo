//
//  WPPayDepositViewController.h
//  Wongo
//
//  Created by rexsu on 2017/4/19.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPExchangeOrderModel.h"

typedef void(^PayMoneyBlock)(NSString * state);
@interface WPPayDepositViewController : UIViewController
//@property (nonatomic, strong) WPExchangeOrderModel *model;
-(instancetype)initWithOrderNumber:(NSString *)orderNumber price:(CGFloat)price aliPayUrl:(NSString *)aliPayUrl;

-(void)getStateBlock:(PayMoneyBlock)block;

@end

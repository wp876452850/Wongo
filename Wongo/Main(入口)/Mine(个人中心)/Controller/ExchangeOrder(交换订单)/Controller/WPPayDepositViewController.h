//
//  WPPayDepositViewController.h
//  Wongo
//
//  Created by rexsu on 2017/4/19.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPExchangeOrderModel.h"

@interface WPPayDepositViewController : UIViewController
//@property (nonatomic, strong) WPExchangeOrderModel *model;
-(instancetype)initWithOrderNumber:(NSString *)orderNumber price:(CGFloat)price dream:(BOOL)isDream;

@end

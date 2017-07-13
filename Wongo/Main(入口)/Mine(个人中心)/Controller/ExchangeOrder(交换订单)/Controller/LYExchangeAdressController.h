//
//  LYExchangeAdressController.h
//  Wongo
//
//  Created by  WanGao on 2017/6/6.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "LYBaseController.h"
#import "WPExchangeOrderCell.h"
#import "LYExchangeOrderDetialModel.h"
@interface LYExchangeAdressController : LYBaseController
/**订单模型*/
@property (nonatomic, strong) WPExchangeOrderModel *model;

/**详情模型*/
@property (nonatomic, strong) LYExchangeOrderDetialModel *detailModel;
@end

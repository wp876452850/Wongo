//
//  WPExchangeOrderDetailModel.h
//  Wongo
//
//  Created by rexsu on 2017/4/24.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPAddressSelectModel.h"
#import "WPExchangeOrderGoodsModel.h"

@interface WPExchangeOrderDetailModel : NSObject

@property (nonatomic,strong)WPAddressSelectModel * addressModel;

@property (nonatomic,strong)WPExchangeOrderGoodsModel * myGoodsModel;

@property (nonatomic,strong)WPExchangeOrderGoodsModel * exchangeGoodsModel;

@end

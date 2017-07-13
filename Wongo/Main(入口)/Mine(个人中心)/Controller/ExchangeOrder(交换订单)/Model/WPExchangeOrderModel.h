//
//  WPExchangeOrderModel.h
//  Wongo
//
//  Created by rexsu on 2017/3/22.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPExchangeOrderGoodsModel.h"

@interface WPExchangeOrderModel : NSObject
/**订单号(订单号码)*/
@property (nonatomic,strong)NSString                    * ordernum;
/**订单编号*/
@property (nonatomic,strong)NSString                    * oid;
/**交易状态*/
@property (nonatomic,assign)int                    state;
/**我的商品信息*/
@property (nonatomic,strong)WPExchangeOrderGoodsModel   * myModel;
/**对方的商品信息*/
@property (nonatomic,strong)WPExchangeOrderGoodsModel   * partnerModel;

/**对方是否支付 0未支付 1支付 */
@property (nonatomic, assign) BOOL emp;

/**对方是否发货 1未 0发货*/
@property (nonatomic, assign) int sss;
@property (nonatomic, assign) BOOL hasSss;

/**0自己确认对方没有 1对方确认自己没有 (没有 suc = 1已退款 0退款失败)*/
@property (nonatomic, assign) int esc;
@property (nonatomic, assign) BOOL hasEsc;

@property (nonatomic, assign) int suc;
@property (nonatomic, assign) BOOL hasSuc;

/**1对方确认收货自己申请平台介入 2对方未确认收货自己申请平台介入 */
@property (nonatomic, assign) int ptjr;

@end

//
//  WPExchangeOrderGoodsModel.h
//  Wongo
//
//  Created by rexsu on 2017/3/30.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPExchangeOrderGoodsModel : NSObject
/**图片url*/
@property (nonatomic,strong)NSString * url;
/**商品名*/
@property (nonatomic,strong)NSString * gname;
/**价格*/
@property (nonatomic,strong)NSString * price;
/***/
@property (nonatomic,strong)NSString * number;
/**商品id*/
@property (nonatomic,strong)NSString * gid;
/**是否收藏*/
@property (nonatomic,strong)NSString * scflag;
@end

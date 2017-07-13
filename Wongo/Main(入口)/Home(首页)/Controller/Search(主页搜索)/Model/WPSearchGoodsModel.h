//
//  WPSearchGoodsModel.h
//  Wongo
//
//  Created by rexsu on 2017/2/20.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPSearchGoodsModel : NSObject
//商品图Url
@property (nonatomic,strong)NSString * url;
//商品名字
@property (nonatomic,strong)NSString * gname;
//商品id
@property (nonatomic,strong)NSString * gid;
//原价
@property (nonatomic,strong)NSString * originalPrice;
//现价
@property (nonatomic,strong)NSString * price;
//价格单位
@property (nonatomic,strong)NSString * priceUnit;
//关注数量
@property (nonatomic,strong)NSString * freight;
//是否关注
@property (nonatomic,strong)NSString * collect;

@end

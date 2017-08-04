//
//  WPExchangeDetailModel.h
//  Wongo
//
//  Created by rexsu on 2017/3/17.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPExchangeCommentsModel.h"
#import "WPUserIntroductionModel.h"

@interface WPExchangeDetailModel : NSObject
/**
 滚播图片数组
 */
@property (nonatomic,strong)NSMutableArray * rollPlayImages;
/**
 用户id
 */
@property (nonatomic,strong)NSString * uid;
/**
 商品id
 */
@property (nonatomic,strong)NSString * gid;
/**
 产品名
 */
@property (nonatomic,strong)NSString * gname;
/**
 货币单位
 */
@property (nonatomic,strong)NSString * unit;
/**
 产品价值
 */
@property (nonatomic,strong)NSString * price;
/**
 新旧程度
 */
@property (nonatomic,strong)NSString * neworold;
/**
 收藏状态
 */
@property (nonatomic,strong)NSString * freight;
/**
 评价model数组
 */
@property (nonatomic,strong)NSMutableArray * commentsModelArray;
/**
 用户信息model
 */
@property (nonatomic,strong)WPUserIntroductionModel * userIntroductionModel;
/**
 产品图片数组
 */
@property (nonatomic,strong)NSMutableArray * goodsImages;
/**
 产品参数
 */
@property (nonatomic,strong)NSMutableArray * parameters;
/**
 商品描述
 */
@property (nonatomic,strong)NSString * remark;
/**
 库存
 */
@property (nonatomic,strong)NSString * repertory;

@end

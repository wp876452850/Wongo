//
//  WPDreamingMainGoodsModel.h
//  Wongo
//
//  Created by rexsu on 2017/5/12.
//  Copyright © 2017年 Winny. All rights reserved.
//  精选-造梦计划商品数据

#import <Foundation/Foundation.h>

@interface WPDreamingMainGoodsModel : NSObject

@property (nonatomic,strong)NSString * url;

@property (nonatomic,strong)NSString * subname;

@property (nonatomic,strong)NSString * contents;

@property (nonatomic,strong)NSString * subid;
/**浏览数*/
@property (nonatomic,strong)NSString * readview;
/**参与数*/
@property (nonatomic,strong)NSString * count;

@property (nonatomic,strong)NSArray  * listplan;

@end

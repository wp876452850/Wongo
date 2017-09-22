//
//  WPNewExchangeModel.h
//  Wongo
//
//  Created by  WanGao on 2017/8/8.
//  Copyright © 2017年 Winny. All rights reserved.
//  新版交换商品展示单元格model

#import <Foundation/Foundation.h>

@interface WPNewExchangeModel : NSObject

@property (nonatomic,strong)NSString * url;

@property (nonatomic,strong)NSString * price;

@property (nonatomic,strong)NSString * gcid;

@property (nonatomic,strong)NSString * gid;

@property (nonatomic,strong)NSString * gname;

@property (nonatomic,strong)NSString * uid;
//点赞数
@property (nonatomic,strong)NSString * praise;

@property (nonatomic,strong)NSString * repertory;


@end

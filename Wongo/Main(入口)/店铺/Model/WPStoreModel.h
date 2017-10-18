//
//  WPStoreModel.h
//  Wongo
//
//  Created by  WanGao on 2017/10/17.
//  Copyright © 2017年 Winny. All rights reserved.
//  店铺页数据模型

#import <Foundation/Foundation.h>

@interface WPStoreModel : NSObject

@property (nonatomic,strong)NSArray * listg;
@property (nonatomic,strong)NSArray * listm;


@property (nonatomic,strong)NSString * fansnum;
@property (nonatomic,strong)NSString * attentionnum;
@property (nonatomic,strong)NSString * state;
@property (nonatomic,strong)NSString * grade;
@property (nonatomic,strong)NSString * lovenum;
@property (nonatomic,strong)NSString * signature;
@property (nonatomic,strong)NSString * url;
@property (nonatomic,strong)NSString * uname;

@end

//
//  WPExchangeModel.h
//  Wongo
//
//  Created by rexsu on 2017/2/8.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPExchangeModel : NSObject
@property (nonatomic,assign)BOOL collection;
@property (nonatomic,strong)NSString * url;
@property (nonatomic,strong)NSString * collectNumber;

@property (nonatomic,strong)NSString * price;

@property (nonatomic,strong)NSString * gcid;
@property (nonatomic,strong)NSString * gid;
@property (nonatomic,strong)NSString * gname;
@property (nonatomic,strong)NSArray  * listimg;
//点赞数
@property (nonatomic,strong)NSString * praise;

@end

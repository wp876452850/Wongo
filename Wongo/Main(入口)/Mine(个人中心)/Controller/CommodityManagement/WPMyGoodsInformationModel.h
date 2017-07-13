//
//  WPMyGoodsInformationModel.h
//  Wongo
//
//  Created by rexsu on 2017/4/21.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPMyGoodsInformationModel : NSObject
@property (nonatomic,strong)NSString * url;
/**商品类型*/
@property (nonatomic,strong)NSString * gcid;
/**商品id*/
@property (nonatomic,strong)NSString * gid;
/**商品名*/
@property (nonatomic,strong)NSString * gname;
/**商品新旧程度*/
@property (nonatomic,strong)NSString * neworold;
/**商品价格*/
@property (nonatomic,strong)NSString * price;
/**商品介绍*/
@property (nonatomic,strong)NSString * remark;
/**商品归属用户id*/
@property (nonatomic,strong)NSString * uid;
/**发布时间*/
@property (nonatomic,strong)NSString * pubtime;

@end

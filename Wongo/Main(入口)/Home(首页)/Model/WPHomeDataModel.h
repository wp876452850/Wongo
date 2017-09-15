//
//  WPHomeDataModel.h
//  Wongo
//
//  Created by rexsu on 2017/2/6.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPHomeDataModel : NSObject
/**是否收藏*/
@property (nonatomic,assign)BOOL collection;
/**图片URL*/
@property (nonatomic,strong)NSString * url;
/**标题*/
@property (nonatomic,strong)NSString * gname;
/**收藏人数*/
@property (nonatomic,strong)NSString * collectNumber;
/**价格*/
@property (nonatomic,strong)NSString * price;
/**商品id*/
@property (nonatomic,strong)NSString * gid;
/**用户id*/
@property (nonatomic,strong)NSString * uid;

/***************************造梦计划***********************************/

/***/
@property (nonatomic,strong)NSString * subid;
/***/
@property (nonatomic,strong)NSString * proid;
/***/
@property (nonatomic,strong)NSString * proname;
/***/
@property (nonatomic,strong)NSString * contents;
/***/
@property (nonatomic,strong)NSString * plid;



@end

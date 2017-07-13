//
//  WPShoppingCarModel.h
//  Wongo
//
//  Created by rexsu on 2017/2/2.
//  Copyright © 2017年 Wongo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPShoppingCarModel : NSObject
/**是否被勾选*/
@property (nonatomic,assign)BOOL select;
/**商品图片*/
@property (nonatomic,strong)NSString * goodsImage_url;
/**商品名*/
@property (nonatomic,strong)NSString * goodsName;
/**价格*/
@property (nonatomic,strong)NSString * price;
/**商品数量*/
@property (nonatomic,strong)NSString * goodsNumber;
/**价格货币单位*/
@property (nonatomic,strong)NSString * price_unit;
@end

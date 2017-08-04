//
//  WPProductDetailUserStoreModel.h
//  Wongo
//
//  Created by  WanGao on 2017/8/2.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPProductDetailUserStoreModel : NSObject
/**用户名*/
@property (nonatomic,strong)NSString * uname;
/**头像url*/
@property (nonatomic,strong)NSString * headPortraitUrl;
/**其它*/
@property (nonatomic,strong)NSString * other;
/**uid*/
@property (nonatomic,strong)NSString * uid;
/**热拍商品*/
@property (nonatomic,strong)NSMutableArray * hotGoods;
@end

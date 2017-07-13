//
//  WPSelectExchangeGoodsViewController.h
//  Wongo
//
//  Created by rexsu on 2017/3/28.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPSelectExchangeGoodsViewController : UIViewController
/**我的gid*/
@property (nonatomic,strong)NSString * gid1;
/**对方的gid*/
@property (nonatomic,strong)NSString * gid2;
/**对方商品价格*/
@property (nonatomic,strong)NSString * price1;
/**我的商品价格*/
@property (nonatomic,strong)NSString * price2;
/**初始化传对方gcid*/
-(instancetype)initWithGid:(NSString *)gcid price:(NSString *)price;
@end

//
//  WPMyShopUserInformationModel.h
//  Wongo
//
//  Created by rexsu on 2017/3/30.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPMyShopUserInformationModel : NSObject
/**背景图片*/
@property (nonatomic,strong)NSString * bgImageUrl;
/**头像*/
@property (nonatomic,strong)NSString * userHanderViewUrl;
/**用户名*/
@property (nonatomic,strong)NSString * userName;
/**商品数量*/
@property (nonatomic,strong)NSString * goodsNumber;


@end

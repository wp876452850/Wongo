//
//  WPMyShopUserInformationView.h
//  Wongo
//
//  Created by rexsu on 2017/3/30.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPMyShopUserInformationModel.h"

@interface WPMyShopUserInformationView : UIView
@property (nonatomic,strong)WPMyShopUserInformationModel * model;

/**头像*/
@property (nonatomic,strong)UIImageView * headerView;
/**签名*/
@property (nonatomic,strong)UILabel * signature;
/**商品数量*/
@property (nonatomic,strong)UILabel * goodsNumber;

@end

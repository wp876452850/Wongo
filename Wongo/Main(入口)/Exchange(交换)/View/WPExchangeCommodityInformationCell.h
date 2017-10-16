//
//  WPExchangeCommodityInformationCell.h
//  Wongo
//
//  Created by rexsu on 2017/3/20.
//  Copyright © 2017年 Winny. All rights reserved.
//  商品信息

#import <UIKit/UIKit.h>
#import "WPExchangeDetailModel.h"
#import "LYHomeCategory.h"

@interface WPExchangeCommodityInformationCell : UITableViewCell

@property (nonatomic,strong)WPExchangeDetailModel * model;

@property (nonatomic,assign)NSInteger activityState;
/**活动数组*/
@property (nonatomic, strong) NSArray<LYHomeCategory *> *listhk;
@end

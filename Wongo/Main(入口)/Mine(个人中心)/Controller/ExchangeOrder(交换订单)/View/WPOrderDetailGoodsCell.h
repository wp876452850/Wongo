//
//  WPOrderDetailGoodsCell.h
//  Wongo
//
//  Created by rexsu on 2017/4/24.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPExchangeOrderGoodsModel.h"
@interface WPOrderDetailGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *whoGoods;
@property (nonatomic,strong)WPExchangeOrderGoodsModel * model;
@end

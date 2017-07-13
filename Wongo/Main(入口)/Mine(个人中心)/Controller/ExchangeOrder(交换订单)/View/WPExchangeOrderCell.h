//
//  WPExchangeOrderCell.h
//  Wongo
//
//  Created by rexsu on 2017/3/22.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPExchangeOrderModel.h"

@interface WPExchangeOrderCell : UITableViewCell
@property (nonatomic,strong)WPExchangeOrderModel * model;
@property (nonatomic, assign) BOOL hideSomeInDetail;
@end

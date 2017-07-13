//
//  WPSelectExchangeGoodsCell.h
//  Wongo
//
//  Created by rexsu on 2017/3/29.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPSelectExchangeGoodsModel.h"
@interface WPSelectExchangeGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (nonatomic,strong)WPSelectExchangeGoodsModel * model;
@end

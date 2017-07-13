//
//  WPAddressSelectTableViewCell.h
//  Wongo
//
//  Created by rexsu on 2017/3/23.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPAddressModel.h"

@interface WPAddressSelectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *select;

@property (nonatomic,strong)WPAddressModel * model;
@end

//
//  WPCommodityManagementTableViewCell.h
//  Wongo
//
//  Created by rexsu on 2016/12/20.
//  Copyright © 2016年 Wongo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPMyGoodsInformationModel.h"

typedef void(^DeleteBlock)(void);

@interface WPCommodityManagementTableViewCell : UITableViewCell

@property (nonatomic,strong)WPMyGoodsInformationModel * model;


-(void)deleteWithBlock:(DeleteBlock)block;
@end

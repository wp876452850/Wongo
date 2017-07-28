//
//  WPTableBaseViewController.h
//  Wongo
//
//  Created by  WanGao on 2017/7/27.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "LYBaseController.h"

@interface WPTableBaseViewController : LYBaseController

/**数据table*/
@property (nonatomic,strong)UITableView * tableView;
/**数据数组*/
@property (nonatomic,strong)NSMutableArray * dataSource;
/**缓存cell高度数组*/
@property (nonatomic,strong)NSMutableArray * cellsHeight;

@end

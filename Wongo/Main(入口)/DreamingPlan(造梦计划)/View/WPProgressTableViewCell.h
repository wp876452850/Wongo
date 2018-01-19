//
//  WPProgressTableViewCell.h
//  Wongo
//
//  Created by rexsu on 2017/3/13.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPDreamingModel.h"

@interface WPProgressTableViewCell : UITableViewCell
{
    ProgressView * priceProgress;
    ProgressView * progressProgress;
    
}
@property (nonatomic,strong)ProgressView * dateProgress;

@property (nonatomic,strong)WPDreamingModel * model;

@property (nonatomic,strong)UITableView * tableView;

@end

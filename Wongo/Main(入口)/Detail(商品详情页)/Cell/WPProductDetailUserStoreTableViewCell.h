//
//  WPProductDetailUserStoreTableViewCell.h
//  Wongo
//
//  Created by  WanGao on 2017/8/2.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPUserIntroductionModel.h"

typedef void(^RowHeightBlock)(CGFloat rowheight);
@interface WPProductDetailUserStoreTableViewCell : UITableViewCell

@property (nonatomic,strong)WPUserIntroductionModel * model;

-(void)getRowHeightWithBlock:(RowHeightBlock)block;

@end

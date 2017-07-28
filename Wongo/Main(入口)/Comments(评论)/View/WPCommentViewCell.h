//
//  WPCommentViewCell.h
//  Wongo
//
//  Created by  WanGao on 2017/7/25.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPCommentModel.h"

@class WPCommentViewCell;
@protocol WPCommentViewCellDelegate <NSObject>

- (void)reloadCellHeightForModel:(WPCommentModel *)model atIndexPath:(NSIndexPath *)indexPath;


@end

@interface WPCommentViewCell : UITableViewCell

@property (nonatomic,assign)id<WPCommentViewCellDelegate> delegate;

@property (nonatomic,strong)WPCommentModel * model;

@end

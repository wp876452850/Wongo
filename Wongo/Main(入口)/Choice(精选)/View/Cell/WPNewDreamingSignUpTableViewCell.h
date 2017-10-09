//
//  WPNewDreamingSignUpTableViewCell.h
//  Wongo
//
//  Created by  WanGao on 2017/8/10.
//  Copyright © 2017年 Winny. All rights reserved.
//  新版造梦已报名展开单元格

#import <UIKit/UIKit.h>
#import "WPDreamingMainGoodsModel.h"


typedef void(^WPNewDreamingSignUpTableViewCellClose)(void);
@interface WPNewDreamingSignUpTableViewCell : UITableViewCell

@property (nonatomic,strong)NSMutableArray * dataSource;

@property (nonatomic,assign)BOOL isongoing;
-(void)closeWithBlock:(WPNewDreamingSignUpTableViewCellClose)block;


@end

//
//  WPNewDreamingNotSignUpTableViewCell.h
//  Wongo
//
//  Created by  WanGao on 2017/8/18.
//  Copyright © 2017年 Winny. All rights reserved.
//  新版造梦未报名展开单元格

#import <UIKit/UIKit.h>
#import "WPDreamingMainGoodsModel.h"

@interface WPNewDreamingNotSignUpTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextView *instructions;
@property (nonatomic,strong)WPDreamingMainGoodsModel * model;
@end

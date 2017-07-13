//
//  WPHotCell.h
//  Wongo
//
//  Created by Winny on 2016/12/9.
//  Copyright © 2016年 Wongo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPHomeDataModel.h"

@interface WPHotCell : UICollectionViewCell

@property (nonatomic,strong)WPHomeDataModel * model;

@property (nonatomic,assign)BOOL isDreamingGoods;

@end

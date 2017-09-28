//
//  WPActivityGoodsCollectionViewCell.h
//  Wongo
//
//  Created by  WanGao on 2017/9/26.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPExchangeModel.h"


@interface WPActivityGoodsCollectionViewCell : UICollectionViewCell

@property (nonatomic,assign)NSInteger activityState;

@property (nonatomic,strong)WPExchangeModel * model;



@end

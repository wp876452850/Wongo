//
//  WPConsignmentClassGoodsViewController.h
//  Wongo
//
//  Created by  WanGao on 2017/12/21.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "LYBaseController.h"

@interface WPConsignmentClassGoodsViewController : LYBaseController

-(instancetype)initWithGcid:(NSString *)gcid;

@property (nonatomic,strong)UICollectionView * collectionView;

@property (nonatomic,strong)NSArray * dataSource;

@end

//
//  WPCollectionBaseViewController.h
//  Wongo
//
//  Created by  WanGao on 2017/9/25.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "LYBaseController.h"

@interface WPCollectionBaseViewController : LYBaseController

-(instancetype)initWithGcid:(NSString *)gcid;

-(instancetype)initWithWithTpid:(NSString *)tpid imageUrl:(NSString *)imageUrl;

@property (nonatomic,strong)UICollectionView * collectionView;

@property (nonatomic,strong)NSArray * dataSource;

@property (nonatomic,strong)NSString * url;

@end

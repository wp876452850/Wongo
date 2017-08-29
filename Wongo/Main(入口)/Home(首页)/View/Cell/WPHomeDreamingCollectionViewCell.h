//
//  WPHomeDreamingCollectionViewCell.h
//  Wongo
//
//  Created by  WanGao on 2017/8/14.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPDreamingDirectoryModel.h"

@interface WPHomeDreamingCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)WPDreamingDirectoryModel * model;

@property (nonatomic,strong)NSString * proid;

@property (nonatomic,strong)NSString * url;
@end

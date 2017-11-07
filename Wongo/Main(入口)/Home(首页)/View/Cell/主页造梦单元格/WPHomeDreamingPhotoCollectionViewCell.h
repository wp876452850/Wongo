//
//  WPHomeDreamingPhotoCollectionViewCell.h
//  Wongo
//
//  Created by  WanGao on 2017/11/4.
//  Copyright © 2017年 Winny. All rights reserved.
//  下面参与商品的 cell

#import <UIKit/UIKit.h>
#import "WPNewHomeDreamingPhotoModel.h"

@interface WPHomeDreamingPhotoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shadow;

@property (nonatomic,strong)WPNewHomeDreamingPhotoModel * model;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UILabel *lunci;
@end

//
//  ZYPhotoCollectionViewCell.h
//  jinxin
//
//  Created by ZhiYong_Huang on 16/4/10.
//  Copyright © 2016年 ZhiYong_Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZYPhotoModel;

@interface ZYPhotoCollectionViewCell : UICollectionViewCell
@property(nonatomic,assign) NSUInteger index;
@property(nonatomic,strong) ZYPhotoModel *photoModel;

@end

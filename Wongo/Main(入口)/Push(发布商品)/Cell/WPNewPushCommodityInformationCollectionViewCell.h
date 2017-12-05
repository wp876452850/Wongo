//
//  WPNewPushCommodityInformationCollectionViewCell.h
//  Wongo
//
//  Created by  WanGao on 2017/11/16.
//  Copyright © 2017年 Winny. All rights reserved.
//  商品基本信息

#import <UIKit/UIKit.h>
#import "WPCostomTextField.h"
typedef void(^WPNewPushGoodsNameBlock)(NSString * str);
typedef void(^WPNewPushDescribeEdtingBlock)(NSString * str ,CGFloat height);


@interface WPNewPushCommodityInformationCollectionViewCell : UICollectionViewCell
/**输入框限制字数 默认50*/
@property (nonatomic,assign)NSInteger wordsNumber;

@property (nonatomic,strong)UICollectionView * superView;

@property (nonatomic,strong)NSIndexPath * indexPath;

-(void)getGoodsNameBlockWithBlock:(WPNewPushGoodsNameBlock)block;

-(void)getDescribeEdtingBlockWithBlock:(WPNewPushDescribeEdtingBlock)block;
@end

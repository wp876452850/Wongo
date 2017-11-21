//
//  WPNewPushStoreCollectionViewCell.h
//  Wongo
//
//  Created by  WanGao on 2017/11/20.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^WPNewPushStoreBlock)(NSString * str,CGFloat height);
@interface WPNewPushStoreCollectionViewCell : UICollectionViewCell
@property (nonatomic,assign)NSInteger wordsNumber;

@property (nonatomic,strong)UICollectionView * superView;

@property (nonatomic,strong)NSIndexPath * indexPath;

-(void)getStoreBlockWithBlock:(WPNewPushStoreBlock)block;

@end

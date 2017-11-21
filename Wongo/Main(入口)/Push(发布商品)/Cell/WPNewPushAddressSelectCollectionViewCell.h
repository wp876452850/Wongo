//
//  WPNewPushAddressSelectCollectionViewCell.h
//  Wongo
//
//  Created by  WanGao on 2017/11/17.
//  Copyright © 2017年 Winny. All rights reserved.
//  地址选择器

#import <UIKit/UIKit.h>


typedef void(^WPNewPushAddressBlock)(NSInteger adid);
@interface WPNewPushAddressSelectCollectionViewCell : UICollectionViewCell

-(void)getAddressWithBlock:(WPNewPushAddressBlock)block;

@end

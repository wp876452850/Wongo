//
//  WPNewPushUserInformationCollectionViewCell.h
//  Wongo
//
//  Created by  WanGao on 2017/11/17.
//  Copyright © 2017年 Winny. All rights reserved.
//  用户信息

#import <UIKit/UIKit.h>
#import "WPCostomTextField.h"
typedef void(^WPNewPushNameBlock)(NSString * str);
typedef void(^WPNewPushPhoneBlock)(NSString * str);
@interface WPNewPushUserInformationCollectionViewCell : UICollectionViewCell

-(void)getNameBlockWithBlock:(WPNewPushNameBlock)block;
-(void)getPhoneBlockWithBlock:(WPNewPushPhoneBlock)block;

@end

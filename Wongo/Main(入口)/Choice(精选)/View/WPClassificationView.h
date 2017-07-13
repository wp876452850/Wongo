//
//  WPClassificationView.h
//  Wongo
//
//  Created by rexsu on 2017/5/18.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClassificationSelectBlock)(NSString * classification);
typedef void(^AddViewForExchangeSubCollectionView)(UIView * view);
@interface WPClassificationView : UIView

-(void)classificationSelectWithBlock:(ClassificationSelectBlock)block;
-(void)classificationAddForExchangeSubCollectionViewWithBlock:(AddViewForExchangeSubCollectionView)block;
@end

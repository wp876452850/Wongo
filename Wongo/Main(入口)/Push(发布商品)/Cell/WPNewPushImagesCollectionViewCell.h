//
//  WPNewPushImagesCollectionViewCell.h
//  Wongo
//
//  Created by  WanGao on 2017/11/17.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WPNewPushImageBlock)(NSMutableArray * images,NSInteger heightRow);
@interface WPNewPushImagesCollectionViewCell : UICollectionViewCell
@property (nonatomic,assign)CGFloat rowHeight;
@property (nonatomic,strong)NSMutableArray * images;

-(void)getRowDataWithBlock:(WPNewPushImageBlock)block;

@end

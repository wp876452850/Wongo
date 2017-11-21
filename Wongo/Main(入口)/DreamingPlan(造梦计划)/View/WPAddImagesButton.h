//
//  WPAddImagesButton.h
//  Wongo
//
//  Created by rexsu on 2017/3/7.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BackImageBlock)(NSArray * images);


@interface WPAddImagesButton : UIButton
@property (nonatomic,assign)NSInteger maxImages;
-(void)getSelectPhotoWithBlock:(BackImageBlock)block;

@end

//
//  WPAddImagesButton.h
//  Wongo
//
//  Created by rexsu on 2017/3/7.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BackImageBlock)(UIImage * image);


@interface WPAddImagesButton : UIButton

-(void)getSelectPhotoWithBlock:(BackImageBlock)block;

@end

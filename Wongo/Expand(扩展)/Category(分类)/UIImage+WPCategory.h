//
//  UIImage+WPCategory.h
//  Wongo
//
//  Created by Winny on 2016/12/8.
//  Copyright © 2016年 Wongo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WPCategory)
/**
 图像裁剪,用作头像icon白边圆框
 */
+ (UIImage *)iconWithClipImage:(UIImage *)image;

@end

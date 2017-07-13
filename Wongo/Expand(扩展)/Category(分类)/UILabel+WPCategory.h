//
//  UILabel+WPCategory.h
//  Wongo
//
//  Created by rexsu on 2017/3/2.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (WPCategory)
/**根据问题自适应高度*/
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font;
/**根据问题自适应宽度*/
+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;

-(void)firstLineOfTheIndentationWithText:(NSString *)text;

@end

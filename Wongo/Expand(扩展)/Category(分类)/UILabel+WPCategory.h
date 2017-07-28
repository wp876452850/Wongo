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
- (void)alignTop;
- (void)alignBottom;

/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

@end

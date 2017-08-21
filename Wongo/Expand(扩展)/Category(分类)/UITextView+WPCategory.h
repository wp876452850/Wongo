//
//  UITextView+WPCategory.h
//  Wongo
//
//  Created by rexsu on 2017/3/24.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (WPCategory)
/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UITextView *)textView WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UITextView *)textView WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UITextView *)textView withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

/**
 *  改变行间距并设置字体大小
 */
+ (void)changeLineSpaceForLabel:(UITextView *)textView WithSpace:(float)space foneSize:(CGFloat)foneSize;

@property (nonatomic,strong) NSString *placeholder;//占位符
@property (copy, nonatomic) NSNumber *limitLength;//限制字数

@end

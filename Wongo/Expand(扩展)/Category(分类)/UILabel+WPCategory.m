//
//  UILabel+WPCategory.m
//  Wongo
//
//  Created by rexsu on 2017/3/2.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "UILabel+WPCategory.h"

@implementation UILabel (WPCategory)
-(void)firstLineOfTheIndentationWithText:(NSString *)text{

}

/**根据问题自适应高度*/
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}
/**根据问题自适应宽度*/
+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}
@end

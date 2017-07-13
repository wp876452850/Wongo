//
//  NSString+AutoSize.h
//  Wongo
//
//  Created by Winny on 2016/12/8.
//  Copyright © 2016年 Wongo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (AutoSize)

/**
 传入String得到Size

 @param font 字体大小
 @param maxSize 最大宽高
 @return 控件大小(Label)
 */
-(CGSize)getSizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
@end

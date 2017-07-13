//
//  NSString+AutoSize.m
//  Wongo
//
//  Created by Winny on 2016/12/8.
//  Copyright © 2016年 Wongo. All rights reserved.
//

#import "NSString+AutoSize.h"



@implementation NSString (AutoSize)
-(CGSize)getSizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize{
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}
@end

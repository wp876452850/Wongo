//
//  UITextView+WPCategory.h
//  Wongo
//
//  Created by rexsu on 2017/3/24.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (WPCategory)
@property (nonatomic,strong) NSString *placeholder;//占位符
@property (copy, nonatomic) NSNumber *limitLength;//限制字数

@end

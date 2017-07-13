//
//  UINavigationController+WPCategory.h
//  Wongo
//
//  Created by rexsu on 2016/12/15.
//  Copyright © 2016年 Wongo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (WPCategory)
//push并且隐藏标签条
- (void)pushViewControllerAndHideBottomBar:(UIViewController *)viewController animated:(BOOL)animated;

- (void)popViewControllerWithAnimation:(BOOL)animation;

@end

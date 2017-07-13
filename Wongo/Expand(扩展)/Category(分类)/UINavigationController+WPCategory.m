//
//  UINavigationController+WPCategory.m
//  Wongo
//
//  Created by rexsu on 2016/12/15.
//  Copyright © 2016年 Wongo. All rights reserved.
//

#import "UINavigationController+WPCategory.h"

@implementation UINavigationController (WPCategory)

- (void)pushViewControllerAndHideBottomBar:(UIViewController *)viewController animated:(BOOL)animated{
    viewController.hidesBottomBarWhenPushed = YES;
    [self pushViewController:viewController animated:animated];
}

- (void)popViewControllerWithAnimation:(BOOL)animation
{
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:IsMySubViewController];
    [self popViewControllerAnimated:YES];
}

@end

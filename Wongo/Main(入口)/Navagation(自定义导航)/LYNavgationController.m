//
//  LYNavgationController.m
//  WanGao
//
//  Created by  WanGao on 2017/5/27.
//  Copyright © 2017年  WanGao. All rights reserved.
//

#import "LYNavgationController.h"
#import "LYBaseController.h"

@interface LYNavgationController ()<UIGestureRecognizerDelegate>

@end

@implementation LYNavgationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置手势的代理
    self.interactivePopGestureRecognizer.delegate = self;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (self.childViewControllers.count > 1) {
        return YES;
    }else {
        return NO;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        if ([viewController isKindOfClass:[LYBaseController class]]) {
            LYBaseController *bavc = (LYBaseController *)viewController;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
            [button sizeToFit];
            
            [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
            // 设置导航栏返回按钮
            bavc.myNavItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        }
    }
    [super pushViewController:viewController animated:animated];
}
- (void)back{
    [self popViewControllerAnimated:YES];
}


@end

//
//  LYBaseController.m
//  WanGao
//
//  Created by  WanGao on 2017/5/27.
//  Copyright © 2017年  WanGao. All rights reserved.
//

#import "LYBaseController.h"

@interface LYBaseController ()

@end

@implementation LYBaseController

-(UINavigationBar *)myNavBar{
    if (!_myNavBar) {
        _myNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 64)];
        _myNavBar.barTintColor = ColorWithRGB(33, 34, 35);
        
        //设置文字颜色的属性
        NSMutableDictionary *attr = [NSMutableDictionary dictionary];
        attr[NSForegroundColorAttributeName] = [UIColor whiteColor];
        _myNavBar.titleTextAttributes = attr;
        _myNavBar.translucent = NO;
    }
    return _myNavBar;
}

- (UINavigationItem *)myNavItem{
    if (!_myNavItem) {
        _myNavItem = [[UINavigationItem alloc] init];
    }
    return _myNavItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self.view addSubview:self.myNavBar];
    self.myNavBar.items = @[self.myNavItem];
    self.view.backgroundColor = [UIColor whiteColor];
}

@end

//
//  LYBaseController.h
//  WanGao
//
//  Created by  WanGao on 2017/5/27.
//  Copyright © 2017年  WanGao. All rights reserved.
//基类控制器，继承此类的控制器会有一个自定义导航栏

#import <UIKit/UIKit.h>

@interface LYBaseController : UIViewController

@property (strong, nonatomic) UINavigationBar *myNavBar;

@property (strong, nonatomic) UINavigationItem *myNavItem;

@property (nonatomic,strong) UIView * selfNavBar;

@property (nonatomic,assign) BOOL isPresen;

@end

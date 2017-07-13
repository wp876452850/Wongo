//
//  WPTabBarController.h
//  Wogou
//
//  Created by rexsu on 2016/11/29.
//  Copyright © 2016年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPTabBarController : UITabBarController
//外部调用隐藏标签条
@property (nonatomic,assign)BOOL tabbarHiddenWhenPushed;

+ (instancetype)sharedTabbarController;
- (void)btnClick:(UIButton*)btn;
- (void)changeRedDot;
@end

//
//  WPNavigationBarView.h
//  Wongo
//
//  Created by rexsu on 2016/12/13.
//  Copyright © 2016年 Wongo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,NavigationBarStyle)
{
    NavigationBarChoiceStyle    = 0,                    //精选界面样式
    NavigationBarHomeStyle      = 1                     //主页样式
};


@interface WPNavigationBarView : UIView
/**左侧按钮*/
@property (nonatomic,strong)UIButton * leftItemButton;
/**右侧按钮*/
@property (nonatomic,strong)UIButton * rightItemButton;

-(instancetype)initWithStyle:(NavigationBarStyle)style;

@end

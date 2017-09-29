//
//  UIViewController+WPCategory.h
//  Wongo
//
//  Created by rexsu on 2016/12/15.
//  Copyright © 2016年 Wongo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WPAlertBlock)(void);
@interface UIViewController (WPCategory)
- (void)w_popViewController;
- (void)w_dismissViewControllerAnimated;
- (void)w_backGroudColor:(UIColor *)color;
- (void)w_changeBtnSelect:(UIButton *)sender;


/**
 创建提示框,并有多个回调

 @param alertTitle 标题
 @param message 内容
 @param preferredStyle 风格
 @param actions alertActiona数组
 */
-(void)showAlertWithAlertTitle:(NSString *)alertTitle message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle actions:(NSArray *)actions;
/**创建并展示提示框*/
- (void)showAlertWithAlertTitle:(NSString *)alertTitle message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle actionTitles:(NSArray *)actionTitles;
/**创建并展示提示框,并且有回调*/
- (void)showAlertWithAlertTitle:(NSString *)alertTitle message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle actionTitles:(NSArray *)actionTitles block:(WPAlertBlock)block;
/**创建并展示功能未开发提示框*/
- (void)showAlertNotOpenedWithBlock:(WPAlertBlock)block;

- (void)navigationLeftPop;

@end

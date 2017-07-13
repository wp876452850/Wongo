//
//  WPCostomTextField.h
//  视图随键盘上升
//
//  Created by rexsu on 2017/3/21.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPCostomTextField : UITextField
/**是否开启自动上升视图(点击输入框视图随键盘上升)*/
@property (nonatomic,assign)BOOL openRisingView;

@property (nonatomic,strong)UIView * superView;

@property (nonatomic,assign)BOOL superViewIsTableViewCell ;
/**
 创建类方法

 @param frame 输入框坐标
 @param openRisingView 是否需要点击输入框时父试图上升
 @param superView 父试图
 */
+(instancetype)createCostomTextFieldWithFrame:(CGRect)frame openRisingView:(BOOL)openRisingView superView:(UIView *)superView;

@end

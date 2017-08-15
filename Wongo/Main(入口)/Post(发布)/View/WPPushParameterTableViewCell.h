//
//  WPPushParameterTableViewCell.h
//  Wongo
//
//  Created by  WanGao on 2017/8/14.
//  Copyright © 2017年 Winny. All rights reserved.
//  发布参数

#import <UIKit/UIKit.h>

typedef void(^WPPushParameterBlock)(NSString * parameter);
typedef void(^WPPushParameterNameBlock)(NSString * parameterName);
@interface WPPushParameterTableViewCell : UITableViewCell

-(void)getPushParameterWithBlock:(WPPushParameterBlock)pushParameterBlock;
-(void)getPushParameterNameWithBlock:(WPPushParameterNameBlock)pushParameterNameBlock;

@end

//
//  WPBezierPath.h
//  Wongo
//
//  Created by  WanGao on 2017/7/12.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WPBezierPath : NSObject
/**画直线*/
+(CAShapeLayer *)drowLineWithMoveToPoint:(CGPoint)toPoint moveForPoint:(CGPoint)forPoints;
/**画直线自定义颜色*/
+(CAShapeLayer *)drowLineWithMoveToPoint:(CGPoint)toPoint moveForPoint:(CGPoint)forPoints lineColor:(UIColor *)color;
/**画表单元格分割线*/
+(CAShapeLayer *)cellBottomDrowLineWithTableViewCell:(UITableViewCell *)cell;
/**画集成视图单元格分割线*/
+(CAShapeLayer *)cellBottomDrowLineWithCollectionCell:(UICollectionViewCell *)cell;
/**画view四周的线框*/
+(void)beazierPathDrowAllRoundLineWithView:(UIView *)view lineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth;

@end

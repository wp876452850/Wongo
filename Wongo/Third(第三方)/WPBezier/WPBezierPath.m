//
//  WPBezierPath.m
//  Wongo
//
//  Created by  WanGao on 2017/7/12.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPBezierPath.h"

@implementation WPBezierPath

+(CAShapeLayer *)drowLineWithMoveToPoint:(CGPoint)toPoint moveForPoint:(CGPoint)forPoints{
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:toPoint];
    [path addLineToPoint:forPoints];
    
    CAShapeLayer * layer    = [CAShapeLayer layer];
    layer.path              = path.CGPath;
    layer.borderWidth       = 1.0f;
    layer.strokeColor       = WongoGrayColor.CGColor;
    
    return layer;
}
+(CAShapeLayer *)drowLineWithMoveToPoint:(CGPoint)toPoint moveForPoint:(CGPoint)forPoints lineColor:(UIColor *)color{
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:toPoint];
    [path addLineToPoint:forPoints];
    
    CAShapeLayer * layer    = [CAShapeLayer layer];
    layer.path              = path.CGPath;
    layer.borderWidth       = 1.0f;
    layer.strokeColor       = color.CGColor;
    
    return layer;
}
+(CAShapeLayer *)cellBottomDrowLineWithTableViewCell:(UITableViewCell *)cell{
    return [WPBezierPath drowLineWithMoveToPoint:CGPointMake(0, cell.height) moveForPoint:CGPointMake(WINDOW_WIDTH, cell.height)];
}
+(CAShapeLayer *)cellBottomDrowLineWithCollectionCell:(UICollectionViewCell *)cell{
    return [WPBezierPath drowLineWithMoveToPoint:CGPointMake(0, cell.height) moveForPoint:CGPointMake(WINDOW_WIDTH, cell.height)];
}
+(void)beazierPathDrowAllRoundLineWithView:(UIView *)view lineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth{
    view.layer.masksToBounds= YES;
    view.layer.borderColor = lineColor.CGColor;
    view.layer.borderWidth = lineWidth;
}

@end

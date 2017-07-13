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
    layer.strokeColor       = ColorWithRGB(235, 235, 235).CGColor;
    
    return layer;
}

+(CAShapeLayer *)cellBottomDrowLineWithTableViewCell:(UITableViewCell *)cell{
    return [WPBezierPath drowLineWithMoveToPoint:CGPointMake(0, cell.height-1) moveForPoint:CGPointMake(WINDOW_WIDTH, cell.height-1)];
}
+(CAShapeLayer *)cellBottomDrowLineWithCollectionCell:(UICollectionViewCell *)cell{
    return [WPBezierPath drowLineWithMoveToPoint:CGPointMake(0, cell.height-1) moveForPoint:CGPointMake(WINDOW_WIDTH, cell.height-1)];
}
@end

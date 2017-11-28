//
//  WPTimerTool.h
//  Wongo
//
//  Created by  WanGao on 2017/11/7.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WPTimerBlock)(void);
@interface WPTimerTool : NSObject
/**时间差*/
+(NSString *)createTimerStringWithFromTime:(NSString *)fromTime toTime:(NSString *)toTime;
/**倒计时*/
+(void)createCountdownWithTime:(CGFloat)time sender:(UIButton *)sender block:(WPTimerBlock)block;
@end

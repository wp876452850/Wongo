//
//  WPReportBox.h
//  Wongo
//
//  Created by  WanGao on 2017/9/22.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPReportBox : UIView
/**是否为交换物品举报*/
@property (nonatomic,assign)BOOL isExchange;

+(instancetype)createReportBoxWithGid:(NSString *)gid;

+(instancetype)createReportBoxWithPlid:(NSString *)plid;

@end

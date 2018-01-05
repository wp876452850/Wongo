//
//  WPMyConsignmentSendView.h
//  Wongo
//
//  Created by  WanGao on 2018/1/4.
//  Copyright © 2018年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WPMyConsignmentSendBlock)(void);

@interface WPMyConsignmentSendView : UIView

-(instancetype)initWithLid:(NSString *)lid;

-(void)sendGoodsWithBlock:(WPMyConsignmentSendBlock)block;
@end

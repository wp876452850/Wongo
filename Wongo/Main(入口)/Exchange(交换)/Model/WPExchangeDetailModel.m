//
//  WPExchangeDetailModel.m
//  Wongo
//
//  Created by rexsu on 2017/3/17.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPExchangeDetailModel.h"

@implementation WPExchangeDetailModel
-(instancetype)init{
    if (self = [super init]) {
        self.commentsModelArray =   [NSMutableArray arrayWithCapacity:3];
        self.rollPlayImages     =   [NSMutableArray arrayWithCapacity:3];
        self.goodsImages        =   [NSMutableArray arrayWithCapacity:3];
        self.parameters         = [NSMutableArray arrayWithObjects:@"流行款式:其它",@"质地:UP",@"适用对象:青年",@"背包:斜挎式",@"风格:摇滚",@"成色:全新",@"颜色:黑",@"软硬:软",@"闭合方式:拉链",@"运费:很贵", nil];
        self.unit               =   @"￥";
    }
    return self;
}
@end

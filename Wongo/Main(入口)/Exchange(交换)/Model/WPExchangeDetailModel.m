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
        self.unit               =   @"￥";
    }
    return self;
}
@end

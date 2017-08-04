//
//  WPProductDetailUserStoreModel.m
//  Wongo
//
//  Created by  WanGao on 2017/8/2.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPProductDetailUserStoreModel.h"


@implementation WPProductDetailUserStoreModel

-(NSMutableArray *)hotGoods{
    if (!_hotGoods) {
        _hotGoods = [NSMutableArray arrayWithCapacity:3];
    }
    return _hotGoods;
}

@end

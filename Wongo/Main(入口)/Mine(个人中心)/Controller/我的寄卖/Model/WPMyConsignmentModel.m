//
//  WPMyConsignmentModel.m
//  Wongo
//
//  Created by  WanGao on 2017/12/19.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPMyConsignmentModel.h"

@implementation WPMyConsignmentModel


-(void)setUrl:(NSString *)url{
    _url = url;
    if (!url||[url isKindOfClass:[NSNull class]]) {
        _url = @"";
    }
}


@end

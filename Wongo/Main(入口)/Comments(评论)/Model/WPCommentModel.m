//
//  WPCommentModel.m
//  Wongo
//
//  Created by  WanGao on 2017/7/25.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPCommentModel.h"

@implementation WPCommentModel
-(NSMutableArray *)comments{
    if (!_comments) {
        _comments = [NSMutableArray arrayWithCapacity:3];
    }
    return _comments;
}
@end

//
//  LYHomeBannerM.h
//  Wongo
//
//  Created by  WanGao on 2017/6/15.
//  Copyright © 2017年 Winny. All rights reserved.
//首页轮播模型

#import <Foundation/Foundation.h>

@interface LYHomeBannerM : NSObject
@property (nonatomic, strong) NSString *gcname;
@property (nonatomic, strong) NSString *url;

/**类型 0单图 1活动*/
@property (nonatomic, assign) int type;
@end

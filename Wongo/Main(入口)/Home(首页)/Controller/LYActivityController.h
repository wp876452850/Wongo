//
//  LYActivityController.h
//  Wongo
//
//  Created by  WanGao on 2017/6/15.
//  Copyright © 2017年 Winny. All rights reserved.
//  活动详情页

#import "LYBaseController.h"
#import "LYHomeBannerM.h"
#import "LYHomeCategory.h"

@interface LYActivityController : LYBaseController
+ (instancetype)controllerWith:(LYHomeBannerM *)banner;
+ (instancetype)controllerWithCategory:(LYHomeCategory *)Category;
@end

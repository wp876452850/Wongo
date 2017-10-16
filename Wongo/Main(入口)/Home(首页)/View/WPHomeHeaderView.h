//
//  WPHomeHeaderView.h
//  Wongo
//
//  Created by rexsu on 2017/2/6.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYHomeCategory.h"

@interface WPHomeHeaderView : UIView
/**轮播图数组*/
@property (nonatomic, strong) NSArray<LYHomeCategory *> *listhl;
/**活动数组*/
@property (nonatomic, strong) NSArray<LYHomeCategory *> *listhk;

@property (nonatomic, strong) UIButton *activityA;
@property (nonatomic, strong) UIButton *activityB;
@property (nonatomic, strong) UIButton *activityC;
@property (nonatomic, strong) UIButton *activityD;
@property (nonatomic, strong) UIButton *activityE;
@property (nonatomic, strong) UIButton *activityF;
- (void)tapImage:(UIButton *)sender;
@end

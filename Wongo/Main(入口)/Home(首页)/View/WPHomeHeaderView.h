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
//- (void)loadBanners;
@property (nonatomic, strong) NSArray<LYHomeCategory *> *listhl;
@property (nonatomic, strong) NSArray<LYHomeCategory *> *listhk;
@end

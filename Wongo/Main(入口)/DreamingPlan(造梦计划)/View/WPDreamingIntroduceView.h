//
//  WPDreamingIntroduceView.h
//  Wongo
//
//  Created by rexsu on 2017/3/1.
//  Copyright © 2017年 Winny. All rights reserved.
//  造梦详情-造梦商品介绍

#import <UIKit/UIKit.h>
#import "WPDreamingIntroduceModel.h"
#import "WPDreamingDetailViewController.h"

@interface WPDreamingIntroduceView : UIView

@property (nonatomic,strong)NSString * dreamingStory;

@property (nonatomic,strong)NSArray * dataSource;

@property (nonatomic,strong)WPDreamingDetailViewController * vc;

@end

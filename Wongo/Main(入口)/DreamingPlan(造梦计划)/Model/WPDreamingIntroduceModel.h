//
//  WPDreamingIntroduceModel.h
//  Wongo
//
//  Created by rexsu on 2017/3/1.
//  Copyright © 2017年 Winny. All rights reserved.
//  造梦详情内容model

#import <Foundation/Foundation.h>

@interface WPDreamingIntroduceModel : NSObject
//造门图集
@property (nonatomic,strong)NSArray  * dreamingIntroduces;
//造梦规则
@property (nonatomic,strong)NSString * dreamingRules;
//造梦故事
@property (nonatomic,strong)NSString * dreamingStory;

@end

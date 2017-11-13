//
//  WPDreamingIntroduceImageModel.m
//  test222
//
//  Created by rexsu on 2017/5/11.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPDreamingIntroduceImageModel.h"

@implementation WPDreamingIntroduceImageModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"userUrl":@"listuser[0].url"
             };
}

@end

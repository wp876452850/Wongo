//
//  WPUserIntroductionModel.h
//  Wongo
//
//  Created by rexsu on 2017/3/17.
//  Copyright © 2017年 Winny. All rights reserved.
//  用户简介

#import <Foundation/Foundation.h>

@interface WPUserIntroductionModel : NSObject

/**
 用户头像URL
 */
@property (nonatomic,strong)NSString * url;
/**
 用户名
 */
@property (nonatomic,strong)NSString * uname;
/**
 用户签名
 */
@property (nonatomic,strong)NSString * signature;
/**
 是否关注
 */
@property (nonatomic,strong)NSString * collect;
/**
 用户id
 */
@property (nonatomic,strong)NSString * uid;
@end

//
//  WPExchangeCommentsModel.h
//  Wongo
//
//  Created by rexsu on 2017/3/17.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPExchangeCommentsModel : NSObject
/**
 用户头像
 */
@property (nonatomic,strong)NSString * userImage_url;

/**
 用户名
 */
@property (nonatomic,strong)NSString * userName;

/**
 评论信息
 */
@property (nonatomic,strong)NSString * comment;

/**
 评论时间
 */
@property (nonatomic,strong)NSString * time;
@end

//
//  WPDreamingCommentsModel.h
//  Wongo
//
//  Created by rexsu on 2017/3/1.
//  Copyright © 2017年 Winny. All rights reserved.
//  评论model

#import <Foundation/Foundation.h>

@interface WPDreamingCommentsModel : NSObject
//评论人
@property (nonatomic,strong)NSString * uname;
//评论信息
@property (nonatomic,strong)NSString * comment;

@property (nonatomic,strong)NSString * proid;

@property (nonatomic,strong)NSString * cpid;

@property (nonatomic,strong)NSString * commenttime;
@end

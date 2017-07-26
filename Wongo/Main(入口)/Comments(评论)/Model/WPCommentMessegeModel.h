//
//  WPCommentMessegeModel.h
//  Wongo
//
//  Created by  WanGao on 2017/7/25.
//  Copyright © 2017年 Winny. All rights reserved.
//  评论评论/回复评论/回复回复

#import <Foundation/Foundation.h>

@interface WPCommentMessegeModel : NSObject

/**评论id*/
@property(nonatomic,copy)NSString *commentId;
/**用户id*/
@property(nonatomic,copy)NSString *uid;
/**用户名*/
@property(nonatomic,copy)NSString *uname;
/**头像*/
@property(nonatomic,copy)NSString *url;
/**内容*/
@property(nonatomic,copy)NSString *commentContent;
/**对方id*/
@property(nonatomic,copy)NSString *byuid;
/**对方用户名*/
@property(nonatomic,copy)NSString *byuname;
/**时间*/
@property(nonatomic,copy)NSString *createDateStr;
/**状态*/
@property(nonatomic,copy)NSString *checkStatus;
///评论大图
@property(nonatomic,copy)NSMutableArray *messageBigPicArray;
// 评论数据
@property (nonatomic,copy) NSMutableArray *commentModelArray;

@end

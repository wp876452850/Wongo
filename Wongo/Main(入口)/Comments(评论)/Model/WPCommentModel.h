//
//  WPCommentModel.h
//  Wongo
//
//  Created by  WanGao on 2017/7/25.
//  Copyright © 2017年 Winny. All rights reserved.
//  直接评论商品

#import <Foundation/Foundation.h>

@interface WPCommentModel : NSObject
/**造梦id*/
@property (nonatomic,strong)NSString * subid;
/**评论id*/
@property(nonatomic,copy)NSString *cid;
/**用户id*/
@property(nonatomic,copy)NSString *uid;
/**商品id*/
@property (nonatomic,strong)NSString * gid;
/**用户名*/
@property(nonatomic,copy)NSString *uname;
/**头像*/
@property(nonatomic,copy)UIImage *headImage;
/**内容*/
@property(nonatomic,copy)NSString *comment;
/**时间*/
@property(nonatomic,copy)NSString *commenttime;
/**二级评论数组*/
@property (nonatomic,strong)NSMutableArray * comments;

@end

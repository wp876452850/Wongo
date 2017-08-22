//
//  WPDreamingModel.h
//  Wongo
//
//  Created by rexsu on 2017/3/13.
//  Copyright © 2017年 Winny. All rights reserved.
//  造梦详细信息model

#import <Foundation/Foundation.h>
#import "WPSearchUserModel.h"
#import "WPDreamingCommentsModel.h"
#import "WPDreamingIntroduceModel.h"

@interface WPDreamingModel : NSObject
/**subid*/
@property (nonatomic,strong)NSString * subid;
/**用户uid*/
@property (nonatomic,strong)NSString * uid;
/**图片数组*/
@property (nonatomic,strong)NSMutableArray * images_url;
/**金额*/
@property (nonatomic,strong)NSString * price;
/**价格单位*/
@property (nonatomic,strong)NSString * unit;
/**进度*/
@property (nonatomic,strong)NSString * progress;
/**用户信息model*/
@property (nonatomic,strong)WPSearchUserModel * userModel;
/**内容信息model*/
@property (nonatomic,strong)WPDreamingIntroduceModel * introduceModel;
/**评论信息model*/
@property (nonatomic,strong)NSMutableArray* commentsModelArray;
/**cell行高*/
@property (nonatomic,assign)CGFloat rowHeight;

@end

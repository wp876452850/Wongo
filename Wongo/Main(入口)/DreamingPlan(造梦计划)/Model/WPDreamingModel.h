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
/**收货地址id*/
@property (nonatomic,strong)NSString * adid;
/**主题内容*/
@property (nonatomic,strong)NSString * contents;
/**商品类型*/
@property (nonatomic,strong)NSString * gcid;
/**造梦计划id*/
@property (nonatomic,strong)NSString * plid;
/**是否精选*/
@property (nonatomic,strong)NSString * isrecommend;
/**点赞数*/
@property (nonatomic,strong)NSString * praise;
/**商品id*/
@property (nonatomic,strong)NSString * proid;
/**发布时间*/
@property (nonatomic,strong)NSString * pubtime;
/**商品描述*/
@property (nonatomic,strong)NSString * remark;
/**商品故事*/
@property (nonatomic,strong)NSString * story;
/**用户名*/
@property (nonatomic,strong)NSString * uname;
/**轮播图*/
@property (nonatomic,strong)NSArray  * listimg;

/**商品主图*/
@property (nonatomic,strong)NSString * url;
/**目标物品*/
@property (nonatomic,strong)NSString * want;
/**商品名*/
@property (nonatomic,strong)NSString * proname;


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

//
//  WPDreamingDirectoryModel.h
//  Wongo
//
//  Created by rexsu on 2017/5/12.
//  Copyright © 2017年 Winny. All rights reserved.
//  造梦-专题model

#import <Foundation/Foundation.h>
#import "WPDreamingModel.h"

@interface WPDreamingDirectoryModel : NSObject
/**标题*/
@property (nonatomic,strong)NSString * contents;
/**造梦计划ID*/
@property (nonatomic,strong)NSString * proid;

@property (nonatomic,strong)NSString * subid;
/**造梦故事*/
@property (nonatomic,strong)NSString * story;
/***/
@property (nonatomic,strong)NSString * subject;
/**背景图片*/
@property (nonatomic,strong)NSString * prourl;

@property (nonatomic,strong)NSString * plid;
/**商品图片*/
@property (nonatomic,strong)NSString * url;

@property (nonatomic,strong)NSString * isrecommend;

@property (nonatomic,strong)WPDreamingModel * dreamingModel;



@end

//
//  LYHomeCategory.h
//  Wongo
//
//  Created by  WanGao on 2017/6/21.
//  Copyright © 2017年 Winny. All rights reserved.
//首页分类、活动

#import <Foundation/Foundation.h>

@interface LYHomeCategory : NSObject
/**分类、活动所属类别（新品、造梦、交换） */
@property (nonatomic, strong) NSString *class_;
/**状态 */
@property (nonatomic, assign) int state;
/**分类ID */
@property (nonatomic, assign) int tpid;
/**名称 */
@property (nonatomic, strong) NSString *tpname;
/**图片Url */
@property (nonatomic, strong) NSString *url;
/**类别下物品数量 */
@property (nonatomic, assign) int count;
/**介绍图片 */
@property (nonatomic, strong) NSString *urljs;
@end

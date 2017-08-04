//
//  LYHomeResponse.h
//  Wongo
//
//  Created by  WanGao on 2017/6/21.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYHomeCategory.h"

@interface LYHomeResponse : NSObject
/**k:正文形 l:轮播 */

/**f:交换发布 */
@property (nonatomic, strong) NSArray *listfk;
@property (nonatomic, strong) NSArray *listfl;
/**h:活动 */
@property (nonatomic, strong) NSArray *listhk;
@property (nonatomic, strong) NSArray *listhl;
/**x:新品 */
@property (nonatomic, strong) NSArray *listxk;
@property (nonatomic, strong) NSArray *listxl;
/**z:造梦 */
@property (nonatomic, strong) NSArray *listzk;
@property (nonatomic, strong) NSArray *listzl;

- (BOOL)hasBanner:(NSInteger)index;
- (BOOL)hasCategory:(NSInteger)section;
@end

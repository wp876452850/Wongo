//
//  NSMutableArray+WPSingletonStorageArrays.h
//  Wongo
//
//  Created by  WanGao on 2017/10/13.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (WPSingletonStorageArrays)
+(instancetype)sharedThumupArray;
+(instancetype)sharedFocusArray;
+(instancetype)sharedCollectionArray;

+(BOOL)thumUpWithinArrayContainsGid:(NSString *)gid;
+(BOOL)collectionWithinArrayContainsGid:(NSString *)gid;
@end

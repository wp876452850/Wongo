//
//  NSMutableArray+WPSingletonStorageArrays.m
//  Wongo
//
//  Created by  WanGao on 2017/10/13.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "NSMutableArray+WPSingletonStorageArrays.h"

@implementation NSMutableArray (WPSingletonStorageArrays)
static id thumupArray;
static id focusArray;
static id collectionArray;

+(instancetype)sharedThumupArray{
    if (thumupArray == nil) {
        
        @synchronized(self) {
            
            if(thumupArray == nil) {
                
                thumupArray = [[self alloc] init];
                
            }
        }
    }
    return thumupArray;
}
+(instancetype)sharedFocusArray{
    if (focusArray == nil) {
        
        @synchronized(self) {
            
            if(focusArray == nil) {
                
                focusArray = [[self alloc] init];
                
            }
        }
    }
    return focusArray;
}
+(instancetype)sharedCollectionArray{
    if (collectionArray == nil) {
        
        @synchronized(self) {
            
            if(collectionArray == nil) {
                
                collectionArray = [[self alloc] init];
                [collectionArray loadCollectionDatas];
            }
        }
    }
    return collectionArray;
}

#pragma mark - loadDatas

-(void)loadCollectionDatas{
    [WPNetWorking createPostRequestMenagerWithUrlString:QueryUserCollectionUrl params:@{@"uid":[self getSelfUid]} datas:^(NSDictionary *responseObject) {
        NSArray * list = responseObject[@"list"];
        for (NSDictionary * dic in list) {
            NSString * gid = dic[@"gid"];
            [collectionArray addObject:gid];
        }
    }];
}
-(void)loadFocusDatas{

}
@end

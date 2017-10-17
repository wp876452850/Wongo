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
                [thumupArray loadThumUpDatas];
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
-(void)loadThumUpDatas{
    [WPNetWorking createPostRequestMenagerWithUrlString:IncensesUidSelect params:@{@"uid":[self getSelfUid]} datas:^(NSDictionary *responseObject) {
        
    }];
}
-(void)loadFocusDatas{
    
}


#pragma mark - predicate

+(BOOL)thumUpWithinArrayContainsGid:(NSString *)gid
{
    if ([self determineWhetherTheLogin]) {
        NSArray * collectionArray =  [NSArray arrayWithArray:[NSMutableArray sharedThumupArray]];
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF == %@", gid];
        NSArray *results1 = [collectionArray filteredArrayUsingPredicate:predicate1];
        if (results1.count>0) {
            return YES;
        }
    }
    return NO;
}
+(BOOL)collectionWithinArrayContainsGid:(NSString *)gid
{
    if ([self determineWhetherTheLogin]) {
        NSArray * collectionArray =  [NSArray arrayWithArray:[NSMutableArray sharedCollectionArray]];
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF == %@", gid];
        NSArray *results1 = [collectionArray filteredArrayUsingPredicate:predicate1];
        if (results1.count>0) {
            return YES;
        }
    }
    return NO;
}
@end

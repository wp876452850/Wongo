//
//  WPGCD.m
//  Wongo
//
//  Created by rexsu on 2017/3/28.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPGCD.h"

@implementation WPGCD

+(instancetype)createUpLoadImageGCDWithImages:(NSArray *)images urlString:(NSString *)urlString params:(NSDictionary *)params
{
    NSLog(@"%@",params);
    WPGCD * gcd = [[WPGCD alloc]init];
    NSMutableArray* result = [NSMutableArray array];
    
    dispatch_group_t group = dispatch_group_create();
    
    for (NSInteger i = 0; i < images.count; i++) {
        dispatch_sync(dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT), ^{
            [WPNetWorking uploadedMorePhotosWithUrlString:urlString image:images[i] params:params fileNumber:i];
        });
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"上传完成!");
        for (id response in result) {
            NSLog(@"%@", response);
        }
    });
    return gcd;
}


@end

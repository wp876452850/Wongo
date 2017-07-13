//
//  WPGCD.h
//  Wongo
//
//  Created by rexsu on 2017/3/28.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPGCD : NSObject

/**
 上传多张图片
 @param images 图片数组
 */
+(instancetype)createUpLoadImageGCDWithImages:(NSArray *)images urlString:(NSString *)urlString params:(NSDictionary *)params;
@end

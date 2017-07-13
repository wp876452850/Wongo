//
//  WPNetWorking.h
//  Wongo
//
//  Created by rexsu on 2017/2/6.
//  Copyright © 2017年 Wongo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPHomeDataModel.h"
#import "AFNetworking.h"

typedef void(^DataBlock)(NSDictionary * responseObject);

typedef void(^FailureBlock)();
@interface WPNetWorking : NSObject

//上传数据menager
+(void)createGetRequestMenagerWithUrlString:(NSString *)urlString datas:(DataBlock)datas;
//获取数据manager
+(void)createPostRequestMenagerWithUrlString:(NSString *)urlString params:(NSDictionary *)params datas:(DataBlock)datas;
//
+(void)createPostRequestMenagerWithUrlString:(NSString *)urlString params:(NSDictionary *)params datas:(DataBlock)datas failureBlock:(FailureBlock)failue;
//


//获取主页数据
+(NSArray *)getHomeDataModelArray;
//图片上传
+(void)uploadedMorePhotosWithUrlString:(NSString *)urlString image:(UIImage *)image params:(NSDictionary *)params;


@end

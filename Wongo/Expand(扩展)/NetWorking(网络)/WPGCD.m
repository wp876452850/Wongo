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
            [WPNetWorking uploadedMorePhotosWithUrlString:urlString image:images[i] params:params];
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


//+(void)createUpLoadImageGCDWithImages:(NSArray *)images urlString:(NSString *)urlString params:(NSDictionary *)params {
//    // 准备保存结果的数组，元素个数与上传的图片个数相同，先用 NSNull 占位
//    NSMutableArray* result = [NSMutableArray array];
//    for (UIImage* image in images) {
//        [result addObject:[NSNull null]];
//    }
//    
//    dispatch_group_t group = dispatch_group_create();
//    
//    for (NSInteger i = 0; i < images.count; i++) {
//        
//        dispatch_group_enter(group);
//        
//        NSURLSessionUploadTask* uploadTask = [self uploadTaskWithImage:images[i] urlString:urlString params:params completion:^(NSURLResponse *response, id responseObject, NSError *error) {
//            if (error) {
//                NSLog(@"第 %d 张图片上传失败: %@", (int)i + 1, error);
//                dispatch_group_leave(group);
//            } else {
//                NSLog(@"第 %d 张图片上传成功: %@", (int)i + 1, responseObject);
//                @synchronized (result) { // NSMutableArray 是线程不安全的，所以加个同步锁
//                    result[i] = responseObject;
//                }
//                dispatch_group_leave(group);
//            }
//        }];
//        [uploadTask resume];
//    }
//    
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        NSLog(@"上传完成!");
//        for (id response in result) {
//            NSLog(@"%@", response);
//        }
//    });
//}
//
//
//+(NSURLSessionUploadTask*)uploadTaskWithImage:(UIImage*)image urlString:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionBlock {
//    // 构造 NSURLRequest
//    NSError* error = NULL;
//    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        
//        NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
//        [formData appendPartWithFileData:imageData name:@"photo" fileName:@"photo.jpg" mimeType:@"multipart/form-data"];
//        
//    } error:&error];    
//    // 可在此处配置验证信息
//    // 将 NSURLRequest 与 completionBlock 包装为 NSURLSessionUploadTask
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    
//    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
//    } completionHandler:completionBlock];
//    
//    return uploadTask;
//}


@end

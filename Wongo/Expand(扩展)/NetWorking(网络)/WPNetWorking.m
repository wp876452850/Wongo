 //
//  WPNetWorking.m
//  Wongo
//
//  Created by rexsu on 2017/2/6.
//  Copyright © 2017年 Wongo. All rights reserved.
//

#import "WPNetWorking.h"
#import "MBProgressHUD.h"

@implementation WPNetWorking

+(AFHTTPSessionManager*)createManager{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    return manager;
}

+(void)createGetRequestMenagerWithUrlString:(NSString *)urlString datas:(DataBlock)datas{
    
    AFHTTPSessionManager * manager = [WPNetWorking createManager];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (datas)
        {
            datas(dic);
        }
        NSLog(@"%@",dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

+(void)createPostRequestMenagerWithUrlString:(NSString *)urlString params:(NSDictionary *)params datas:(DataBlock)datas{
    
    NSLog(@"%@",urlString);
    NSLog(@"%@",params);
    __block MBProgressHUD * hud = [[self currentViewController] showMBProgressHUDDefault];
    AFHTTPSessionManager * manager = [WPNetWorking createManager];
    [manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hide:YES];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (datas)
        {
            datas(dic);
        }
        NSLog(@"return datas!!! %@ ===== %@",urlString,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [hud hide:YES];
        [[self currentViewController] showMBProgressHUDWithTitle:@"数据加载失败,请稍后重试"];
    }];
}
+(void)createPostRequestMenagerWithUrlString:(NSString *)urlString params:(NSDictionary *)params datas:(DataBlock)datas failureBlock:(FailureBlock)failue
{
    NSLog(@"%@",urlString);
    NSLog(@"%@",params);
     __block MBProgressHUD * hud = [[self currentViewController] showMBProgressHUDDefault];
    AFHTTPSessionManager * manager = [WPNetWorking createManager];
    [manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hide:YES];
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (datas)
        {
            datas(dic);
        }
        NSLog(@"return datas!!! %@ ===== %@",urlString,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [hud hide:YES];
        [[self currentViewController] showMBProgressHUDWithTitle:@"数据加载失败,请稍后重试"];
        if (failue) {
            failue();
        }
    }];
}

//上传图片
+(void)uploadedMorePhotosWithUrlString:(NSString *)urlString image:(UIImage *)image params:(NSDictionary *)params fileNumber:(NSInteger)fileNumber{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];//初始化请求对象
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//设置服务器允许的请求格式内容
    //上传图片/文字，只能同POST
    
    [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData * imageData = UIImageJPEGRepresentation(image, 1.0);
        /* 此方法参数
         1. 要上传的[二进制数据]
         2. 对应网站上[upload.php中]处理文件的[字段"file"]
         3. 要保存在服务器上的[文件名]
         4. 上传文件的[mimeType]
         */
        [formData appendPartWithFileData:imageData name:@"photo" fileName:[NSString stringWithFormat:@"%ld.jpg",fileNumber] mimeType:@"multipart/form-data"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress = %@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@, task = %@",responseObject,task);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
    
}


@end

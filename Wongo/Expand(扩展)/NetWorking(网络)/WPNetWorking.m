 //
//  WPNetWorking.m
//  Wongo
//
//  Created by rexsu on 2017/2/6.
//  Copyright © 2017年 Wongo. All rights reserved.
//

#import "WPNetWorking.h"

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
    AFHTTPSessionManager * manager = [WPNetWorking createManager];
    [manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (datas)
        {
            datas(dic);
        }
        NSLog(@"return datas!!! %@ ===== %@",urlString,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        WPTabBarController * tabBar = [WPTabBarController sharedTabbarController];
        UINavigationController * nav = tabBar.viewControllers.lastObject;
        UIViewController * vc = nav.viewControllers.lastObject;
        [vc showAlertWithAlertTitle:@"网络异常" message:@"请稍后重试" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
    }];
}
+(void)createPostRequestMenagerWithUrlString:(NSString *)urlString params:(NSDictionary *)params datas:(DataBlock)datas failureBlock:(FailureBlock)failue
{
    NSLog(@"%@",urlString);
    NSLog(@"%@",params);
    AFHTTPSessionManager * manager = [WPNetWorking createManager];
    [manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (datas)
        {
            datas(dic);
        }
        NSLog(@"return datas!!! %@ ===== %@",urlString,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        WPTabBarController * tabBar = [WPTabBarController sharedTabbarController];
        UINavigationController * nav = tabBar.viewControllers.lastObject;
        UIViewController * vc = nav.viewControllers.lastObject;
        [vc showAlertWithAlertTitle:@"网络异常" message:@"请稍后重试" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
        if (failue) {
            failue();
        }
    }];
}


+(NSArray *)getHomeDataModelArray{
    NSMutableArray * dataSource = [NSMutableArray arrayWithCapacity:3];
    
    return dataSource;
}


//上传图片
+(void)uploadedMorePhotosWithUrlString:(NSString *)urlString image:(UIImage *)image params:(NSDictionary *)params{
    
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
        [formData appendPartWithFileData:imageData name:@"photo" fileName:@"photo.jpg" mimeType:@"multipart/form-data"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress = %@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@, task = %@",responseObject,task);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
    
}


@end

//
//  WPAddImagesButton.m
//  Wongo
//
//  Created by rexsu on 2017/3/7.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPAddImagesButton.h"
#import "SKFCamera.h"
#import "WPPhotoLibrary.h"
#import "WPPushExchangeViewController.h"




@interface WPAddImagesButton ()<WPPhotoLibraryDelegate>
{
    BackImageBlock _backBlock;
}
@end
@implementation WPAddImagesButton

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [self setImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
    }
    return self;
}

-(void)buttonClick{
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self jumpCamera];
    }];
    UIAlertAction * photoLibrary = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self jumpPhotoLibrary];
    }];
    UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:camera];
    [alertController addAction:photoLibrary];
    [alertController addAction:cancle];
//    UINavigationController * nav = [WPTabBarController sharedTabbarController].selectedViewController;
//    [nav.viewControllers.lastObject presentViewController:alertController animated:YES completion:nil];
    UIViewController * viewcontroller = [self findViewController:self];
    [viewcontroller presentViewController:alertController animated:YES completion:nil];
}

-(void)jumpCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        SKFCamera *homec=[[SKFCamera alloc]init];
        
        homec.fininshcapture=^(UIImage *ss){
            if (ss) {
                if (_backBlock) {
                    _backBlock(ss);
                }
#warning 后期上传服务器
            }
        } ;
        [[self findViewController:self] presentViewController:homec animated:NO completion:^{}];
    }
    else{
        //NSLog(@"相机调用失败");
    }
    
}

-(void)jumpPhotoLibrary
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        WPPhotoLibrary * photoLibrary = [[WPPhotoLibrary alloc]initWithCurrentView:self];
        photoLibrary.photoDelegate = self;
    }
}

-(void)getSelectPhotoWithImage:(UIImage *)image
{
    if (_backBlock) {
        _backBlock(image);
    }
#warning 后期上传服务器
}


-(void)getSelectPhotoWithBlock:(BackImageBlock)block{
    _backBlock = block;
}
@end

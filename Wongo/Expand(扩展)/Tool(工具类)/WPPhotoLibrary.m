//
//  WPPhotoLibrary.m
//  拍照功能
//
//  Created by rexsu on 2016/11/22.
//  Copyright © 2016年 Winny. All rights reserved.
//

#import "WPPhotoLibrary.h"

@interface WPPhotoLibrary ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)UIImage * photo;

@end

@implementation WPPhotoLibrary

-(instancetype)initWithCurrentView:(UIView *)view{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.allowsEditing = YES;
        self.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [[self findViewController:view] presentViewController:self animated:YES completion:nil];
    }
    return self;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.allowsEditing = YES;
        self.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self animated:YES completion:nil];
    }
    return self;
}
#pragma mark - 选择图片返回结果
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    
    if (self.photoDelegate && [self.photoDelegate respondsToSelector:@selector(getSelectPhotoWithImage:)]) {
        [self.photoDelegate getSelectPhotoWithImage:image];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}




@end

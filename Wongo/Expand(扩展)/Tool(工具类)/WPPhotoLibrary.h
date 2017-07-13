//
//  WPPhotoLibrary.h
//  拍照功能
//
//  Created by rexsu on 2016/11/22.
//  Copyright © 2016年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WPPhotoLibraryDelegate <NSObject>

-(void)getSelectPhotoWithImage:(UIImage*)image;

@end

typedef void (^PHOTOBLOCK)(UIImage * image);

@interface WPPhotoLibrary : UIImagePickerController

@property (nonatomic,assign)id<WPPhotoLibraryDelegate> photoDelegate;

-(instancetype)initWithCurrentView:(UIView *)view;
@end

//
//  SDPhotoBrowser.h
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SDButton, SDPhotoBrowser;

@protocol SDPhotoBrowserDelegate <NSObject>

@required
/**图片滑动代理方法*/
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;

@optional

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;
/**
 supperView：当前view
 index：当前滑动的图片下标
 imageview：当前图片
 */
/**点击图片缩放到指定item位置*/
- (void)selfView:(UIView*)supperView imageForIndex:(NSInteger)index  currentImageView:(UIImageView *)imageview;
@end


@interface SDPhotoBrowser : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, strong) NSMutableArray *imageContainerArr;
@property (nonatomic, weak) id<SDPhotoBrowserDelegate> delegate;

- (void)show;

@end

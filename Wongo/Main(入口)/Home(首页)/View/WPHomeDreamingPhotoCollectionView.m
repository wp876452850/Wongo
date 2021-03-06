//
//  WPHomeDreamingPhotoCollectionView.m
//  Wongo
//
//  Created by  WanGao on 2017/11/4.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPHomeDreamingPhotoCollectionView.h"
#import "ZYPhotoBrowserConfig.h"
//展示
#import "WPHomeDreamingPhotoCollectionViewCell.h"
#import "ZYPhotoBrowser.h"
//图片模型
#import "ZYPhotoModel.h"
//第三方
#import "SDImageCache.h"


@interface WPHomeDreamingPhotoCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, HZPhotoBrowserDelegate>

@property (nonatomic, assign) CGFloat width;
@end

@implementation WPHomeDreamingPhotoCollectionView


-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame collectionViewLayout:self.layout]) {
        if (frame.size.width == 0) {
            self.width = [UIScreen mainScreen].bounds.size.width;
        } else {
            self.width = frame.size.width;
        }
        
        [self registerNib:[UINib nibWithNibName:@"WPHomeDreamingPhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"WPHomeDreamingPhotoCollectionViewCell"];
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = ZYSmallPhotoBackgrounColor;
        self.scrollEnabled = NO;
    }
    return self;
}

#pragma mark - 布局 小图时展示图片控件的大小
-(void)getLayoutSizeWithWidth:(CGFloat)width {
    
}


#pragma mark - collection 代理 & 数据源
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photoModelArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WPHomeDreamingPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WPHomeDreamingPhotoCollectionViewCell" forIndexPath:indexPath];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self buttonClick:indexPath];
}

- (void)buttonClick:(NSIndexPath *)indexPath {
    ZYPhotoBrowser *browser = [[ZYPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self;
    browser.imageCount = self.photoModelArray.count;
    browser.currentImageIndex = (int)indexPath.item;
    browser.delegate = self;
    [browser show];
}

#pragma mark - photobrowser代理方法
- (UIImage *)photoBrowser:(ZYPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    NSString *smallImageURL = [self.photoModelArray[index] smallImageURL];
    if ([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:smallImageURL] == nil) {
        return ZYPlaceholderImage;
    } else {
        return [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:smallImageURL];
    }
}

- (NSURL *)photoBrowser:(ZYPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    NSString *urlStr = [self.photoModelArray[index] bigImageURL];
    
    return [NSURL URLWithString:urlStr];
}

#pragma mark - 懒加载
-(void)setPhotoModelArray:(NSArray<ZYPhotoModel *> *)photoModelArray {
    _photoModelArray = photoModelArray;
    [self getLayoutSizeWithWidth:self.width];
}

-(UICollectionViewFlowLayout *)layout {
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //设置最小行间距
        _layout.minimumLineSpacing = 10.f;
    }
    return _layout;
}

-(void)setWidth:(CGFloat)width {
    _width = width;
    [self getLayoutSizeWithWidth:width];
}
@end

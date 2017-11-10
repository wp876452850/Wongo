//
//  WPDremingImagesCellTableViewCell.m
//  Wongo
//
//  Created by rexsu on 2017/3/9.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPDremingImagesCellTableViewCell.h"
#import "WPAddImagesButton.h"
#import "WPGoodsImageView.h"
#import "WPPushImageCollectionViewCell.h"

#define AddButton_Width_Height WINDOW_WIDTH /3 - 30
#define Max_Images 15


@interface WPDremingImagesCellTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDPhotoBrowserDelegate>
{
    BackImagesBlock _backImagesBlock;
    WPAddImagesButton * _addButton;
    NSInteger _imagesCount;
}
@property (nonatomic,strong)UICollectionView * collectionView;

@end
@implementation WPDremingImagesCellTableViewCell

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout  = [[UICollectionViewFlowLayout alloc] init];
        //cell之间的最小间距
        flowLayout.minimumLineSpacing           = 20;
        flowLayout.minimumInteritemSpacing      = 0;
        flowLayout.itemSize                     = CGSizeMake(AddButton_Width_Height,AddButton_Width_Height);
        _collectionView                         = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, AddButton_Width_Height +40) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor         = WhiteColor;
        _collectionView.dataSource              = self;
        _collectionView.delegate                = self;
        _collectionView.backgroundColor = WhiteColor;
        [_collectionView registerNib:[UINib nibWithNibName:@"WPPushImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"addButtonCell"];
        [self.contentView addSubview:_collectionView];
    }
    return _collectionView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _images = [NSMutableArray arrayWithCapacity:3];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _addButton = [[WPAddImagesButton alloc]initWithFrame:CGRectMake(0,0, AddButton_Width_Height, AddButton_Width_Height)];
    _rowHeight = _addButton.height + 40 ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

-(void)setImages:(NSMutableArray *)images{
    [self.contentView addSubview:self.collectionView];
    [self.collectionView reloadData];
}

-(void)getRowDataWithBlock:(BackImagesBlock)block{
    _backImagesBlock = block;
}


#pragma mark - CollectionViewDelegate&&CollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_imagesCount>=Max_Images) {
        [[self findViewController:self] showAlertWithAlertTitle:@"提示" message:@"宝贝图片不能超过10张,多出的图片将自动去除" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
        
    }
    return self.images.count<Max_Images?self.images.count + 1:Max_Images+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.images.count > 0 && indexPath.row < self.images.count) {
        WPPushImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        cell.imageView.image = self.images[indexPath.row];
        [cell.imageView getBlock:^{
            [_images removeObjectAtIndex:indexPath.row];
            _rowHeight = (_images.count /3)*(AddButton_Width_Height+20) + AddButton_Width_Height+40;
            _collectionView.height = _rowHeight;
            _backImagesBlock(_images,_rowHeight);
            [_collectionView reloadData];
        }];
        return cell;
    }
    
    //添加按钮
    if (indexPath.row == _images.count) {
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addButtonCell" forIndexPath:indexPath];
        __block typeof(self)weakSelf = self;
        [_addButton getSelectPhotoWithBlock:^(NSArray * imagesArray) {
            for (UIImage * image in imagesArray) {
                [weakSelf.images addObject:image];
            }
            _imagesCount = weakSelf.images.count;
            while (weakSelf.images.count>10) {
                [weakSelf.images removeObjectAtIndex:10];
            }
            weakSelf.rowHeight = (weakSelf.images.count /3)*(AddButton_Width_Height+20) + AddButton_Width_Height+40;
            weakSelf.collectionView.height = weakSelf.rowHeight;
            _backImagesBlock(weakSelf.images,weakSelf.rowHeight);
            [weakSelf.collectionView reloadData];
        }];
        if (_images.count>=Max_Images) {
            _addButton.userInteractionEnabled = NO;
        }else{
            _addButton.userInteractionEnabled = YES;
        }
        [cell.contentView addSubview:_addButton];
        return cell;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _images.count) {
        [[self findViewController:self] showAlertWithAlertTitle:@"提示" message:@"宝贝图片已达到上限(10张),无法继续添加" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
        return;
    }
    WPPushImageCollectionViewCell *cell =(WPPushImageCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
    
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = indexPath.row;
    browser.sourceImagesContainerView = cell.contentView;
    browser.imageCount = self.images.count;
    browser.delegate = self;
    [browser show];
}
- (CGSize) collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = {AddButton_Width_Height,AddButton_Width_Height};
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20, 20, 0, 20);
}

#pragma mark - SDPhotoBrowserDelegate
//展示的图片与对应的index
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImage *image = self.images[index];
    return image;
}
//点击缩小图片至什么位置
- (void)selfView:(UIView *)supperView imageForIndex:(NSInteger)index currentImageView:(UIImageView *)imageview {
    
    NSIndexPath *CellIndexPath = [NSIndexPath indexPathForRow: index inSection:0];
    WPPushImageCollectionViewCell *cell = (WPPushImageCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:CellIndexPath];
    //如果cell不存在，从重用池中取出cell
    if (!cell) {
        [self.collectionView scrollToItemAtIndexPath:CellIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        [_collectionView layoutIfNeeded];
        cell = (WPPushImageCollectionViewCell*)[_collectionView cellForItemAtIndexPath:CellIndexPath];
    }
    CGRect targetTemp = [cell.contentView convertRect:cell.contentView.frame toView:supperView];
    [UIView animateWithDuration:0.4f    animations:^{
        imageview.frame = targetTemp;
        supperView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [supperView removeFromSuperview];
    }];
}


@end

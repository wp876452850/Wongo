//
//  WPDreamingIntroduceTableViewCell.m
//  test222
//
//  Created by rexsu on 2017/5/11.
//  Copyright © 2017年 Winny. All rights reserved.
//  造梦详情-物品介绍-文字内容

#import "WPDreamingIntroduceTableViewCell.h"
#import "Masonry.h"
#import "UIView+Extension.h"
#import "WPStoreViewController.h"
#import "ZYPhotoCollectionView.h"
#import "ZYPhotoModel.h"

#define Window_Width [UIScreen mainScreen].bounds.size.width
#define ImageWidth (Window_Width-70)/4

@interface WPDreamingIntroduceTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *goodsIntroduce;
@property (nonatomic,strong)ZYPhotoCollectionView * collectionView;
/**外部传来的图，url*/
@property (nonatomic,strong)NSMutableArray * images;
/**将外部传来的图封装成model存储数组*/
@property (nonatomic,strong)NSMutableArray * imagesData;

@end
@implementation WPDreamingIntroduceTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _headerView.userInteractionEnabled = YES;
    _headerView.layer.masksToBounds = YES;
    _headerView.layer.cornerRadius  = 25.f;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goStore)];
    [_headerView addGestureRecognizer:tap];
    self.images = [NSMutableArray arrayWithCapacity:3];
    [self.contentView addSubview:self.collectionView];
}
-(ZYPhotoCollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[ZYPhotoCollectionView alloc]initWithFrame:CGRectMake(10, 20, WINDOW_WIDTH-20, 80)];
        _collectionView.layout.itemSize = CGSizeMake(80, 80);
        _collectionView.backgroundColor = WhiteColor;
    }
    return _collectionView;
}
//前往店铺
-(void)goStore{
    WPStoreViewController * vc = [[WPStoreViewController alloc]initWithUid:_model.uid];
    vc.isPresen = YES;
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [[self findViewController:self]presentViewController:nav animated:YES completion:nil];
}

-(void)setModel:(WPDreamingIntroduceImageModel *)model{
    _model = model;
    _collectionView.contentOffset = CGPointMake(0, 0);
    _userName.text = _model.uname;
    _goodsIntroduce.text = _model.remark;
    _images = [NSMutableArray arrayWithCapacity:3];
    _imagesData = [NSMutableArray arrayWithCapacity:3];
    
    for (int i = 0; i<_model.listimg.count; i++) {
        [_images addObject:_model.listimg[i][@"url"]];
        ZYPhotoModel * photoModel = [[ZYPhotoModel alloc]initWithsmallImageURL:_images[i] bigImageURL:_images[i]];
        [_imagesData addObject:photoModel];
    }
    _collectionView.photoModelArray = _imagesData;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _images.count;
}

@end

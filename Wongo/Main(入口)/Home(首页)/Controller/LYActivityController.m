//
//  LYActivityController.m
//  Wongo
//
//  Created by  WanGao on 2017/6/15.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "LYActivityController.h"
#import "WPActivityGoodsCollectionViewCell.h"
#import "WPExchangeDetailModel.h"
#import "WPExchangeModel.h"

#define Cell_HeightDouble (WINDOW_WIDTH + 125)
@interface LYActivityController ()<UICollectionViewDelegate,UICollectionViewDataSource>
//首页轮播模型
@property (nonatomic, strong) LYHomeBannerM  *banner;
//首页分类、活动
@property (nonatomic, strong) LYHomeCategory *category;
//展示集成视图
@property (nonatomic, strong) UICollectionView *collectionView;
//商品
@property (nonatomic, strong) NSMutableArray *goods;
//详细商品
@property (nonatomic, strong) NSMutableArray *detailGoods;
//介绍视图
@property (nonatomic, strong) UIImageView *introduceView;

@end

@implementation LYActivityController

- (UIImageView *)introduceView{
    if (!_introduceView) {
        _introduceView = [[UIImageView alloc] init];
    }
    return _introduceView;
}
- (NSMutableArray *)detailGoods{
    if (!_detailGoods) {
        _detailGoods = [NSMutableArray array];
    }
    return _detailGoods;
}
- (NSMutableArray *)goods{
    if (!_goods) {
        _goods = [NSMutableArray array];
    }
    return _goods;
}

+ (instancetype)controllerWith:(LYHomeBannerM *)banner{
    LYActivityController *vc = [[LYActivityController alloc] init];
    vc.myNavItem.title = banner.gcname;
    vc.banner = banner;
    return vc;
}

+ (instancetype)controllerWithCategory:(LYHomeCategory *)category{
    LYActivityController *vc = [[LYActivityController alloc] init];
    vc.myNavItem.title = category.tpname;
    vc.category = category;
    return vc;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView addSubview:self.introduceView];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"WPActivityGoodsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.collectionView belowSubview:self.myNavBar];
    [self.introduceView sd_setImageWithURL:[NSURL URLWithString:self.category.urljs] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error) {
            CGFloat w = image.size.width;
            CGFloat h = image.size.height;
            h = WINDOW_WIDTH/w*h;
            self.introduceView.frame = CGRectMake(0, 0, WINDOW_WIDTH, h);
            self.introduceView.image = image;
            [self.collectionView reloadData];
        }
    }];
    self.collectionView.mj_header = [WPAnimationHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)loadData{
    [WPNetWorking createPostRequestMenagerWithUrlString:QtQueryTypegdlist params:@{@"tpid":@(_category.tpid)} datas:^(NSDictionary *responseObject) {
        [self.collectionView.mj_header endRefreshing];
        if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject[@"flag"] intValue] == 1) {
            NSMutableArray *goods;
            if ([(goods=responseObject[@"list"]) isKindOfClass:[NSArray class]]) {
                [self.goods removeAllObjects];
                for (NSDictionary * item in goods) {
                    WPExchangeModel * model = [WPExchangeModel mj_objectWithKeyValues:item];
                    [self.goods addObject:model];
                }
                [self.collectionView reloadData];
            }
        }
    }failureBlock:^{
        [self.collectionView.mj_header endRefreshing];
    }];
}
#pragma mark - collectionViewDelegate && collectionViewDataSource
//每个单元格返回的大小
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath{
    return CGSizeMake(WINDOW_WIDTH , Cell_HeightDouble);
}

//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goods.count;
}
//配置单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WPActivityGoodsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.goods[indexPath.row];
    cell.activityState = self.activityState;
    return cell;
}
//返回每个区头大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(WINDOW_WIDTH, self.introduceView.height + 10);
}

////设置每个item水平间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    return 0;
//}
////设置每个item垂直间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    return 10;
//}
////设置每个item的UIEdgeInsets
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(10, 10, 10, 10);
//}



@end

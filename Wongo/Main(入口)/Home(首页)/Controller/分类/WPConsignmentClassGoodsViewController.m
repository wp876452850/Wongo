//
//  WPConsignmentClassGoodsViewController.m
//  Wongo
//
//  Created by  WanGao on 2017/12/21.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPConsignmentClassGoodsViewController.h"
#import "WPConsignmentModel.h"
#import "WPStoreConsignmentCollectionViewCell.h"
#define Cell_Height (WINDOW_WIDTH*0.5+60)

@interface WPConsignmentClassGoodsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSInteger _page;
    NSString * _gcid;
    NSString * _tpid;
    NSString * _imageUrl;
}

@property (nonatomic,strong)NSMutableArray * dataSourceArray;

@end

@implementation WPConsignmentClassGoodsViewController

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT-64) collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"WPStoreConsignmentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        _page = 1;
        _collectionView.backgroundColor = WhiteColor;
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

-(instancetype)initWithGcid:(NSString *)gcid{
    if (self = [super init]) {
        _gcid = gcid;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self addHeader];
    [self addFooter];
}

#pragma mark - loadDatas
-(void)addHeader{
    __weak typeof(self) weakSelf = self;
    self.collectionView.mj_header = [WPAnimationHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewClassificationDatas];
    }];
    [self.collectionView.mj_header beginRefreshing];
}

-(void)addFooter{
    __weak typeof(self) weakSelf = self;
    self.collectionView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreClassificationDatas];
    }];
    [weakSelf.collectionView.mj_footer beginRefreshing];
}

#pragma mark - 获取搜索分类数据

-(void)loadNewClassificationDatas{
    __weak typeof(self) weakSelf = self;
    _dataSourceArray = [NSMutableArray arrayWithCapacity:3];
    [WPNetWorking createPostRequestMenagerWithUrlString:LogisticsQueryClo params:@{@"currPage":@(1),@"gcid":_gcid} datas:^(NSDictionary *responseObject) {
        NSArray * goods = [responseObject objectForKey:@"goodsFb"];
        if ([[responseObject valueForKey:@"goods"] isKindOfClass:[NSNull class]]) {
            [weakSelf.collectionView.mj_footer endRefreshing];
            return;
        }
        for (int i = 0 ; i < goods.count; i++) {
            WPConsignmentModel * model = [WPConsignmentModel mj_objectWithKeyValues:goods[i]];
            [weakSelf.dataSourceArray addObject:model];
        }
        // 刷新表格
        [weakSelf.collectionView reloadData];
        // 隐藏当前的上拉刷新控件
        [weakSelf.collectionView.mj_header endRefreshing];
        _page++;
    } failureBlock:^{
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
}

-(void)loadMoreClassificationDatas{
    __weak typeof(self) weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:LogisticsQueryClo params:@{@"currPage":@(_page),@"gcid":_gcid} datas:^(NSDictionary *responseObject) {
        NSArray * goods = [responseObject objectForKey:@"goodsFb"];
        if ([[responseObject valueForKey:@"goods"] isKindOfClass:[NSNull class]]) {
            [weakSelf.collectionView.mj_footer endRefreshing];
            return;
        }
        for (int i = 0 ; i < goods.count; i++) {
            WPConsignmentModel * model = [WPConsignmentModel mj_objectWithKeyValues:goods[i]];
            [weakSelf.dataSourceArray addObject:model];
        }
        // 刷新表格
        [weakSelf.collectionView reloadData];
        // 隐藏当前的上拉刷新控件
        [weakSelf.collectionView.mj_footer endRefreshing];
        _page++;
    } failureBlock:^{
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
}

#pragma mark - CollectionDelegate && CollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataSourceArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WPStoreConsignmentCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.dataSourceArray[indexPath.row];
    return cell;
}

//返回每个区头大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(WINDOW_WIDTH,10);
}

//每个单元格返回的大小
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath{
    return CGSizeMake((WINDOW_WIDTH) * 0.5 - 7.5, Cell_Height);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

//设置边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 5, 10, 5);
}

@end

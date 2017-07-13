//
//  WPChoiceSubCollectionView.m
//  Wongo
//
//  Created by rexsu on 2017/4/12.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPChoiceSubCollectionView.h"
#import "WPHotCell.h"
#import "WPHomeDataModel.h"
#import "SDCycleScrollView.h"

#define HeaderMenuHeight 104
#define Cell_Height (WINDOW_WIDTH*0.5 + 64)

@interface WPChoiceSubCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSInteger _page;
    /**一级分类*/
    NSString * _primaryClassification;
    /**二级分类*/
    NSString * _secondaryClassification;
}
@property (nonatomic,strong)SDCycleScrollView * cycleScrollView;

@property (nonatomic,strong)NSMutableArray * dataSourceArray;


@end
@implementation WPChoiceSubCollectionView
static NSString * const reuseIdentifier = @"Cell";

-(SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
#warning 有后台记得改
        //_cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:RollPlayFrame imageURLStringsGroup:self.rollPlayImages];
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:RollPlayFrame imageNamesGroup:@[@"5.jpg",@"6.jpg",@"7.jpg",@"8.jpg"]];
    }
    return _cycleScrollView;
}
-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout loadDatasUrl:(NSString *)url cellClass:(Class)cellClass{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) 
        if (cellClass == [WPHotCell class]) {
            [self registerNib:[UINib nibWithNibName:@"WPHotCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
        _page = 1;
        self.backgroundColor = WhiteColor;
        self.delegate   = self;
        self.dataSource = self;
        [self addFooterWithUrl:url];
        [self addHeaderWithUrl:url];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSourceArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WPHotCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.model = _dataSourceArray[indexPath.row];
    return cell;
}

//每个单元格返回的大小
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath{
    
     return CGSizeMake((WINDOW_WIDTH) * 0.5 - 15, Cell_Height);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
#pragma mark - loadDatas

-(void)addHeaderWithUrl:(NSString *)url{
    __weak WPChoiceSubCollectionView * weakSelf = self;
    self.mj_header = [WPAnimationHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewDatasWithUrl:url];
    }];
    [self.mj_header beginRefreshing];
}
-(void)addFooterWithUrl:(NSString *)url{
    __weak WPChoiceSubCollectionView * weakSelf = self;
    self.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreDatasWithUrl:url];
    }];
    [self.mj_footer beginRefreshing];
}

-(void)loadNewDatasWithUrl:(NSString *)url{
    
    __weak WPChoiceSubCollectionView * weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:url params:@{@"currPage":@(1),@"pubtime":@"sb"} datas:^(NSDictionary *responseObject) {
        NSArray * goods = [responseObject objectForKey:@"goods"];
        _dataSourceArray = [NSMutableArray arrayWithCapacity:3];
        for (NSDictionary * item in goods) {
            WPHomeDataModel * model = [WPHomeDataModel mj_objectWithKeyValues:item];
            [_dataSourceArray addObject:model];
        }
        // 刷新表格
        [weakSelf reloadData];
        // 隐藏当前的上拉刷新控件
        [weakSelf.mj_header endRefreshing];
        _page++;
    } failureBlock:^{
        [weakSelf.mj_header endRefreshing];
    }];
}

-(void)loadMoreDatasWithUrl:(NSString *)url{
    __weak WPChoiceSubCollectionView * weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:url params:@{@"currPage":@(_page),@"pubtime":@"sb"} datas:^(NSDictionary *responseObject) {
        NSArray * goods = [responseObject objectForKey:@"goods"];
        if ([[responseObject valueForKey:@"goods"] isKindOfClass:[NSNull class]]) {
            [weakSelf.mj_footer endRefreshing];
            return;
        }
        
        for (NSDictionary * item in goods) {
            WPHomeDataModel * model = [WPHomeDataModel mj_objectWithKeyValues:item];
            [_dataSourceArray addObject:model];
        }
        // 刷新表格
        [weakSelf reloadData];
        // 隐藏当前的上拉刷新控件
        [weakSelf.mj_footer endRefreshing];
        _page++;
    } failureBlock:^{
        [weakSelf.mj_footer endRefreshing];
    }];
}

@end

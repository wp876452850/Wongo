//
//  WPCollectionBaseViewController.m
//  Wongo
//
//  Created by  WanGao on 2017/9/25.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPCollectionBaseViewController.h"
#import "WPNewExchangeModel.h"

@interface WPCollectionBaseViewController (){
    NSInteger _page;
}

@property (nonatomic,strong)UICollectionViewFlowLayout * layout;

@property (nonatomic,strong)NSMutableArray * dataSourceArray;

@end

@implementation WPCollectionBaseViewController

-(instancetype)initWithLayout:(UICollectionViewFlowLayout *)layout{
    if (self = [super init]) {
        self.layout = layout;
        [self.view addSubview:self.collectionView];
    }
    return self;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT-64) collectionViewLayout:self.layout];
        
    }
    return _collectionView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
}


#pragma mark - loadDatas

-(void)addHeader{
    __weak WPCollectionBaseViewController * weakSelf = self;
    self.collectionView.mj_header = [WPAnimationHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewDatas];
    }];
    [self.collectionView.mj_header beginRefreshing];
}

-(void)addFooter{
    __weak WPCollectionBaseViewController * weakSelf = self;
    self.collectionView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreDatas];
    }];
    [self.collectionView.mj_footer beginRefreshing];
}

-(void)loadNewDatas{
    __weak WPCollectionBaseViewController * weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:self.url params:@{@"currPage":@(1),@"pubtime":@"sb"} datas:^(NSDictionary *responseObject) {
        NSArray * goods = [responseObject objectForKey:@"goods"];
        _dataSourceArray = [NSMutableArray arrayWithCapacity:3];
        for (NSDictionary * item in goods) {
            WPNewExchangeModel * model = [WPNewExchangeModel mj_objectWithKeyValues:item];
            [_dataSourceArray addObject:model];
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

-(void)loadMoreDatas{
    __weak WPCollectionBaseViewController * weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:self.url params:@{@"currPage":@(_page),@"pubtime":@"sb"} datas:^(NSDictionary *responseObject) {
        NSArray * goods = [responseObject objectForKey:@"goods"];
        if ([[responseObject valueForKey:@"goods"] isKindOfClass:[NSNull class]]) {
            [weakSelf.collectionView.mj_footer endRefreshing];
            return;
        }
        for (NSDictionary * item in goods) {
            WPNewExchangeModel * model = [WPNewExchangeModel mj_objectWithKeyValues:item];
            [_dataSourceArray addObject:model];
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

@end

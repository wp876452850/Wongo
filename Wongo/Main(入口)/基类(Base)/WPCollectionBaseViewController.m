//
//  WPCollectionBaseViewController.m
//  Wongo
//
//  Created by  WanGao on 2017/9/25.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPCollectionBaseViewController.h"
#import "WPNewExchangeModel.h"
#import "WPNewExchangeCollectionViewCell.h"
#define Cell_Height (WINDOW_WIDTH*0.5+60)

@interface WPCollectionBaseViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSInteger _page;
    NSString * _gcid;
    NSString * _tpid;
    NSString * _imageUrl;
}

//介绍视图
@property (nonatomic, strong) UIImageView *introduceView;

@property (nonatomic,strong)NSMutableArray * dataSourceArray;

@end

@implementation WPCollectionBaseViewController
- (UIImageView *)introduceView{
    if (!_introduceView) {
        _introduceView = [[UIImageView alloc] init];
    }
    return _introduceView;
}
-(instancetype)initWithGcid:(NSString *)gcid{
    if (self = [super init]) {
        _gcid = gcid;
    }
    return self;
}
-(instancetype)initWithWithTpid:(NSString *)tpid imageUrl:(NSString *)imageUrl{
    if (self = [super init]) {
        _tpid = tpid;
        _imageUrl = imageUrl;
    }
    return self;
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT-64) collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"WPNewExchangeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        _page = 1;
        _collectionView.backgroundColor = WhiteColor;
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        [_collectionView addSubview:self.introduceView];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)setUrl:(NSString *)url{
    _url = url;
    [self.view addSubview:self.collectionView];
    [self.introduceView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error) {
            CGFloat w = image.size.width;
            CGFloat h = image.size.height;
            h = WINDOW_WIDTH/w*h;
            self.introduceView.frame = CGRectMake(0, 0, WINDOW_WIDTH, h);
            self.introduceView.image = image;
            [self.collectionView reloadData];
        }
    }];
    [self addHeader];
    [self addFooter];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataSourceArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WPNewExchangeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.dataSourceArray[indexPath.row];
    return cell;
}



#pragma mark - loadDatas

-(void)addHeader{
    __weak WPCollectionBaseViewController * weakSelf = self;
    self.collectionView.mj_header = [WPAnimationHeader headerWithRefreshingBlock:^{
        if (_gcid.length>0) {
            [weakSelf loadNewClassificationDatas];
        }else{
            [weakSelf loadNewActivityADatas];
        }
    }];
    [self.collectionView.mj_header beginRefreshing];
}

-(void)addFooter{
    __weak WPCollectionBaseViewController * weakSelf = self;
    self.collectionView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        if (_gcid.length>0) {
            [weakSelf loadMoreClassificationDatas];
        }else{
            [weakSelf loadMoreActivityDatas];
        }
    }];
    [weakSelf.collectionView.mj_footer beginRefreshing];
}

#pragma mark - 获取活动商品数据
-(void)loadNewActivityADatas{
    if (!_tpid) {
        return;
    }
    __weak WPCollectionBaseViewController * weakSelf = self;
    _dataSourceArray = [NSMutableArray arrayWithCapacity:3];
    [WPNetWorking createPostRequestMenagerWithUrlString:QtQueryTypegdlist params:@{@"tpid":_tpid} datas:^(NSDictionary *responseObject) {
        [self.collectionView.mj_header endRefreshing];
        if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject[@"flag"] intValue] == 1) {
            NSMutableArray *goods;
            if ([(goods=responseObject[@"list"]) isKindOfClass:[NSArray class]]) {
                [weakSelf.dataSourceArray removeAllObjects];
                for (NSDictionary * item in goods) {
                    WPNewExchangeModel * model = [WPNewExchangeModel mj_objectWithKeyValues:item];
                    if (model.listimg.count>0) {
                        model.url = model.listimg[0][@"url"];
                    }
                    [weakSelf.dataSourceArray addObject:model];
                }
                [weakSelf.collectionView reloadData];
            }
        }
    }failureBlock:^{
        [weakSelf.collectionView.mj_header endRefreshing];
    }];

}
-(void)loadMoreActivityDatas{
    
}
#pragma mark - 获取搜索分类数据
-(void)loadNewClassificationDatas{
    __weak WPCollectionBaseViewController * weakSelf = self;
    _dataSourceArray = [NSMutableArray arrayWithCapacity:3];
    [WPNetWorking createPostRequestMenagerWithUrlString:weakSelf.url params:@{@"currPage":@(1),@"gcid":_gcid} datas:^(NSDictionary *responseObject) {
        NSArray * goods = [responseObject objectForKey:@"goodsFb"];
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

-(void)loadMoreClassificationDatas{
    __weak WPCollectionBaseViewController * weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:weakSelf.url params:@{@"currPage":@(_page),@"gcid":_gcid} datas:^(NSDictionary *responseObject) {
        NSArray * goods = [responseObject objectForKey:@"goodsFb"];
        if ([[responseObject valueForKey:@"goods"] isKindOfClass:[NSNull class]]) {
            [weakSelf.collectionView.mj_footer endRefreshing];
            return;
        }
        _dataSourceArray = [NSMutableArray arrayWithCapacity:3];
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

#pragma mark - CollectionDelegate && CollectionDataSource

//返回每个区头大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(WINDOW_WIDTH, self.introduceView.height + 10);
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

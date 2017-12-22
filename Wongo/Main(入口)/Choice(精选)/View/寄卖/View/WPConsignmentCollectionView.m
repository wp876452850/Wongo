//
//  WPConsignmentCollectionView.m
//  Wongo
//
//  Created by  WanGao on 2017/10/25.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPConsignmentCollectionView.h"
#import "WPConsignmentHeaderView.h"
#import "WPBrandCollectionViewCell.h"
#import "WPConsignmentGoodsCollectionViewCell.h"
#import "WPConsignmentModel.h"
#define HeaderView_Height WINDOW_WIDTH*0.4 + (180*WINDOW_WIDTH/375)+40


@interface WPConsignmentCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSInteger _currPage;
}

@property (nonatomic,strong)WPConsignmentHeaderView * headerView;

@property (nonatomic,strong)NSMutableArray * dataSourceArray;

@end
@implementation WPConsignmentCollectionView

static NSString * const brandCell = @"brandCell";
static NSString * const goodsCell = @"goodsCell";
static NSString * const ConsignmentCell = @"ConsignmentCell";

-(WPConsignmentHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[WPConsignmentHeaderView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, HeaderView_Height)];
    }
    return _headerView;
}

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self registerNib:[UINib nibWithNibName:@"WPBrandCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:brandCell];
        [self registerNib:[UINib nibWithNibName:@"WPConsignmentGoodsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ConsignmentCell];
        
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"rementuijian"];
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"pinpaituijian"];
        self.backgroundColor = WongoGrayColor;
        self.delegate   = self;
        self.dataSource = self;
        [self addSubview:self.headerView];
    }
    return self;
}

-(void)setUrl:(NSString *)url{
    _url = url;
    [self addHeaderLoad];
}
-(void)addHeaderLoad{
    __block typeof(self) weakSelf = self;
    self.mj_header = [WPAnimationHeader headerWithRefreshingBlock:^{
        [weakSelf loadDatas];
    }];
    [self.mj_header beginRefreshing];
}
-(void)loadDatas{
    _currPage = 1;
    _dataSourceArray = [NSMutableArray arrayWithCapacity:3];
    __block typeof(self) weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:self.url params:@{@"currPage":@(_currPage)} datas:^(NSDictionary *responseObject) {
        NSArray * array = responseObject[@"LogRm"];
        for (int i = 0; i<array.count; i++) {
            WPConsignmentModel * model = [WPConsignmentModel mj_objectWithKeyValues:array[i]];
            [weakSelf.dataSourceArray addObject:model];
        }
        [weakSelf reloadData];
        [weakSelf.mj_header endRefreshing];
    }];
    
}
//区数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//item 数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    if (section == 0) {
//        return 8;
//    }
    return _dataSourceArray.count;
}

//
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        WPBrandCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:brandCell forIndexPath:indexPath];
//        return cell;
//    }
    WPConsignmentGoodsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ConsignmentCell forIndexPath:indexPath];
    cell.model = self.dataSourceArray[indexPath.row];
    return cell;
}

//
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

//每个单元格返回的大小
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath{
//    if (indexPath.section == 0) {
//        return CGSizeMake((WINDOW_WIDTH - 3)/4, WINDOW_WIDTH/4+10);
//    }
    return CGSizeMake((WINDOW_WIDTH)/2 - 0.5, WINDOW_WIDTH/2+70);
}

//返回每个区头大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    if (section == 1) {
//        return CGSizeMake(WINDOW_WIDTH, 47);
//    }
    return CGSizeMake(WINDOW_WIDTH, HeaderView_Height + 47);
}

//设置区头
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterViewID" forIndexPath:indexPath];
    }
    UICollectionReusableView * reusableView =  nil;
    if (indexPath.section == 0) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"rementuijian" forIndexPath:indexPath];
        [reusableView removeAllSubviews];
    }
    else{
        reusableView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"pinpaituijian" forIndexPath:indexPath];
        [reusableView removeAllSubviews];
    }
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, HeaderView_Height+6, WINDOW_WIDTH, 40)];
    title.centerX = WINDOW_WIDTH/2;
    if (indexPath.section == 0) {
        title.text = @"热门寄卖推荐";
        }
    else{
        title.text = @"热门寄卖推荐";
        title.y = 5;
    }
    title.backgroundColor = WhiteColor;
    title.font = [UIFont boldSystemFontOfSize:17.f];
    title.textColor = TitleBlackColor;
    title.textAlignment = NSTextAlignmentCenter;
    [reusableView addSubview:title];
    [reusableView.layer addSublayer:[WPBezierPath drowLineWithMoveToPoint:CGPointMake(WINDOW_WIDTH - 60, title.centerY) moveForPoint:CGPointMake(WINDOW_WIDTH - 90, title.centerY) lineColor:TitleBlackColor]];
    [reusableView.layer addSublayer:[WPBezierPath drowLineWithMoveToPoint:CGPointMake(60, title.centerY) moveForPoint:CGPointMake(90, title.centerY) lineColor:TitleBlackColor]];
    return reusableView;
}
@end

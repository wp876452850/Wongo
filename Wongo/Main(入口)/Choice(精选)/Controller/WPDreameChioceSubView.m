//
//  WPDreameChioceSubView.m
//  Wongo
//
//  Created by rexsu on 2017/5/11.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPDreameChioceSubView.h"
#import "SDCycleScrollView.h"
#import "WPDreamingMainGoodsModel.h"
#import "WPDreamingDirectoryViewController.h"
#import "LYDreamSubjectCell.h"


#define ReusableView_Height 40

@interface WPDreameChioceSubView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)NSMutableArray * dataSourceArray;

@property (nonatomic,strong)SDCycleScrollView * cycleScrollView;

@property (nonatomic,strong)NSMutableArray * itemsHeight;

@end
@implementation WPDreameChioceSubView

-(SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
#warning 有后台记得改
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:RollPlayFrame imageNamesGroup:@[@"5.jpg",@"6.jpg",@"7.jpg",@"8.jpg"]];
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"loadimage"];
    }
    return _cycleScrollView;
}

-(NSMutableArray *)itemsHeight{
    if (!_itemsHeight) {
        _itemsHeight = [NSMutableArray arrayWithCapacity:3];
    }
    return _itemsHeight;
}
-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout cellClass:(Class)cellClass{
    if (self = [super initWithFrame:frame collectionViewLayout:layout])
    {
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([LYDreamSubjectCell class]) bundle:nil] forCellWithReuseIdentifier:@"DREAMSUBJECTCELLID"];
        self.backgroundColor = WhiteColor;
        self.delegate   = self;
        self.dataSource = self;
        [self addSubview:self.cycleScrollView];
        [self addHeaderWithUrl:QuerySub];
    }
    return self;
}

#pragma makr - delegate,dataSource

//每个单元格返回的大小
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath{
    if (indexPath.row+1>self.itemsHeight.count) {
        CGFloat height = WINDOW_WIDTH*0.66;
        [self.itemsHeight addObject:[NSString stringWithFormat:@"%f",height]];
    }
    return CGSizeMake(WINDOW_WIDTH, [self.itemsHeight[indexPath.row] floatValue]);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LYDreamSubjectCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DREAMSUBJECTCELLID" forIndexPath:indexPath];
    WPDreamingMainGoodsModel * model = self.dataSourceArray[indexPath.row];
    cell.model = model;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //FIXME:功能暂未开放
//    [[self findViewController:self]showAlertNotOpenedWithBlock:nil];
//    return;
//    [self goDreameingDirectory:indexPath.row];
    
}
//返回每个区头大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        return CGSizeMake(WINDOW_WIDTH,self.cycleScrollView.height);
    }
    return CGSizeZero;
}

#pragma mark - LoadData

-(void)addHeaderWithUrl:(NSString *)url{
    __weak WPDreameChioceSubView * weakSelf = self;
    self.mj_header = [WPAnimationHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewDatasWithUrl:url];
    }];
    [self.mj_header beginRefreshing];
}

-(void)loadNewDatasWithUrl:(NSString *)url{
    __weak WPDreameChioceSubView * weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:url params:@{} datas:^(NSDictionary *responseObject) {
        NSArray * array = [responseObject objectForKey:@"listSub"];
        _dataSourceArray = [NSMutableArray arrayWithCapacity:3];
        for (int i = 0; i < array.count; i++) {
            WPDreamingMainGoodsModel * model = [WPDreamingMainGoodsModel mj_objectWithKeyValues:array[i]];
            [_dataSourceArray addObject:model];
        }
        // 刷新表格
        [weakSelf reloadData];
        // 隐藏当前的上拉刷新控件
        [weakSelf.mj_header endRefreshing];
    } failureBlock:^{
        [weakSelf.mj_header endRefreshing];
    }];
}

#pragma mark - buttonClick
//前往专题
-(void)goDreameingDirectory:(NSInteger) sender{
    WPDreamingMainGoodsModel * model = self.dataSourceArray[sender];
    WPDreamingDirectoryViewController * vc = [[WPDreamingDirectoryViewController alloc]initWithSubid:model.subid subName:model.contents];
    [[self findViewController:self].navigationController pushViewControllerAndHideBottomBar:vc animated:YES];
}
@end

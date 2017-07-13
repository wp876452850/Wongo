//
//  WPSearchGoodsChildController.m
//  Wongo
//
//  Created by rexsu on 2017/2/21.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPSearchGoodsChildController.h"
#import "WPSearchGoodsModel.h"
#import "WPSearchGoodsCollectionViewCell.h"
#import "WPExchangeViewController.h"

@interface WPSearchGoodsChildController ()
@property (nonatomic,strong)NSMutableArray * dataSource;
@property (nonatomic,strong)NSString * keyWord;
@property (nonatomic,strong)NSString * type;
@end

@implementation WPSearchGoodsChildController

static NSString * const reuseIdentifier = @"Cell";

-(instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout Options:(NSDictionary *)options{
    if (self = [super initWithCollectionViewLayout:layout]) {
        _keyWord = [options objectForKey:@"keyWord"];
        _type = [options objectForKey:@"type"];
        [self loadDatas];
    }
    return self;
}
-(void)loadDatas{
    __weak WPSearchGoodsChildController * weakSelf = self;
    self.dataSource = [NSMutableArray arrayWithCapacity:3];
    
    if ([_type isEqualToString:@"交换"]) {
        [WPNetWorking createPostRequestMenagerWithUrlString:ExchangeHomePageUrl params:@{@"currPage":@(1),@"gname":_keyWord} datas:^(NSDictionary *responseObject) {
            NSArray * goods = [responseObject objectForKey:@"goods"];
            for (int i = 0; i<goods.count; i++) {
                WPSearchGoodsModel * model = [WPSearchGoodsModel mj_objectWithKeyValues:goods[i]];
                [weakSelf.dataSource addObject:model];
            }
            [weakSelf.collectionView reloadData];
        }];

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WPSearchGoodsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = WhiteColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark <UICollectionViewDataSource>



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WPSearchGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(WINDOW_WIDTH -15, 104);
}
#pragma mark <UICollectionViewDelegate>
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

// 4、单独定制每行item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WPSearchGoodsModel * model = self.dataSource[indexPath.row];
    WPExchangeViewController * vc = [WPExchangeViewController createExchangeGoodsWithUrlString:ExchangeDetailGoodsUrl params:@{@"gid":model.gid} fromOrder:NO];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

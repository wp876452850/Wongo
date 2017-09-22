//
//  WPGoodsRecommendedTableViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/9/20.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPGoodsRecommendedTableViewCell.h"
#import "WPNewExchangeCollectionViewCell.h"
#import "WPNewExchangeModel.h"
#define Cell_Height (WINDOW_WIDTH*0.5+60)
@interface WPGoodsRecommendedTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong)UICollectionView * collectionView;

@end

@implementation WPGoodsRecommendedTableViewCell
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        //设置横向
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //设置最小行间距
        layout.minimumLineSpacing = 10.f;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 5, WINDOW_WIDTH, Cell_Height) collectionViewLayout:layout];
        _collectionView.backgroundColor = WhiteColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"WPNewExchangeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.collectionView];
}

-(void)setRow:(NSInteger)row{
    _row = row;
}
-(void)setDataSouceArray:(NSArray *)dataSouceArray{
    _dataSouceArray = dataSouceArray;
    NSMutableArray * datas = [NSMutableArray arrayWithArray:dataSouceArray];
    for (int i = 0; i<_row*2; i++) {
        [datas removeObjectAtIndex:0];
    }
    _dataSouceArray = datas;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WPNewExchangeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = _dataSouceArray[indexPath.row];
    return cell;
}
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    return CGSizeMake((WINDOW_WIDTH) * 0.5 - 7.5, Cell_Height);
}


@end

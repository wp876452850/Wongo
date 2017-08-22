//
//  WPRecommendationView.m
//  Wongo
//
//  Created by  WanGao on 2017/8/21.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPRecommendationView.h"

@interface WPRecommendationView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)NSMutableArray * dataSourceArray;
@property (nonatomic,strong)UICollectionView * collection;
@end
@implementation WPRecommendationView
-(UICollectionView *)collection{
    if (!_collection) {
        UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(WINDOW_WIDTH/2 -15, 110);
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _collection = [[UICollectionView alloc]initWithFrame:self.frame collectionViewLayout:layout];
        _collection.delegate = self ;
        _collection.dataSource = self;
        [_collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collection.backgroundColor = [UIColor whiteColor];
    }
    return _collection;
}
-(instancetype)initWithFrame:(CGRect)frame dataSourceArray:(NSMutableArray *)dataSourceArray;{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collection];
    }
    return self;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 50;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = ColorWithRGB(121, 3, 54);
    return cell;
}
@end

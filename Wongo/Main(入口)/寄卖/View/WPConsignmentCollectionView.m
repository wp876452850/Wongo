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
#define HeaderView_Height WINDOW_WIDTH*0.4 + (180*WINDOW_WIDTH/375)+40



@interface WPConsignmentCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)WPConsignmentHeaderView * headerView;

@end
@implementation WPConsignmentCollectionView

static NSString * const brandCell = @"brandCell";
static NSString * const goodsCell = @"goodsCell";

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
        self.backgroundColor = WongoGrayColor;
        self.delegate   = self;
        self.dataSource = self;
        [self addSubview:self.headerView];
    }
    return self;
}

-(void)loadDatas{
    
}
//区数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
//item 数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 8;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WPBrandCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:brandCell forIndexPath:indexPath];

    return cell;
}

//
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(HeaderView_Height + 3, 0, 0, 0);
}

//返回每个区头大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout{
    
    return CGSizeMake(0, 0);
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
    if (indexPath.section == 0) {
        return CGSizeMake((WINDOW_WIDTH -3)/4, WINDOW_WIDTH/4);
    }
    return CGSizeMake((WINDOW_WIDTH)/2 - 0.5, WINDOW_WIDTH/2+90);
}

@end

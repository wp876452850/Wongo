//
//  WPSelectAlterView.m
//  Wongo
//
//  Created by rexsu on 2017/3/27.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPSelectAlterView.h"
#import "WPSelectAlterViewCell.h"
#import "WPGoodsClassModel.h"

#define SelectItemSize CGSizeMake(WINDOW_WIDTH / 5, 40)
#define ReusableView_Height 44
static SelectAlertBlock _selectAlertBlock;
@interface WPSelectAlterView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    CGFloat max_y;
    
}
//数据
@property (nonatomic,strong)NSMutableArray  * dataSource;
//数据id
@property (nonatomic,strong)NSMutableArray  * gcids;

@property (nonatomic,strong)UIView          * view;

@property (nonatomic,strong)UIView          * selectView;
//选择器
@property (nonatomic,strong)UICollectionView * collectionView;
//记录最后点击的单元格
@property (nonatomic,strong)NSIndexPath * indexPath;

@property (nonatomic,strong)NSString * selectCategoryName;;
@end
@implementation WPSelectAlterView
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize                     = SelectItemSize;
        layout.minimumLineSpacing           = 0;
        layout.minimumInteritemSpacing      = 0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.selectView.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor     = WhiteColor;
        //注册
        [_collectionView registerNib:[UINib nibWithNibName:@"WPSelectAlterViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
        _collectionView.delegate            = self;
        _collectionView.dataSource          = self;
    }
    return _collectionView;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.view                   = [[UIView alloc]initWithFrame:frame];
        self.view.backgroundColor   = [UIColor blackColor];
        self.view.alpha             = 0;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer
                                         alloc]initWithTarget:self action:@selector(tap)];
        [self.view addGestureRecognizer:tap];
        [self addSubview:self.view];
        self.selectView             = [[UIView alloc]initWithFrame:frame];
        self.selectView
        .backgroundColor            = WhiteColor;
        self.selectView.frame       = CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT/2);
        self.selectView.bottom      = WINDOW_HEIGHT;
        [self addSubview:self.selectView];
        self.dataSource             = [NSMutableArray arrayWithCapacity:3];
        self.gcids                  = [NSMutableArray arrayWithCapacity:3];
        self.selectView.y           = WINDOW_HEIGHT;
        
        [self.selectView addSubview:self.collectionView];
        [UIView animateWithDuration:0.3 animations:^{
            self.selectView.y  = WINDOW_HEIGHT - self.selectView.height;
            self.view.alpha    = 0.5;
        }];
    }
    return self;
}
//自定义分类
+(instancetype)createArraySelectAlterWithFrame:(CGRect)frame array:(NSArray *)array block:(SelectAlertBlock)block selectedCategoryName:(NSString *)selectedCategoryName{
    WPSelectAlterView * selectAlterView = [[WPSelectAlterView alloc]initWithFrame:frame];
    selectAlterView.selectCategoryName = selectedCategoryName;
    [selectAlterView.dataSource addObject:array];
    [selectAlterView.gcids addObject:array];
    _selectAlertBlock = block;
    return selectAlterView;
}
//服务器定义分类
+(instancetype)createURLSelectAlterWithFrame:(CGRect)frame urlString:(NSString *)urlString params:(NSDictionary *)params block:(SelectAlertBlock)block selectedCategoryName:(NSString *)selectedCategoryName
{
    WPSelectAlterView * selectAlterView = [[WPSelectAlterView alloc]initWithFrame:frame];
    selectAlterView.selectCategoryName = selectedCategoryName;
    [selectAlterView loadDatasWithUrlString:urlString params:params];
    _selectAlertBlock = block;
    return selectAlterView;
}
//请求分类数据
-(void)loadDatasWithUrlString:(NSString *)urlString params:(NSDictionary *)params{
    self.dataSource = [NSMutableArray arrayWithCapacity:3];
    [WPNetWorking createPostRequestMenagerWithUrlString:urlString params:params datas:^(NSDictionary *responseObject) {
        
        if (responseObject) {
            NSArray * dataSource = [responseObject objectForKey:@"goodClass"];
            for ( int i = 0;  i < dataSource.count; i++) {
                WPGoodsClassModel * model = [WPGoodsClassModel mj_objectWithKeyValues:dataSource[i]];
                [_dataSource addObject:model];
            }
                [_collectionView reloadData];
        }
    }];
}

-(void)selectAlert:(UIButton *)sender{
    if (_selectAlertBlock) {
        _selectAlertBlock(self.dataSource[sender.tag],self.gcids[sender.tag]);
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.selectView.y  = WINDOW_HEIGHT;
        self.view.alpha    = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


-(void)tap{
    [UIView animateWithDuration:0.3 animations:^{
        self.selectView.y  = WINDOW_HEIGHT;
        self.view.alpha    = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Collection
//返回区头大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(WINDOW_WIDTH, ReusableView_Height);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (_dataSource.count>0) {
        if (![self.dataSource[0] isKindOfClass:[WPGoodsClassModel class]]){
            return 1;
        }
    }    
    return _dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_dataSource.count <= 0) {
        return 0;
    }
    if ([self.dataSource[section] isKindOfClass:[WPGoodsClassModel class]]){
        WPGoodsClassModel * model = _dataSource[section];
        return model.listgc.count;
    }
    NSArray * array = _dataSource[section];
    return array.count;
}

//返回区头
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView * reusableView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
    [reusableView removeAllSubviews];

    if ([self.dataSource[indexPath.section] isKindOfClass:[WPGoodsClassModel class]]){
                WPGoodsClassModel * model = _dataSource[indexPath.section];
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        title.center = CGPointMake(WINDOW_WIDTH/2, ReusableView_Height/2);
        title.text = model.cname;
        title.font = [UIFont systemFontOfSize:19];
        title.textColor = AllBorderColor;
        title.textAlignment = NSTextAlignmentCenter;
        [reusableView.layer addSublayer:[WPBezierPath drowLineWithMoveToPoint:CGPointMake(50, title.centerY) moveForPoint:CGPointMake(title.left - 20, title.centerY) lineColor:AllBorderColor]];
        [reusableView addSubview:title];
        [reusableView.layer addSublayer:[WPBezierPath drowLineWithMoveToPoint:CGPointMake(WINDOW_WIDTH - 50, title.centerY) moveForPoint:CGPointMake(title.right + 20, title.centerY) lineColor:AllBorderColor]];
        
    }
    return reusableView;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WPSelectAlterViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (![self.dataSource[indexPath.section] isKindOfClass:[WPGoodsClassModel class]]) {
        [cell.selectButton setTitle:_dataSource[indexPath.section][indexPath.row] forState:UIControlStateNormal];
    }else{
        WPGoodsClassModel * model = self.dataSource[indexPath.section];
        [cell.selectButton setTitle:model.listgc[indexPath.row][@"gcname"] forState:UIControlStateNormal];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.indexPath) {
        WPSelectAlterViewCell * oldCell = (WPSelectAlterViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        oldCell.selectButton.selected = !oldCell.selectButton.selected;
    }
    WPSelectAlterViewCell * cell = (WPSelectAlterViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selectButton.selected = !cell.selectButton.selected;
    if (![self.dataSource[indexPath.section] isKindOfClass:[WPGoodsClassModel class]]){
        _selectAlertBlock(_dataSource[indexPath.section][indexPath.row],_gcids[indexPath.section][indexPath.row]);
    }else{
        WPGoodsClassModel * model = self.dataSource[indexPath.section];
        _selectAlertBlock(model.listgc[indexPath.row][@"gcname"],model.listgc[indexPath.row][@"gcid"]);
    }
    [self tap];
}

@end

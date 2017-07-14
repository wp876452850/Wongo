//
//  WPSelectAlterView.m
//  Wongo
//
//  Created by rexsu on 2017/3/27.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPSelectAlterView.h"
#import "WPSelectAlterViewCell.h"

#define SelectItemSize CGSizeMake(WINDOW_WIDTH / 5, 40)
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
        [_collectionView registerNib:[UINib nibWithNibName:@"WPSelectAlterViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
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

+(instancetype)createArraySelectAlterWithFrame:(CGRect)frame array:(NSArray *)array block:(SelectAlertBlock)block selectedCategoryName:(NSString *)selectedCategoryName{
    WPSelectAlterView * selectAlterView = [[WPSelectAlterView alloc]initWithFrame:frame];
    selectAlterView.selectCategoryName = selectedCategoryName;
    [selectAlterView.dataSource addObject:array];
    [selectAlterView.gcids addObject:array];
    _selectAlertBlock = block;
    return selectAlterView;
}

+(instancetype)createURLSelectAlterWithFrame:(CGRect)frame urlString:(NSString *)urlString params:(NSDictionary *)params block:(SelectAlertBlock)block selectedCategoryName:(NSString *)selectedCategoryName
{
    WPSelectAlterView * selectAlterView = [[WPSelectAlterView alloc]initWithFrame:frame];
    selectAlterView.selectCategoryName = selectedCategoryName;
    [selectAlterView loadDatasWithUrlString:urlString params:params];
    _selectAlertBlock = block;
    return selectAlterView;
}

-(void)loadDatasWithUrlString:(NSString *)urlString params:(NSDictionary *)params{
    [WPNetWorking createPostRequestMenagerWithUrlString:urlString params:params datas:^(NSDictionary *responseObject) {
        NSArray * dataSource = [responseObject objectForKey:@"goodClass"];
        for (NSDictionary *dic in dataSource) {
            [_gcids addObject:[dic objectForKey:@"gcid"]];
            [_dataSource addObject:[dic objectForKey:@"gcname"]];
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
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_dataSource.count <= 0) {
        return 0;
    }
    NSArray * array = _dataSource[section];
    return array.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WPSelectAlterViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.selectButton setTitle:_dataSource[indexPath.section][indexPath.row] forState:UIControlStateNormal];
    return cell;
}

//section大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = {WINDOW_WIDTH, 30};
    return size;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.indexPath) {
        WPSelectAlterViewCell * oldCell = (WPSelectAlterViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        oldCell.selectButton.selected = !oldCell.selectButton.selected;
    }
    WPSelectAlterViewCell * cell = (WPSelectAlterViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selectButton.selected = !cell.selectButton.selected;
    _selectAlertBlock(_dataSource[indexPath.section][indexPath.row],_gcids[indexPath.section][indexPath.row]);
    [self tap];
}



@end

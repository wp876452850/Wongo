//
//  WPSearchGuideViewController.m
//  Wongo
//
//  Created by rexsu on 2017/2/13.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPSearchGuideViewController.h"
#import "WPSearchGoodsCell.h"
#import "WPSearchNavigationBar.h"
#import "WPSearchResultsViewController.h"
#import "WPTypeChooseMune.h"
#import "WPSearchUserViewController.h"
#define ItemSize CGSizeMake(80, 100)

@interface WPSearchGuideViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)NSMutableArray * dataSource;
@property (nonatomic,strong)NSMutableArray * titles;
@property (nonatomic,strong)SMVerticalSegmentedControl * segmentedControl;
@property (nonatomic,strong)UICollectionView * collectionView;
@property (nonatomic,strong)WPSearchNavigationBar * searchNavigationBar;
@property (nonatomic,strong)WPTypeChooseMune * typeChooseMenu;
@property (nonatomic,strong)NSString * type;
@end
static NSString * const itemCell = @"ItemCell";
static NSString * const reusable = @"Reusable";
@implementation WPSearchGuideViewController

-(WPTypeChooseMune *)typeChooseMenu{
    if (!_typeChooseMenu) {
        _typeChooseMenu = [[WPTypeChooseMune alloc]initWithFrame:CGRectMake(40, 68, 70, 85)];
        [_typeChooseMenu changeTypeWithBlock:^(NSString *type) {
            [self.searchNavigationBar.choose setTitle:type forState:UIControlStateNormal];
            _type = type;
        }];
    }
    return _typeChooseMenu;
}

-(WPSearchNavigationBar *)searchNavigationBar{
    if (!_searchNavigationBar) {
        _searchNavigationBar = [[WPSearchNavigationBar alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 64)];
        _searchNavigationBar.openFirstResponder = YES;
        [_searchNavigationBar.back addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
        //go按钮
        [_searchNavigationBar actionSearchWithBlock:^(NSString *type, NSString *keyWord) {
            if (keyWord.length == 0) {
                [self showAlertWithAlertTitle:@"提示" message:@"关键字不能为空" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
                return;
            }
            //界面跳转
            UIViewController * vc;
            
            if ([type isEqualToString:@"造梦"]||[type isEqualToString:@"交换"]) {
                vc = [[WPSearchResultsViewController alloc]initWithKeyWord:keyWord];
            }
            else if([type isEqualToString:@"用户"]){
                vc = [[WPSearchUserViewController alloc]initWithKeyWord:keyWord];
            }
            [self.view endEditing:YES];
            if (vc) {
                [self.navigationController pushViewController:vc animated:YES];
            }
           
        }];
        //choose按钮
        [_searchNavigationBar chooseButtonClickWithBlock:^{
            switch (self.typeChooseMenu.isOpen) {
                case NO:
                    [self.typeChooseMenu menuOpen];
                    break;
                    
                default:
                    [self.typeChooseMenu menuClose];
                    break;
            }
        }];
    }
    return _searchNavigationBar;
}

-(SMVerticalSegmentedControl *)segmentedControl{
    if (!_segmentedControl) {
        _segmentedControl = [[SMVerticalSegmentedControl alloc]initWithSectionTitles:self.titles];
        _segmentedControl.selectionStyle = SMVerticalSegmentedControlSelectionStyleBox;
        _segmentedControl.frame = CGRectMake(0, 64, 80, WINDOW_HEIGHT - 64);
        _segmentedControl.selectedTextColor = SelfOrangeColor;
        _segmentedControl.selectionBoxBorderWidth = 0;
        _segmentedControl.textFont = [UIFont systemFontOfSize:15];
        _segmentedControl.textAlignment = NSTextAlignmentCenter;
        //设置默认的选中按钮
        _segmentedControl.selectedSegmentIndex = 0;
        
        [self.segmentedControl indexChangeBlock:^(NSInteger index) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
            
            [_collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
           
        }];
    }
    return _segmentedControl;
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = ItemSize;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(self.segmentedControl.width, 64, WINDOW_WIDTH - self.segmentedControl.width, WINDOW_HEIGHT - 64) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"WPSearchGoodsCell" bundle:nil] forCellWithReuseIdentifier:itemCell];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reusable];
    }
    return _collectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self loadDataWithtype:@"造梦"];
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.searchNavigationBar];
    [self.view addSubview:self.typeChooseMenu];
    
}

-(void)loadDataWithtype:(NSString * )type{
    
    self.dataSource = [NSMutableArray arrayWithCapacity:10];
    self.titles = [NSMutableArray arrayWithCapacity:3];
/*
    [WPNetWorking createPostRequestMenagerWithUrlString:QueryClassoneUrl params:nil datas:^(NSDictionary *responseObject) {
        NSArray * listc = [responseObject objectForKey:@"listc"];
        for (int i = 0; i<listc.count; i++) {
            NSDictionary * dic = listc[i];
            WPSearchModel * model = [WPSearchModel mj_objectWithKeyValues:dic];
            [_titles addObject:model.cname];
            NSMutableArray * array = [NSMutableArray arrayWithCapacity:3];
            for (int j = 0; j<model.listgc.count; j++) {
                NSDictionary * dic1 = listc[j];
                WPSearchModel * subModel = [WPSearchModel mj_objectWithKeyValues:dic1];
                [array addObject:subModel];
            }
            [_dataSource addObject:array];
        }
    }];
*/
    for (int i = 0; i < 10; i++) {
        NSString * title = [NSString stringWithFormat:@"分栏--%d",i];
        [self.titles addObject:title];
        
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:3];
        for (int j = 0 ; j < arc4random()%5+10; j++) {
            WPSearchModel * model = [[WPSearchModel alloc]init];
            model.url = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487133044008&di=7218cee2cc89392ecda5da88165d7ed8&imgtype=0&src=http%3A%2F%2Ff.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Fd058ccbf6c81800a1499200eb33533fa828b47b5.jpg";
            model.gcname = [NSString stringWithFormat:@"商品--%d",j];
            [array addObject:model];
        }
        [self.dataSource addObject:array];
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray * array = self.dataSource[section];
    return array.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WPSearchGoodsCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemCell forIndexPath:indexPath];
    NSArray * array = self.dataSource[indexPath.section];
    WPSearchModel * model = array[indexPath.row];
    cell.model = model;
    return cell;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    //创建头视图
    UICollectionReusableView *headerCell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reusable forIndexPath:indexPath];
    
    //添加label
    UILabel *label = [[UILabel alloc]initWithFrame:headerCell.bounds];
    
    label.text = self.titles[indexPath.section];
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.backgroundColor = [UIColor whiteColor];
    
    //添加到头视图上
    [headerCell addSubview:label];
    
    return headerCell;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return _titles.count;
}
//距离四周的距离
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
//设置头视图的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(WINDOW_WIDTH, 40);
}

#pragma mark - ScrollViewDelegate
//单元格结束移动时调用
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    NSArray *indexArr = [_collectionView indexPathsForVisibleItems];
    
    NSIndexPath *lastIndexPath = [indexArr firstObject];
    
    self.segmentedControl.selectedSegmentIndex = lastIndexPath.section;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
//当单元格减速时调用
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSArray *indexArr = [_collectionView indexPathsForVisibleItems];
    
    NSIndexPath *lastIndexPath = [indexArr firstObject];
    
    self.segmentedControl.selectedSegmentIndex = lastIndexPath.section;
}

@end

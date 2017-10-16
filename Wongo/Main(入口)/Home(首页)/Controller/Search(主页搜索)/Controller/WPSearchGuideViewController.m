//
//  WPSearchGuideViewController.m
//  Wongo
//
//  Created by rexsu on 2017/2/13.
//  Copyright © 2017年 Winny. All rights reserved.
//  搜索首页

#import "WPSearchGuideViewController.h"
#import "WPGoodsClassModel.h"
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
        __block WPSearchGuideViewController * weakSelf = self;
        [_typeChooseMenu changeTypeWithBlock:^(NSString *type) {
            [self.searchNavigationBar.choose setTitle:type forState:UIControlStateNormal];
            weakSelf.type = type;
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
            
            if ([type isEqualToString:@"造梦"]||[type isEqualToString:@"商品"]) {
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
        /*[_searchNavigationBar chooseButtonClickWithBlock:^{
            switch (self.typeChooseMenu.isOpen) {
                case NO:
                    [self.typeChooseMenu menuOpen];
                    break;
                    
                default:
                    [self.typeChooseMenu menuClose];
                    break;
            }
        }];*/
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
        
        __block WPSearchGuideViewController * weakSelf = self;
        [self.segmentedControl indexChangeBlock:^(NSInteger index) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
            
            [weakSelf.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
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
    [self.view addSubview:self.searchNavigationBar];
    [self.view addSubview:self.typeChooseMenu];
}

-(void)loadDataWithtype:(NSString * )type{
    
    self.dataSource = [NSMutableArray arrayWithCapacity:10];
    self.titles = [NSMutableArray arrayWithCapacity:3];
    //交换分类
    __block WPSearchGuideViewController * weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:QueryClassoneUrl params:nil datas:^(NSDictionary *responseObject) {
        NSArray * listc = responseObject[@"listc"];
        for (int i = 0; i < listc.count; i++) {
            WPGoodsClassModel * model = [WPGoodsClassModel mj_objectWithKeyValues:listc[i]];
            [weakSelf.dataSource addObject:model];
            [weakSelf.titles addObject:model.cname];
        }
        [weakSelf.view addSubview:weakSelf.segmentedControl];
        [weakSelf.view addSubview:weakSelf.collectionView];
        [weakSelf.view bringSubviewToFront:weakSelf.typeChooseMenu];
        [weakSelf.collectionView reloadData];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    WPGoodsClassModel * model = self.dataSource[section];
    return model.listgc.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WPSearchGoodsCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemCell forIndexPath:indexPath];
    WPGoodsClassModel * model = self.dataSource[indexPath.section];
    cell.model = [WPSearchModel mj_objectWithKeyValues:model.listgc[indexPath.row]];
    return cell;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    //创建头视图
    UICollectionReusableView *headerCell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reusable forIndexPath:indexPath];
    
    //添加label
    UILabel *label = [[UILabel alloc]initWithFrame:headerCell.bounds];
    label.width = 150;
    label.centerX = headerCell.width/2;
    label.text = self.titles[indexPath.section];
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.backgroundColor = [UIColor whiteColor];
    
    //添加到头视图上
    [headerCell addSubview:label];
    
    [headerCell.layer addSublayer:[WPBezierPath drowLineWithMoveToPoint:CGPointMake(15,label.centerY ) moveForPoint:CGPointMake(label.left- 15, label.centerY) lineColor:ColorWithRGB(24, 24, 24)]];
    [headerCell.layer addSublayer:[WPBezierPath drowLineWithMoveToPoint:CGPointMake(label.right + 15, label.centerY) moveForPoint:CGPointMake(headerCell.width - 15, label.centerY) lineColor:ColorWithRGB(24, 24, 24)]];
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

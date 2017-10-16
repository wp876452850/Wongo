//
//  WPSearchResultsViewController.m
//  Wongo
//
//  Created by rexsu on 2017/2/16.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPSearchResultsViewController.h"
#import "WPSearchGoodsModel.h"
#import "WPSearchGoodsChildController.h"
#import "WPMenuScrollView.h"
#import "WPSearchNavigationBar.h"
#import "WPTypeChooseMune.h"
#import "WPSearchUserViewController.h"
#import "WPNewExchangeCollectionViewCell.h"
#import "WPNewExchangeModel.h"

@interface WPSearchResultsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSInteger _page;
}
@property (nonatomic,strong)NSString * type;
@property (nonatomic,strong)NSString * keyWord;
@property (nonatomic,strong)NSMutableArray * dataSource;
@property (nonatomic,strong)UICollectionView * collectionView;
@property (nonatomic,strong)WPSearchNavigationBar * searchNavigationBar;
@property (nonatomic,strong)WPTypeChooseMune * typeChooseMenu;
@end

@implementation WPSearchResultsViewController

static NSString * const reuseIdentifier = @"Cell";
static NSString * contentOffset = @"contentOffset";


-(WPTypeChooseMune *)typeChooseMenu{
    if (!_typeChooseMenu) {
        _typeChooseMenu = [[WPTypeChooseMune alloc]initWithFrame:CGRectMake(40, 68, 70, 85)];
        [_typeChooseMenu changeTypeWithBlock:^(NSString *type) {
            [self.searchNavigationBar.choose setTitle:type forState:UIControlStateNormal];
        }];
    }
    return _typeChooseMenu;
}

-(WPSearchNavigationBar *)searchNavigationBar{
    if (!_searchNavigationBar) {
        _searchNavigationBar = [[WPSearchNavigationBar alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 64)];
        [_searchNavigationBar.back addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
        //go按钮
        [_searchNavigationBar actionSearchWithBlock:^(NSString *type, NSString *keyWord) {
            if (keyWord.length == 0) {
                [self showAlertWithAlertTitle:@"提示" message:@"关键字不能为空" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
                return;
            }
            //界面跳转
            UIViewController * vc;
            
            if ([type isEqualToString:@"商品"]) {
                vc = [[WPSearchResultsViewController alloc]initWithKeyWord:keyWord];
            }
            else if([type isEqualToString:@"用户"]){
                vc = [[WPSearchUserViewController alloc]initWithKeyWord:keyWord];
            }
            [self.view endEditing:YES];
            if(vc){
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }];
        //choose按钮
       /* [_searchNavigationBar chooseButtonClickWithBlock:^{
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

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];;
        //设置横向滑动
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT-64) collectionViewLayout:layout];
        _collectionView.backgroundColor = WhiteColor;
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"WPNewExchangeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];

    }
    return _collectionView;
}


-(instancetype)initWithKeyWord:(NSString *)keyWord{
    self = [super init];
    if (self) {
        _keyWord = keyWord;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.searchNavigationBar];
    [self.view addSubview:self.typeChooseMenu];
    [self addHeader];
}

#pragma mark - loadDatas

-(void)addHeader{
    __block WPSearchResultsViewController * weakSelf = self;
    self.collectionView.mj_header = [WPAnimationHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewDatas];
    }];
    [self.collectionView.mj_header beginRefreshing];
}
-(void)addFooter{
    __weak WPSearchResultsViewController * weakSelf = self;
    self.collectionView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreDatas];
    }];
    [self.collectionView.mj_footer beginRefreshing];
}

-(void)loadNewDatas{
    __block WPSearchResultsViewController * weakSelf = self;
    weakSelf.dataSource = [NSMutableArray arrayWithCapacity:3];
    [WPNetWorking createPostRequestMenagerWithUrlString:ExchangeHomePageUrl params:@{@"gname":_keyWord,@"currPage":@"1"} datas:^(NSDictionary *responseObject) {
        [weakSelf.collectionView.mj_header endRefreshing];
        NSArray * goods = [responseObject objectForKey:@"goods"];
        weakSelf.dataSource= [NSMutableArray arrayWithCapacity:3];
        for (NSDictionary * item in goods) {
            WPNewExchangeModel * model = [WPNewExchangeModel mj_objectWithKeyValues:item];
            [weakSelf.dataSource addObject:model];
        }
        _page++;
        [weakSelf.collectionView reloadData];

    } failureBlock:^{
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
}

-(void)loadMoreDatas{
    __block WPSearchResultsViewController * weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:QueryGoodsGname params:@{@"gname":_keyWord} datas:^(NSDictionary *responseObject) {
        [weakSelf.collectionView.mj_header endRefreshing];
        NSArray * goods = [responseObject objectForKey:@"goods"];
        weakSelf.dataSource= [NSMutableArray arrayWithCapacity:3];
        for (NSDictionary * item in goods) {
            WPNewExchangeModel * model = [WPNewExchangeModel mj_objectWithKeyValues:item];
            [weakSelf.dataSource addObject:model];
        }
        _page++;
        [weakSelf.collectionView reloadData];
    } failureBlock:^{
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
}

#pragma mark - collectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WPNewExchangeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.model = _dataSource[indexPath.row];
    return cell;
}
//每个单元格返回的大小
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath{
    return CGSizeMake((WINDOW_WIDTH) * 0.5 - 7.5, WINDOW_WIDTH*0.5+60);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
@end

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

#define Titles @[@"商品列表"]

@interface WPSearchResultsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)NSString * type;
@property (nonatomic,strong)NSString * keyWord;
@property (nonatomic,strong)NSMutableArray * dataSource;
@property (nonatomic,strong)UICollectionView * collectionView;
@property (nonatomic,strong)WPMenuScrollView * menuScrollView;
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

-(WPMenuScrollView *)menuScrollView{
    if (!_menuScrollView) {
        _menuScrollView = [[WPMenuScrollView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, 60) withOptions:@{@"titles":Titles,@"width":@(80),@"height":@(40)}];
        NSKeyValueObservingOptions options  =   NSKeyValueObservingOptionOld|
        NSKeyValueObservingOptionNew;        
        [self.collectionView addObserver:self forKeyPath:contentOffset options:options context:nil];
        
        _menuScrollView.collectionView = self.collectionView;
        _menuScrollView.height += 20;
        _menuScrollView.y -= 20;
    }
    return _menuScrollView;
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];;
        //设置横向滑动
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.itemSize = CGSizeMake(WINDOW_WIDTH, WINDOW_HEIGHT-49);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT) collectionViewLayout:layout];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor redColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        for (int i = 0; i < Titles.count; i++) {
            [self createSubCollectionViewWithPage:i];
        }
        
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
-(void)loadDatas{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.menuScrollView];
    [self.view addSubview:self.searchNavigationBar];
    [self.view addSubview:self.typeChooseMenu];
}


-(void)createSubCollectionViewWithPage:(NSInteger)page{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(10,5,0,5);
    layout.itemSize = CGSizeMake(WINDOW_WIDTH/2 - 10, 267);
    WPSearchGoodsChildController * childVC;
    
    NSDictionary * options = @{@"keyWord":_keyWord,@"type":Titles[page]};
    
    childVC = [[WPSearchGoodsChildController alloc] initWithCollectionViewLayout:layout Options:options];
    
    childVC.view.frame = CGRectMake(0, 0, _collectionView.bounds.size.width,_collectionView.bounds.size.height);
    
    //[self addFooterWithCollection:childVC];
    //[self addHeaderWithCollection:childVC];
    [self addChildViewController:childVC];
    
}

#pragma mark - collectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
     return Titles.count;
}
         
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
         UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
         [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
         WPSearchGoodsChildController *childVC = self.childViewControllers[indexPath.row];
         [cell.contentView addSubview:childVC.view];
        
         return cell;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
}
-(void)dealloc{
    [_menuScrollView.collectionView removeObserver:self forKeyPath:contentOffset context:nil];
}
@end

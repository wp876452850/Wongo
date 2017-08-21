//
//  WPChoiceSubCollectionView.m
//  Wongo
//
//  Created by rexsu on 2017/4/12.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPChoiceSubCollectionView.h"
#import "WPNewExchangeModel.h"
#import "SDCycleScrollView.h"
#import "WPNewExchangeCollectionViewCell.h"
#import "WPClassificationTableView.h"
#import "WPCustomButton.h"
#import "WPNewDreamingNotSignUpTableViewCell.h"

#define HeaderMenuHeight 104
#define Cell_Height (WINDOW_WIDTH*0.5+60)
#define SectionMenuTitles @[@"综合推荐 ",@"人气优先 ",@"分类 "]

@interface WPChoiceSubCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSInteger _page;
    /**一级分类*/
    NSString * _primaryClassification;
    /**二级分类*/
    NSString * _secondaryClassification;
    
    WPCustomButton * _memoryButton;
    
    BOOL _isOpen;
}
@property (nonatomic,strong)SDCycleScrollView * cycleScrollView;

@property (nonatomic,strong)NSMutableArray * rollPlayImages;

@property (nonatomic,strong)NSMutableArray * dataSourceArray;
//二级菜单
@property (nonatomic,strong)UIView * menuView;

@property (nonatomic,strong)NSString * url;
//分类弹出菜单
@property (nonatomic,strong)WPClassificationTableView * classificationTableView;
@end
@implementation WPChoiceSubCollectionView
static NSString * const reuseIdentifier = @"Cell";


-(SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
#warning 有后台记得改
        //_cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:RollPlayFrame imageURLStringsGroup:self.rollPlayImages];
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_WIDTH - 110) imageNamesGroup:@[@"5.jpg",@"6.jpg",@"7.jpg",@"8.jpg"]];
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
    }
    return _cycleScrollView;
}
-(WPClassificationTableView *)classificationTableView{
    if (!_classificationTableView) {
        _classificationTableView  = [[WPClassificationTableView alloc]initWithFrame:CGRectMake(0, _menuView.bottom, WINDOW_WIDTH, 200) style:UITableViewStylePlain];
        
    }
    return _classificationTableView;
}
-(UIView *)menuView{
    if (!_menuView) {
        _menuView = [[UIView alloc]initWithFrame:CGRectMake(0, _cycleScrollView.bottom, WINDOW_WIDTH, 50)];
        _menuView.backgroundColor = WhiteColor;
        for (int i = 0; i < 3; i++) {
            WPCustomButton * menuButton = [[WPCustomButton  alloc]initWithFrame:CGRectMake(i*WINDOW_WIDTH/3+i, 5, WINDOW_WIDTH/3-1, 30)];
            if (i == 0) {
                menuButton.selected = YES;
                _memoryButton = menuButton;
                
            }
            if (i<2) {
                CAShapeLayer * layer = [WPBezierPath drowLineWithMoveToPoint:CGPointMake(menuButton.right, menuButton.y+2.5) moveForPoint:CGPointMake(menuButton.right, menuButton.bottom-2.5) lineColor:ColorWithRGB(210, 210, 210)];
                [_menuView.layer addSublayer:layer];
            }
            
            menuButton.tag = i;
            [menuButton setBackgroundColor:[UIColor clearColor]];
            menuButton.titleLabel.font = [UIFont systemFontOfSize:15];
            menuButton.normalTitleColor = ColorWithRGB(100, 100, 100);
            menuButton.selectedTitleColor = WongoBlueColor;
            NSString * title = SectionMenuTitles[i];
            
            menuButton.normalAttrobuteString = [WPAttributedString attributedStringWithAttributedString:[[NSAttributedString alloc]initWithString:title] insertImage:[UIImage imageNamed:@""] atIndex:title.length imageBounds:CGRectMake(0, 0, 9, 9)];
            
            menuButton.selectedAttrobuteString = [WPAttributedString attributedStringWithAttributedString:[[NSAttributedString alloc]initWithString:title] insertImage:[UIImage imageNamed:@"exchangesectionmuneselect"] atIndex:title.length imageBounds:CGRectMake(0, 0, 9, 9)];
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(menuClick:)];
            [menuButton addGestureRecognizer:tap];
            [_menuView addSubview: menuButton];
        }
    }
    return _menuView;
}

-(void)menuClick:(UITapGestureRecognizer *)tap{
     WPCustomButton * sender = (WPCustomButton *)tap.view;
    if (_memoryButton == tap.view) {
        return;
    }
    if (tap.view.tag != 2) {
        _memoryButton.selected = !_memoryButton.selected;
        sender.selected = !sender.selected;
        _memoryButton = sender;
        if (_isOpen) {
            [self.classificationTableView menuClose];
            _isOpen = !_isOpen;
            
        }
    }else{
        if (!_isOpen) {
            [self.classificationTableView menuOpen];
            __block WPCustomButton * button = sender;
            [self.classificationTableView getClassificationStringWithBlock:^(NSString *classification, NSInteger index) {
                
            }];
            
        }else{
            [self.classificationTableView menuClose];
        }
        _isOpen = !_isOpen;
    }
    
}

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout loadDatasUrl:(NSString *)url{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) 
    {
        [self registerNib:[UINib nibWithNibName:@"WPNewExchangeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
        
        _page = 1;
        self.backgroundColor = WhiteColor;
        self.delegate   = self;
        self.dataSource = self;
        self.url = url;
        [self addSubview:self.cycleScrollView];
        [self addSubview:self.menuView];
        [self addSubview:self.classificationTableView];
        [self addFooter];
        [self addHeader];
    }
    return self;
}
-(void)setRollPlayImages:(NSMutableArray *)rollPlayImages{
    _rollPlayImages = rollPlayImages;
    _cycleScrollView.imageURLStringsGroup = _rollPlayImages;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSourceArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WPNewExchangeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.model = _dataSourceArray[indexPath.row];
    return cell;
}

//每个单元格返回的大小
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath{
     return CGSizeMake((WINDOW_WIDTH) * 0.5 - 7.5, Cell_Height);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

//设置边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(WINDOW_WIDTH - 40, 5, 10, 5);
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    if (_isOpen) {
        [self.classificationTableView menuClose];
        _isOpen = !_isOpen;
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_isOpen) {
        [self.classificationTableView menuClose];
        _isOpen = !_isOpen;
    }
}

#pragma mark - loadDatas

-(void)addHeader{
    __weak WPChoiceSubCollectionView * weakSelf = self;
    self.mj_header = [WPAnimationHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewDatas];
    }];
    [self.mj_header beginRefreshing];
}

-(void)addFooter{
    __weak WPChoiceSubCollectionView * weakSelf = self;
    self.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreDatas];
    }];
    [self.mj_footer beginRefreshing];
}

-(void)loadNewDatas{
    __weak WPChoiceSubCollectionView * weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:self.url params:@{@"currPage":@(1),@"pubtime":@"sb"} datas:^(NSDictionary *responseObject) {
        NSArray * goods = [responseObject objectForKey:@"goods"];
        _dataSourceArray = [NSMutableArray arrayWithCapacity:3];
        for (NSDictionary * item in goods) {
            WPNewExchangeModel * model = [WPNewExchangeModel mj_objectWithKeyValues:item];
            [_dataSourceArray addObject:model];
        }
        // 刷新表格
        [weakSelf reloadData];
        // 隐藏当前的上拉刷新控件
        [weakSelf.mj_header endRefreshing];
        _page++;
    } failureBlock:^{
        [weakSelf.mj_header endRefreshing];
    }];
}

-(void)loadMoreDatas{
    __weak WPChoiceSubCollectionView * weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:self.url params:@{@"currPage":@(_page),@"pubtime":@"sb"} datas:^(NSDictionary *responseObject) {
        NSArray * goods = [responseObject objectForKey:@"goods"];
        if ([[responseObject valueForKey:@"goods"] isKindOfClass:[NSNull class]]) {
            [weakSelf.mj_footer endRefreshing];
            return;
        }
        for (NSDictionary * item in goods) {
            WPNewExchangeModel * model = [WPNewExchangeModel mj_objectWithKeyValues:item];
            [_dataSourceArray addObject:model];
        }
        // 刷新表格
        [weakSelf reloadData];
        // 隐藏当前的上拉刷新控件
        [weakSelf.mj_footer endRefreshing];
        _page++;
    } failureBlock:^{
        [weakSelf.mj_footer endRefreshing];
    }];
}

@end

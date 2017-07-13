//
//  WPDreamingDirectoryViewController.m
//  Wongo
//
//  Created by rexsu on 2017/5/11.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPDreamingDirectoryViewController.h"
#import "WPMyNavigationBar.h"
#import "WPDreamingDirectoryTableViewCell.h"
#import "WPDreamingDirectoryModel.h"
#import "WPDreamingDirectoryHeadView.h"
#import "WPDreamingDirectoryHeaderViewModel.h"
#import "WPDreamingDetailViewController.h"

@interface WPDreamingDirectoryViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _page;
}

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)WPMyNavigationBar * nav;

@property (nonatomic,strong)NSMutableArray * dataSourceArray;

@property (nonatomic,strong)WPDreamingDirectoryHeadView * headView;

@end

@implementation WPDreamingDirectoryViewController

-(WPDreamingDirectoryHeadView *)headView{
    if (!_headView) {
        _headView = [[WPDreamingDirectoryHeadView alloc]init];
        _headView.subid = self.subid;
    }
    return _headView;
}
-(WPMyNavigationBar *)nav{
    if (!_nav) {
        _nav = [[WPMyNavigationBar alloc]init];
        _nav.alpha = 0;
        _nav.title.text = self.title;
        [_nav.leftButton addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nav;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate     = self;
        _tableView.dataSource   = self;
        _tableView.rowHeight    = 140;
        [_tableView registerNib:[UINib nibWithNibName:@"WPDreamingDirectoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        _tableView.tableHeaderView = self.headView;
        [_tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return _tableView;
}

-(instancetype)initWithSubid:(NSString *)subid subName:(NSString *)subName{
    if (self = [super init]) {
        self.subid = subid;
        self.title = subName;
    }
    return self;
}
- (void)dealloc{
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.nav];
    [self navigationLeftPop];
    [self loadDatas];
//    [self addHeader];
//    [self addFooter];
}
- (NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}
#pragma mark - loadDatas
-(void)loadDatas{
    
    [WPNetWorking createPostRequestMenagerWithUrlString:QueryPlanRul params:@{@"subid":_subid} datas:^(NSDictionary *responseObject) {
        NSArray * array = [responseObject objectForKey:@"listm"];
        _headView.model = [WPDreamingDirectoryHeaderViewModel mj_objectWithKeyValues:responseObject];
        for (int i = 0;  i < array.count; i++) {
            WPDreamingDirectoryModel * model = [WPDreamingDirectoryModel mj_objectWithKeyValues:array[i]];
            [_dataSourceArray addObject:model];
        }
        [self.tableView reloadData];
    }];
}
////下拉刷新
//-(void)addHeader{
//    
//    __weak WPDreamingDirectoryViewController * weakSelf = self;
//    self.tableView.mj_header = [WPAnimationHeader headerWithRefreshingBlock:^{
//        [weakSelf loadNewDatas];
//    }];
//    [self.tableView.mj_header beginRefreshing];
//}
////上拉刷新
//-(void)addFooter{
//    __weak WPDreamingDirectoryViewController * weakSelf = self;
//    self.tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
//        [weakSelf loadMoreDatas];
//    }];
//    [self.tableView.mj_footer beginRefreshing];
//}
//
//-(void)loadNewDatas{
//    _page = 1;
//    __weak WPDreamingDirectoryViewController * weakSelf = self;
//    [WPNetWorking createPostRequestMenagerWithUrlString:QueryPlanRul params:@{@"currPage":@(_page)} datas:^(NSDictionary *responseObject) {
//        _headView.model = [WPDreamingDirectoryHeaderViewModel mj_objectWithKeyValues:responseObject];
//        // 刷新表格
//        [weakSelf.tableView reloadData];
//        // 隐藏当前的上拉刷新控件
//        [weakSelf.tableView.mj_header endRefreshing];
//        _page ++;
//        
//    } failureBlock:^{
//        [weakSelf.tableView.mj_header endRefreshing];
//    }];
//}
//
//-(void)loadMoreDatas{
//    __weak WPDreamingDirectoryViewController * weakSelf = self;
//    [WPNetWorking createPostRequestMenagerWithUrlString:QueryPlanRul params:@{@"currPage":@(_page)} datas:^(NSDictionary *responseObject) {
//
//        // 刷新表格
//        [weakSelf.tableView reloadData];
//        // 隐藏当前的上拉刷新控件
//        [weakSelf.tableView.mj_footer endRefreshing];
//        _page++;
//    } failureBlock:^{
//        [weakSelf.tableView.mj_footer endRefreshing];
//    }];
//}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    UITableView * tableView = (UITableView *)object;
    if (tableView != self.tableView || ![keyPath isEqualToString:@"contentOffset"]) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    CGFloat collectionViewOffsetY = tableView.contentOffset.y;
    
    CGFloat headerViewMaxY = CGRectGetHeight(self.headView.frame);
    
    UIColor * color = ColorWithRGB(0, 0, 0);
    
    CGFloat alpha = MIN(1,collectionViewOffsetY/(headerViewMaxY-164));
    
    self.nav.backgroundColor = color;
    self.nav.alpha = alpha;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WPDreamingDirectoryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.dataSourceArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WPDreamingDirectoryModel *model = self.dataSourceArray[indexPath.row];
    WPDreamingDetailViewController *vc = [WPDreamingDetailViewController createDreamingDetailWithPlid:model.plid subid:self.subid];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

//
//  WPChioceSubTableView.m
//  Wongo
//
//  Created by rexsu on 2017/4/12.
//  Copyright ©  2017年 Winny. All rights reserved.
//

#import "WPChioceSubTableView.h"
#import "SDCycleScrollView.h"
#import "WPChoiceTableViewCell.h"
#import "WPExchangeModel.h"
#import "WPExchangeViewController.h"
#import "WPClassificationView.h"

@interface WPChioceSubTableView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _page;
}
@property (nonatomic,strong)SDCycleScrollView   * cycleScrollView;

@property (nonatomic,strong)NSMutableArray      * dataSourceArray;

@property (nonatomic,strong)NSString            * url;

@property (nonatomic,strong)WPClassificationView * classificationView;

/**置顶按钮*/
@property (nonatomic,strong)UIButton * toTopButton;
@end
@implementation WPChioceSubTableView
static NSString * const reuseIdentifier = @"Cell";


-(UIButton *)toTopButton{
    if (!_toTopButton) {
        _toTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _toTopButton.backgroundColor = SelfOrangeColor;
        _toTopButton.frame = CGRectMake(WINDOW_WIDTH - 80, WINDOW_HEIGHT - 120, 30, 30);
        [_toTopButton addTarget:self action:@selector(toTop) forControlEvents:UIControlEventTouchUpInside];
        UICollectionViewCell * cell = (UICollectionViewCell *)self.superview.superview;
//        [cell addSubview:_toTopButton];
    }
    return _toTopButton;
}
-(WPClassificationView *)classificationView{
    if (!_classificationView) {
        _classificationView = [[WPClassificationView alloc]initWithFrame:CGRectMake(0, RollPlayFrame.size.height, WINDOW_WIDTH, 30)];
        [_classificationView classificationSelectWithBlock:^(NSString *classification) {
            
        }];
        [_classificationView classificationAddForExchangeSubCollectionViewWithBlock:^(UIView *view) {
            [self addSubview:view];
        }];
    }
    return _classificationView;
}
-(SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
#warning 有后台记得改
        //_cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:RollPlayFrame imageURLStringsGroup:self.rollPlayImages];
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:RollPlayFrame imageNamesGroup:@[@"5.jpg",@"6.jpg",@"7.jpg",@"8.jpg"]];
    }
    return _cycleScrollView;
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style cellClass:(Class)cellClass loadDatasUrl:(NSString *)url
{
    self.url = url;
    if (self = [super initWithFrame:frame style:style]) {
        
        if (cellClass == [WPChoiceTableViewCell class]) {
            [self registerNib:[UINib nibWithNibName:@"WPChoiceTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
        }
        self.rowHeight              = WINDOW_WIDTH * 0.6 + 40;
        self.delegate               = self;
        self.dataSource             = self;
        UIView * view               = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, self.cycleScrollView.height + 10  )];
        view.backgroundColor        = WhiteColor;
        [view addSubview:self.cycleScrollView];
//        [view addSubview:self.classificationView];
        self.tableHeaderView        = view;
        self.separatorStyle         = UITableViewCellSeparatorStyleNone;
        [self addHeaderWithUrl:url];
        [self addFooterWithUrl:url];
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WPChoiceTableViewCell * cell        = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.selectionStyle                 = UITableViewCellSelectionStyleNone;
    cell.model                          = self.dataSourceArray[indexPath.row];
    return cell;
}


#pragma makr -delegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat contentOffset_y = scrollView.contentOffset.y;
    if (contentOffset_y <= 64) {
        self.toTopButton.hidden = YES;
    }else{
        self.toTopButton.hidden = NO;
        self.toTopButton.alpha  = (contentOffset_y - 64)*0.01f;
    }
}

#pragma mark -刷新加载
//下拉刷新
-(void)addHeaderWithUrl:(NSString *)url{
    
    __weak WPChioceSubTableView * weakSelf = self;
    self.mj_header = [WPAnimationHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewDatasWithUrl:url];
    }];
    [self.mj_header beginRefreshing];
}
//上拉刷新
-(void)addFooterWithUrl:(NSString *)url{
    __weak WPChioceSubTableView * weakSelf = self;
    self.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreDatasWithUrl:url];
    }];
    [self.mj_footer beginRefreshing];
}
-(void)loadNewDatasWithUrl:(NSString *)url{
    _page = 1;
    __weak WPChioceSubTableView * weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:url params:@{@"currPage":@(_page)} datas:^(NSDictionary *responseObject) {
        NSArray * goods = [responseObject objectForKey:@"goods"];
        _dataSourceArray = [NSMutableArray arrayWithCapacity:3];
        for (NSDictionary * item in goods) {
            WPExchangeModel * model = [WPExchangeModel mj_objectWithKeyValues:item];
            [_dataSourceArray addObject:model];
        }
        // 刷新表格
        [weakSelf reloadData];
        // 隐藏当前的上拉刷新控件
        [weakSelf.mj_header endRefreshing];
        _page ++;
        
    } failureBlock:^{
        [weakSelf.mj_header endRefreshing];
    }];
}

-(void)loadMoreDatasWithUrl:(NSString *)url{
    __weak WPChioceSubTableView * weakSelf = self;

    [WPNetWorking createPostRequestMenagerWithUrlString:url params:@{@"currPage":@(_page)} datas:^(NSDictionary *responseObject) {
        if ([[responseObject valueForKey:@"goods"] isKindOfClass:[NSNull class]]) {
            [weakSelf.mj_footer endRefreshing];
            return;
        }
        NSArray * goods = [responseObject objectForKey:@"goods"];
        for (NSDictionary * item in goods) {
            WPExchangeModel * model = [WPExchangeModel mj_objectWithKeyValues:item];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WPExchangeModel * model         = self.dataSourceArray[indexPath.row];
    WPExchangeViewController * vc   = [WPExchangeViewController createExchangeGoodsWithUrlString:ExchangeDetailGoodsUrl params:@{@"gid":model.gid} fromOrder:NO];
    UINavigationController * nav    = [self getNavigationControllerOfCurrentView];
    [nav pushViewControllerAndHideBottomBar:vc animated:YES];
}

-(void)toTop{
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
@end

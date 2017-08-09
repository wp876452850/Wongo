//
//  WPChoiceSubTableView.m
//  Wongo
//
//  Created by  WanGao on 2017/8/9.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPChoiceSubTableView.h"
#import "WPDreamingMainGoodsModel.h"
#import "WPNewDreamingTableViewCell.h"
#import "WPNewDreamingChoiceHeaderView.h"

@interface WPChoiceSubTableView ()<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property (nonatomic,strong)NSMutableArray * dataSourceArray;

@property (nonatomic,strong)SDCycleScrollView * cycleScrollView;

@property (nonatomic,strong)NSMutableArray * itemsHeight;

@property (nonatomic,strong)NSString * url;

@property (nonatomic,strong)WPNewDreamingChoiceHeaderView * headerView;
@end
@implementation WPChoiceSubTableView


#pragma mark - loadDatas

#pragma mark - LoadData
-(WPNewDreamingChoiceHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[WPNewDreamingChoiceHeaderView alloc]initWithPostersImages:@[@""]];
    }
    return _headerView;
}
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style url:(NSString *)url{
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.url = url;
        self.rowHeight = 200;
        self.tableHeaderView = self.headerView;
        [self registerNib:[UINib nibWithNibName:@"WPNewDreamingTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    }
    return self;
}

#pragma mark - UITableViewDeletage && UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WPNewDreamingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}


#pragma mark - LoadDatas
-(void)addHeader{
    __weak WPChoiceSubTableView * weakSelf = self;
    self.mj_header = [WPAnimationHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewDatas];
    }];
    [self.mj_header beginRefreshing];
}

-(void)loadNewDatas{
    __weak WPChoiceSubTableView * weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:self.url params:@{} datas:^(NSDictionary *responseObject) {
        NSArray * array = [responseObject objectForKey:@"listSub"];
        _dataSourceArray = [NSMutableArray arrayWithCapacity:3];
        for (int i = 0; i < array.count; i++) {
            WPDreamingMainGoodsModel * model = [WPDreamingMainGoodsModel mj_objectWithKeyValues:array[i]];
            [_dataSourceArray addObject:model];
        }
        // 刷新表格
        [weakSelf reloadData];
        // 隐藏当前的上拉刷新控件
        [weakSelf.mj_header endRefreshing];
    } failureBlock:^{
        [weakSelf.mj_header endRefreshing];
    }];
}

@end

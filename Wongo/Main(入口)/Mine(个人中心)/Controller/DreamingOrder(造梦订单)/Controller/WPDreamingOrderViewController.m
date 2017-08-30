//
//  WPDreamingOrderViewController.m
//  Wongo
//
//  Created by rexsu on 2017/5/15.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPDreamingOrderViewController.h"
#import "WPMyOrderTableViewCell.h"
#import "WPMyNavigationBar.h"
#import "WPMyOrderModel.h"

@interface WPDreamingOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSMutableArray * dataSourceArray;

@property (nonatomic,strong)WPMyNavigationBar * nav;
@end

@implementation WPDreamingOrderViewController
-(WPMyNavigationBar *)nav{
    if (!_nav) {
        _nav = [[WPMyNavigationBar alloc]init];
        _nav.title.text = @"造梦订单";
        [_nav.leftButton addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nav;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"WPMyOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        _tableView.rowHeight = 200;
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationLeftPop];
    [self.view addSubview:self.nav];
    [self.view addSubview:self.tableView];
    [self loadDatas];
}
-(void)loadDatas{
    self.dataSourceArray = [NSMutableArray arrayWithCapacity:3];
    [WPNetWorking createPostRequestMenagerWithUrlString:QueryPlordersUrl params:@{@"uid":[self getSelfUid]} datas:^(NSDictionary *responseObject) {
        NSArray * listm = [responseObject objectForKey:@"listm"];
        
        for (int i = 0; i < listm.count; i++) {
            WPMyOrderModel * model = [WPMyOrderModel mj_objectWithKeyValues:listm[i]];
            [self.dataSourceArray addObject:model];
        }
        [_tableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WPMyOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.dataSourceArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPat{
    
}


@end

//
//  WPEnjoyViewController.m
//  Wongo
//
//  Created by rexsu on 2017/4/14.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPEnjoyViewController.h"
#import "WPMyNavigationBar.h"
#import "WPEnjoyGoodsTableViewCell.h"
#import "WPExchangeModel.h"

@interface WPEnjoyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)WPMyNavigationBar * nav;

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSMutableArray * dataSourceArray;
@end

@implementation WPEnjoyViewController

-(NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:3];
    }
    return _dataSourceArray;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT - 64) style:UITableViewStylePlain];
        _tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
        _tableView.delegate         = self;
        _tableView.dataSource       = self;
        _tableView.rowHeight        = 110.0f;
        [_tableView registerNib:[UINib nibWithNibName:@"WPEnjoyGoodsTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
        
    }
    return _tableView;
}
-(WPMyNavigationBar *)nav{
    if (!_nav) {
        _nav = [[WPMyNavigationBar alloc]init];
        _nav.title.text = @"我的收藏";
        [_nav.leftButton addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nav;
}

-(void)loadDatas{
    [WPNetWorking createPostRequestMenagerWithUrlString:QueryUserCollectionUrl params:@{@"uid":[self getSelfUid]} datas:^(NSDictionary *responseObject) {
        NSArray * list = responseObject[@"list"];
        for (int i = 0; i<list.count; i++) {
            WPExchangeModel * model = [WPExchangeModel mj_objectWithKeyValues:list[i]];
            model.url = list[i][@"listimg"][0][@"url"];
            [_dataSourceArray addObject:model];
        }
        [_tableView reloadData];
    }];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.nav];
    [self loadDatas];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WPEnjoyGoodsTableViewCell * cell    = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.model = self.dataSourceArray[indexPath.row];
    return cell;
}



@end

//
//  WPMyConsignmentViewController.m
//  Wongo
//
//  Created by  WanGao on 2017/11/13.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPMyConsignmentViewController.h"
#import "WPMyConsignmentTableViewCell.h"
#import "WPMyConsignmentModel.h"
@interface WPMyConsignmentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataSourceArray;

@end

@implementation WPMyConsignmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myNavItem.title = @"我的寄卖";
    [self loadDatas];
    self.view.backgroundColor = AllBorderColor;
    [self.view addSubview:self.tableView];
}

-(UITableView *)tableView
{
    if (!_tableView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT - 64) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 110.f;
        _tableView.backgroundColor = AllBorderColor;
        [_tableView registerNib:[UINib nibWithNibName:@"WPMyConsignmentTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];        
    }
    return _tableView;
}

-(void)loadDatas{
    self.dataSourceArray = [NSMutableArray arrayWithCapacity:3];
    __block typeof(self) weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:LogisticsUserquery params:@{@"uid":[self getSelfUid]} datas:^(NSDictionary *responseObject) {
        NSArray * listg = responseObject[@"listg"];
        for (int i = 0; i<listg.count; i++) {
            WPMyConsignmentModel * model = [WPMyConsignmentModel mj_objectWithKeyValues:listg[i]];
            [weakSelf.dataSourceArray addObject:model];
        }
        [weakSelf.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WPMyConsignmentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.dataSourceArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
@end

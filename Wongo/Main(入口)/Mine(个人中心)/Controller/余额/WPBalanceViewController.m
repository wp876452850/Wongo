//
//  WPBalanceViewController.m
//  Wongo
//
//  Created by  WanGao on 2017/11/30.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPBalanceViewController.h"
#import "WPMyTableViewCell.h"

#define CELL_ID @"cell"
#define Cell_title_array @[@"提现",@"充值"]
#define Cell_Icon_Array @[@"kiting",@"Pay"]

@interface WPBalanceViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)UIView * headerView;

@property (nonatomic,strong)UILabel * label;

@end

@implementation WPBalanceViewController

-(UILabel *)label{
    if (!_label) {
        _label =  [[UILabel alloc]initWithFrame:CGRectMake(20, _headerView.height-80, WINDOW_WIDTH, 80)];
        _label.textColor = WhiteColor;
        _label.font = [UIFont systemFontOfSize:75.f];
        [self.headerView addSubview:_label];
    }
    return _label;
}
-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 200)];
        _headerView.backgroundColor = self.myNavBar.barTintColor;
        [self loadData];
    }
    return _headerView;
}

-(UITableView *)tableView
{
    if (!_tableView ) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT - 49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[WPMyTableViewCell class] forCellReuseIdentifier:CELL_ID];
        _tableView.rowHeight = 60;
        _tableView.tableHeaderView = self.headerView;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myNavItem.title = @"余额";
    [self.view addSubview:self.tableView];
}

#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return Cell_Icon_Array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WPMyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.title.text = Cell_title_array[indexPath.row];
    cell.icon.image = [UIImage imageNamed:Cell_Icon_Array[indexPath.row]];
    [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
    return cell;
}

-(void)loadData{
    __block typeof(self)weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:UserGetUrl params:@{@"uid":[self getSelfUid]} datas:^(NSDictionary *responseObject) {
        weakSelf.label.text = [NSString stringWithFormat:@"%.2f",[responseObject[@"currency"] floatValue]];
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showMBProgressHUDWithTitle:@"功能暂未开通"];
}

@end

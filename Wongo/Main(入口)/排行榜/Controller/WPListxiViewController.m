//
//  WPListxiViewController.m
//  Wongo
//
//  Created by  WanGao on 2017/8/23.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPListxiViewController.h"
#import "WPListOtherTableViewCell.h"
#import "WPListFirstTableViewCell.h"
#import "WPStoreViewController.h"
#import "WPListModel.h"

@interface WPListxiViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSString * proid;
@property (nonatomic,strong)NSMutableArray * dataSourceArray;
@end

@implementation WPListxiViewController

-(instancetype)initWithSubid:(NSString *)proid{
    if (self = [super init]) {
        [self setupTableView];
        self.proid = proid;
        [self loadDatas];
    }
    return self;
}
-(instancetype)initWithDataSourceArray:(NSArray *)dataSourceArray{
    if (self = [super init]) {
        [self setupTableView];
        [self loadDatas];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.myNavItem.title = @"排行榜";
    [self loadDatas];
}

-(void)setDataSourceArray:(NSMutableArray *)dataSourceArray{
    _dataSourceArray = dataSourceArray;
    [self.tableView reloadData];
}
-(void)setupTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"WPListFirstTableViewCell" bundle:nil] forCellReuseIdentifier:@"first"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WPListOtherTableViewCell" bundle:nil] forCellReuseIdentifier:@"other"];
    [self.view addSubview:self.tableView];
}

-(void)loadDatas{
    __block typeof(self) weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:Queryuserorder params:nil datas:^(NSDictionary *responseObject) {
        if ([responseObject[@"flag"] integerValue] == 1) {
            weakSelf.dataSourceArray = responseObject[@"list"];
        }
        [weakSelf.tableView reloadData];
    } failureBlock:^{
        [weakSelf.tableView reloadData];
    }];

}


#pragma mark - TableViewDelegate && TableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 220;
    }
    return 70;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataSourceArray.count <= 3&&self.dataSourceArray.count>0) {
        return 1;
    }
    else if (self.dataSourceArray.count <= 0){
        return 0;
    }
    return self.dataSourceArray.count - 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        WPListFirstTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"first" forIndexPath:indexPath];
        cell.dataSourceArray = self.dataSourceArray;
        return cell;
    }
    WPListOtherTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"other" forIndexPath:indexPath];
    WPListModel * model = [WPListModel mj_objectWithKeyValues:self.dataSourceArray[indexPath.row + 2]];
    cell.model = model;
    return cell;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    WPStoreViewController * vc = [[WPStoreViewController alloc]initWithUid:@"1"];
//    [self.navigationController pushViewController:vc animated:YES];
//}

@end

//
//  WPFansViewController.m
//  Wongo
//
//  Created by rexsu on 2017/2/23.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPFansViewController.h"
#import "WPFansModel.h"
#import "WPMyNavigationBar.h"
#import "WPFansTableViewCell.h"

@interface WPFansViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * fansArray;
@property (nonatomic,strong)NSMutableArray * fansInformationArray;
@property (nonatomic,strong)WPMyNavigationBar * nav;
@end

@implementation WPFansViewController

-(NSMutableArray *)fansArray
{
    if (!_fansArray) {
        _fansArray = [NSMutableArray sharedFansArray];
    }
    return _fansArray;
}
-(WPMyNavigationBar *)nav{
    if (!_nav) {
        _nav = [[WPMyNavigationBar alloc]init];
        _nav.title.text = @"我的粉丝";
        [_nav.leftButton addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nav;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80.f;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"WPFansTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

-(void)loadDatas{
    typeof(self) weakSelf = self;
    self.fansInformationArray = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0; i < self.fansArray.count; i++) {
        [WPNetWorking createPostRequestMenagerWithUrlString:UserGetUrl params:@{@"uid":_fansArray[i]} datas:^(NSDictionary *responseObject) {
            [weakSelf.fansInformationArray addObject:[WPFansModel mj_objectWithKeyValues:responseObject]];
            if (i+1 >= weakSelf.fansArray.count) {
                [weakSelf.tableView reloadData];
            }
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDatas];
    self.view.backgroundColor = WhiteColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.nav];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fansInformationArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WPFansTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
    cell.model = self.fansInformationArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end

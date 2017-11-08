//
//  WPExchangeOrderViewController.m
//  Wongo
//
//  Created by rexsu on 2017/3/22.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPExchangeOrderViewController.h"
#import "WPExchangeOrderCell.h"
#import "WPMyNavigationBar.h"
#import "WPExchangeOrderModel.h"
#import "WPExchangeOrderGoodsModel.h"
#import "WPExchangeOrderModel.h"
#import "LYExchangeOrderDetailController.h"

@interface WPExchangeOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView         * tableView;

@property (nonatomic,strong)WPMyNavigationBar   * nav;

@property (nonatomic,strong)NSMutableArray      * dataSource;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@end

@implementation WPExchangeOrderViewController

-(WPMyNavigationBar *)nav{
    if(!_nav) {
        _nav = [[WPMyNavigationBar alloc]init];
        _nav.title.text = @"交换订单";
        [_nav.leftButton addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nav;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT - 64) style:UITableViewStylePlain];
        _tableView.separatorInset = UIEdgeInsetsMake(0, -20, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"WPExchangeOrderCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        _tableView.rowHeight = 295;
    }
    return _tableView;
}
- (UIActivityIndicatorView *)indicator{
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(WINDOW_WIDTH * 0.5 - 10, WINDOW_HEIGHT * 0.45, 20, 20)];
        _indicator.color = [UIColor  grayColor];
        _indicator.hidesWhenStopped = YES;
        
    }
    return _indicator;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 20)];
    label.centerY = self.view.centerY;
    label.font = [UIFont boldSystemFontOfSize:15.f];
    label.textColor = TitleGrayColor;
    label.text = @"您暂无交换订单";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    self.view.backgroundColor = WhiteColor;
    [self.view addSubview:self.indicator];
    [self.view addSubview:self.nav];
    [self loadDatas];
}
- (void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}
-(void)loadDatas{
    [self.indicator startAnimating];
    self.dataSource = [NSMutableArray arrayWithCapacity:3];
    __block typeof(self) weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:QueryOrderList params:@{@"uid":[self getSelfUid]} datas:^(NSDictionary *responseObject) {
        [self.indicator stopAnimating];
        NSArray * orderList = [responseObject objectForKey:@"orderList"];
        
        for (int i = 0; i < orderList.count ; i++ ) {
            NSDictionary * order = orderList[i];
            BOOL hasEsc = NO;
            BOOL hasSuc = NO;
            BOOL hasSss = NO;
            if ([[order allKeys] containsObject:@"esc"]) {
                hasEsc = YES;
            }
            if ([[order allKeys] containsObject:@"suc"]) {
                hasSuc = YES;
            }
            if ([[order allKeys] containsObject:@"sss"]) {
                hasSss = YES;
            }
            WPExchangeOrderModel * model = [WPExchangeOrderModel mj_objectWithKeyValues:order];
            model.hasEsc = hasEsc;
            model.hasSuc = hasSuc;
            model.hasSss = hasSss;
            model.myModel       = [WPExchangeOrderGoodsModel mj_objectWithKeyValues:[order objectForKey:@"mygood"]];
            model.partnerModel  = [WPExchangeOrderGoodsModel mj_objectWithKeyValues:[order objectForKey:@"yougood"]];
            [self.dataSource insertObject:model atIndex:0];
        }
        if (orderList.count>0) {
            if (!_tableView) {
                [weakSelf.view addSubview:weakSelf.tableView];
            }else{
                [weakSelf.tableView reloadData];
            }
        }
    } failureBlock:^{
        [self.indicator stopAnimating];
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WPExchangeOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     WPExchangeOrderModel *model = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:[LYExchangeOrderDetailController controllerWithModel:model] animated:YES];
}


@end

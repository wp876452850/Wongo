//
//  WPExchangeOrderDetailViewController.m
//  Wongo
//
//  Created by rexsu on 2017/4/19.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPExchangeOrderDetailViewController.h"
#import "WPMyNavigationBar.h"
#import "WPAddressSelectViewController.h"
#import "WPAddressSelectTableViewCell.h"
#import "WPOrderDetailGoodsCell.h"
#import "WPExchangeOrderModel.h"
#import "WPAddressSelectModel.h"
#import "WPExchangeOrderDetailModel.h"
#import "WPGoodsDetailViewController.h"

static NSString * const addressCell = @"AddressCell";
static NSString * const orderCell   = @"OrderCell";

@interface WPExchangeOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,assign)WPOrderDetailType orderType;

@property (nonatomic,strong)WPMyNavigationBar * nav;

@property (nonatomic,strong)WPExchangeOrderDetailModel * orderDetailModel;

@property (nonatomic,strong)UIButton * generateOrderButton;
@end

@implementation WPExchangeOrderDetailViewController

-(UIButton *)generateOrderButton{
    if (!_generateOrderButton) {
        _generateOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_generateOrderButton setTitle:@"确认申请订单" forState:UIControlStateNormal];
        _tableView.height -= 40;
    }
    return _generateOrderButton;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT - 64) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"WPAddressSelectTableViewCell" bundle:nil] forCellReuseIdentifier:addressCell];
        [_tableView registerNib:[UINib nibWithNibName:@"WPOrderDetailGoodsCell" bundle:nil] forCellReuseIdentifier:orderCell];
    }
    return _tableView;
}

-(WPMyNavigationBar *)nav{
    if (!_nav) {
        _nav = [[WPMyNavigationBar alloc]init];
        [_nav.leftButton addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
        if (self.orderType == OrderDetailSelect) {
            _nav.title.text = @"订单详情";
        }else{
            _nav.title.text = @"交换申请";
        }
    }
    return _nav;
}
-(instancetype)initWithOrderType:(WPOrderDetailType)orderType{
    if (self = [super init]) {
        self.orderType = orderType;
        [self.view addSubview:self.nav];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDatas];
    
}
-(void)loadDatas{
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        WPAddressSelectTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:addressCell forIndexPath:indexPath];
        
        return cell;
    }
    WPOrderDetailGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:orderCell forIndexPath:indexPath];
    if (indexPath.row == 1) {
        cell.whoGoods.text = @"我的物品";
    }
    else{
        cell.whoGoods.text = @"交换物品";
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (self.orderType == OrderDetailGenerate) {
            WPAddressSelectViewController * addressSelectVC = [[WPAddressSelectViewController alloc]init];
            [self.navigationController pushViewController:addressSelectVC animated:YES];
        }
        return;
    }
    WPGoodsDetailViewController * vc = [[WPGoodsDetailViewController alloc]initWithGid:_orderDetailModel.myGoodsModel.gid];
    [self.navigationController pushViewController:vc animated:YES];
    
}



@end

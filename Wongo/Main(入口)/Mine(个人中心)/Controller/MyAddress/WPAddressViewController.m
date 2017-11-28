//
//  WPAddressViewController.m
//  Wongo
//
//  Created by rexsu on 2016/12/15.
//  Copyright © 2016年 Wongo. All rights reserved.
//  收货地址

#import "WPAddressViewController.h"
#import "WPMyNavigationBar.h"
#import "WPAddressManageTableViewCell.h"
#import "WPAddressEditViewController.h"

@interface WPAddressViewController ()<UITableViewDelegate,UITableViewDataSource>



@property (nonatomic,strong)NSMutableArray  * dataSource;

@property (nonatomic,strong)NSIndexPath     * indexPath;

@property (nonatomic,strong)UIButton        * addAddress;

@end

@implementation WPAddressViewController

-(UIButton *)addAddress{
    if (!_addAddress) {
        _addAddress = [UIButton buttonWithType:UIButtonTypeCustom];
        _addAddress.frame = CGRectMake(5, WINDOW_HEIGHT- 40, WINDOW_WIDTH-10, 35);
        [_addAddress setTitle:@"新增地址" forState:UIControlStateNormal];
        _addAddress.backgroundColor = SelfThemeColor;
        [_addAddress addTarget:self action:@selector(goAddAddress) forControlEvents:UIControlEventTouchUpInside];
        _addAddress.layer.masksToBounds = YES;
        _addAddress.layer.cornerRadius  = 5;
    }
    return _addAddress;
}

-(void)goAddAddress{
    WPAddressEditViewController * vc = [[WPAddressEditViewController alloc]initWithStyle:WPAddressNewStyle dateSource:nil];
    vc.saveBlock = vc.saveBlock = ^(NSString *recipient,NSString *phone,NSString *address,NSString *detailAddress,NSInteger adid){
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}
-(UITableView *)tableView
{
    if (!_tableView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT - 104) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 110;
        [_tableView registerNib:[UINib nibWithNibName:@"WPAddressManageTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收货地址";
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 20)];
    label.centerY = self.view.centerY;
    label.font = [UIFont boldSystemFontOfSize:15.f];
    label.textColor = TitleGrayColor;
    label.text = @"您暂未添加收货地址";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    WPMyNavigationBar * customNav = [[WPMyNavigationBar alloc]init];
    customNav.title.text = self.title;
    [self.view addSubview:customNav];
    self.view.backgroundColor = [UIColor whiteColor];
    [customNav.leftButton addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"设为默认" forState:UIControlStateNormal];
    [customNav addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(customNav.leftButton.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.view addSubview:self.addAddress];
    [self loadDatas];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}
-(void)loadDatas{
    self.dataSource = [NSMutableArray arrayWithCapacity:3];
    __block typeof(self)weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:QueryAddressedUrl params:@{@"uid":[self getSelfUid]} datas:^(NSDictionary *responseObject){
        NSArray * lista = [responseObject objectForKey:@"lista"];
        for (NSDictionary * dic in lista) {
            WPAddressModel * model = [WPAddressModel mj_objectWithKeyValues:dic];
            if ([model.state integerValue] == 1) {
                [weakSelf.dataSource insertObject:model atIndex:0];
            }else{
                [weakSelf.dataSource addObject:model];
            }
        }
        if (lista.count>0) {
            if (!_tableView) {
                [weakSelf.view addSubview:weakSelf.tableView];
            }else{
                [weakSelf.tableView reloadData];
            }
        }
    }];
}
//设为默认地址按钮点击
-(void)rightBtnClick{
    if (_indexPath) {
        [self showAlertWithAlertTitle:@"提示" message:@"是否设为默认地址" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确认",@"取消"] block:^{
            WPAddressModel * model = self.dataSource[self.indexPath.row];
            [WPNetWorking createPostRequestMenagerWithUrlString:UpdAddressedStateUrl params:@{@"adid":@(model.adid)} datas:^(NSDictionary *responseObject) {
                
            }];
        }];
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WPAddressManageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell deleteAddressWithBlock:^{
        [self loadDatas];
    }];
    cell.select.selected = NO;
    if (indexPath == self.indexPath) {
        cell.select.selected = YES;
    }
    if (indexPath.row == 0 && !self.indexPath) {
        self.indexPath = indexPath;
        cell.select.selected = YES;
    }
    cell.model = self.dataSource[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WPAddressManageTableViewCell * cell = (WPAddressManageTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    WPAddressManageTableViewCell * oldCell = (WPAddressManageTableViewCell *)[tableView cellForRowAtIndexPath:self.indexPath];
    if (indexPath != self.indexPath) {
        cell.select.selected    = !cell.select.selected;
        oldCell.select.selected = !oldCell.select.selected;
        self.indexPath          = indexPath;
    }
}

@end

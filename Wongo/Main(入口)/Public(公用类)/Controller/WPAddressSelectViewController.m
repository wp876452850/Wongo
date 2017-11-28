//
//  WPAddressSelectViewController.m
//  Wongo
//
//  Created by rexsu on 2017/3/23.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPAddressSelectViewController.h"
#import "WPAddressSelectTableViewCell.h"
#import "WPAddressManageTableViewCell.h"
#import "WPMyNavigationBar.h"

#import "WPAddressEditViewController.h"


@interface WPAddressSelectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    SelectAddressBlock _block;
}

@property (nonatomic,strong)UITableView         * tableView;

@property (nonatomic,strong)NSMutableArray      * addressDataSource;

@property (nonatomic,strong)NSString            * uid;

@property (nonatomic,strong)UIButton            * resultAddress;

@property (nonatomic,strong)NSString            * adid;

@property (nonatomic,strong)NSIndexPath         * indexPath;

@property (nonatomic,strong)UIButton            * addAddress;

@property (nonatomic,strong)UIButton            * backButton;

//自定义导航
//@property (nonatomic,strong)WPMyNavigationBar   * nav;
@end

@implementation WPAddressSelectViewController
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
-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(5, 40, 30,30);
        [_backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(w_dismissViewControllerAnimated) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
-(UIButton *)resultAddress{
    if (!_resultAddress) {
        _resultAddress = [UIButton buttonWithType:UIButtonTypeCustom];
        _resultAddress.frame = CGRectMake(5, WINDOW_HEIGHT- 40, WINDOW_WIDTH-10, 35);
        [_resultAddress setTitle:@"新增地址" forState:UIControlStateNormal];
        _resultAddress.backgroundColor = SelfThemeColor;
        [_resultAddress addTarget:self action:@selector(goAddAddress) forControlEvents:UIControlEventTouchUpInside];
        _resultAddress.layer.masksToBounds = YES;
        _resultAddress.layer.cornerRadius  = 5;
    }
    return _resultAddress;
}

-(void)setNav{
    self.myNavItem.title = @"选择收货地址";
    UIButton *rightbtn = [[UIButton alloc] init];
    [rightbtn setTitle:@"确认地址" forState:UIControlStateNormal];
    [rightbtn sizeToFit];
    [rightbtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.myNavItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
    self.myNavItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.backButton];
    
}


-(UITableView *)tableView
{
    if (!_tableView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT - 64-49) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"WPAddressSelectTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        _tableView.rowHeight = 70;
        
    }
    return _tableView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    self.view.backgroundColor = WhiteColor;
    [self loadDatas];
    [self.view addSubview:self.addAddress];
    [self.view addSubview:self.backButton];
}

-(void)loadDatas{
    self.addressDataSource = [NSMutableArray arrayWithCapacity:3];
    [WPNetWorking createPostRequestMenagerWithUrlString:QueryAddressedUrl params:@{@"uid":[self getSelfUid]} datas:^(NSDictionary *responseObject){
        NSArray * lista = [responseObject objectForKey:@"lista"];
        for (NSDictionary * dic in lista) {
            WPAddressModel * model = [WPAddressModel mj_objectWithKeyValues:dic];
            if ([model.state integerValue] == 1) {
                [self.addressDataSource insertObject:model atIndex:0];
            }else{
                [self.addressDataSource addObject:model];
            }
        }
        [self.view addSubview:self.tableView];
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addressDataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WPAddressSelectTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.addressDataSource[indexPath.row];
    cell.select.selected = NO;
    if (indexPath == self.indexPath) {
        cell.select.selected = YES;
    }
    if (indexPath.row == 0 && !self.indexPath) {
        self.indexPath = indexPath;
        cell.select.selected = YES;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WPAddressSelectTableViewCell * cell = (WPAddressSelectTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    WPAddressSelectTableViewCell * oldCell = (WPAddressSelectTableViewCell *)[tableView cellForRowAtIndexPath:self.indexPath];
    if (indexPath != self.indexPath) {
        cell.select.selected    = !cell.select.selected;
        oldCell.select.selected = !oldCell.select.selected;
        self.indexPath          = indexPath;
    }
}


-(void)rightBtnClick{
    if (!self.indexPath) {
        [self showAlertWithAlertTitle:@"提示" message:@"请选择收货地址" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
        return;
    }
    WPAddressModel * model = self.addressDataSource[self.indexPath.row];
    if (_block) {
        _block(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)goAddAddress{
    WPAddressEditViewController * vc = [[WPAddressEditViewController alloc]initWithStyle:WPAddressNewStyle dateSource:nil];
    __weak typeof(self) weakSelf = self;
    vc.saveBlock = vc.saveBlock = ^(NSString *recipient,NSString *phone,NSString *address,NSString *detailAddress,NSInteger adid){
        WPAddressModel *model = [[WPAddressModel alloc] init];
        model.phone = phone;
        model.address = detailAddress;
        model.adid = adid;
        model.consignee = recipient;
        [weakSelf.addressDataSource addObject:model];
        [weakSelf.tableView reloadData];
    };
    vc.isPresent = YES;
    [self presentViewController:vc animated:YES completion:nil];
    
}

-(void)getAdidAndAddressWithBlock:(SelectAddressBlock)block{
    _block = block;
}

@end

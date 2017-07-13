//
//  WPOrderDetailViewController.m
//  Wongo
//
//  Created by rexsu on 2016/12/21.
//  Copyright © 2016年 Wongo. All rights reserved.
//

#import "WPOrderDetailViewController.h"
#import "WPAddressTableViewCell.h"
#import "WPOrderDetailTableViewCell.h"
#import "WPMyNavigationBar.h"

@interface WPOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSArray * dataSource;

@property (nonatomic,strong)UITableView * tableView;

@end

@implementation WPOrderDetailViewController
-(UITableView *)tableView
{
    if (!_tableView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT - 64) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"WPAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"addressCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"WPOrderDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"detailCell"];
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WPMyNavigationBar * customNav = [[WPMyNavigationBar alloc]init];
    customNav.title.text = @"订单详情";
    [self.view addSubview:customNav];
    [self.view addSubview:self.tableView];
    [customNav.leftButton addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 75;
            break;
    }
    return 330;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return self.dataSourceArray.count;
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
        {
           WPAddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell" forIndexPath:indexPath];
            return cell;
        }
            break;
    }
    WPOrderDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell" forIndexPath:indexPath];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end

//
//  WPPushConsignmentViewController.m
//  Wongo
//
//  Created by  WanGao on 2017/11/7.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPPushConsignmentViewController.h"

@interface WPPushConsignmentViewController ()<UITableViewDelegate,UITableViewDataSource>
//选择表
@property (nonatomic,strong)UITableView * tableView;
//请选择寄卖商品品种
@property (nonatomic,strong)UILabel * title;
@end

@implementation WPPushConsignmentViewController

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 120, WINDOW_WIDTH, 300) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myNavItem.title = @"发布寄卖";
    self.view.backgroundColor = WhiteColor;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

@end

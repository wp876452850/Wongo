//
//  WPMyConsignmentViewController.m
//  Wongo
//
//  Created by  WanGao on 2017/11/13.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPMyConsignmentViewController.h"
#import "WPCommodityManagementTableViewCell.h"
@interface WPMyConsignmentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataSourceArray;

@end

@implementation WPMyConsignmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(UITableView *)tableView
{
    if (!_tableView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT - 64) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 90;
        [_tableView registerNib:[UINib nibWithNibName:@"WPCommodityManagementTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        
    }
    return _tableView;
}
@end

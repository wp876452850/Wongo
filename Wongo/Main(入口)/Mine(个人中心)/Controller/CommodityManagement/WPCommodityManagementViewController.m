//
//  WPCommodityManagementViewController.m
//  Wongo
//
//  Created by rexsu on 2016/12/20.
//  Copyright © 2016年 Wongo. All rights reserved.
//  商品管理

#import "WPCommodityManagementViewController.h"
#import "WPCommodityManagementTableViewCell.h"
#import "WPMyNavigationBar.h"
#import "WPMyGoodsInformationModel.h"

@interface WPCommodityManagementViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataSourceArray;
@end

@implementation WPCommodityManagementViewController
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self loadDatas];
    self.title = @"商品管理";
    
    WPMyNavigationBar * customNav = [[WPMyNavigationBar alloc]init];
    customNav.title.text = self.title;
    [self.view addSubview:customNav];
    [customNav.leftButton addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)loadDatas{
    self.dataSourceArray = [NSMutableArray arrayWithCapacity:3];
    __weak WPCommodityManagementViewController * weakSelf = self;;
    [WPNetWorking createPostRequestMenagerWithUrlString:MyGoodsUrl params:@{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:User_ID]} datas:^(NSDictionary *responseObject) {
        NSArray * array = [responseObject objectForKey:@"goods"];
        for (int i =0; i < array.count; i++) {
            WPMyGoodsInformationModel * model = [WPMyGoodsInformationModel mj_objectWithKeyValues:array[i]];
            
            [weakSelf.dataSourceArray addObject:model];
        }
        [self.view addSubview:self.tableView];
    }];
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WPCommodityManagementTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.dataSourceArray[indexPath.row];
    [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showAlertWithAlertTitle:@"提示" message:@"是否确认删除" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确认",@"取消"] block:^{
        WPMyGoodsInformationModel * model = self.dataSourceArray[indexPath.row];
        [self.dataSourceArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        //进行删除操作
        [WPNetWorking createPostRequestMenagerWithUrlString:DeleteMyGoods params:@{@"gid":model.gid} datas:nil];
    }];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"123");
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
@end

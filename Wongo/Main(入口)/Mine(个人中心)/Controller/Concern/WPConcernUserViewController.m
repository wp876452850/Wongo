//
//  WPConcernUserViewController.m
//  Wongo
//
//  Created by rexsu on 2017/4/17.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPConcernUserViewController.h"
#import "WPFansTableViewCell.h"


@interface WPConcernUserViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView  * tableView;

@end

@implementation WPConcernUserViewController
-(UITableView *)tableView
{
    if (!_tableView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT - 64) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"WPFansTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        
    }
    return _tableView;
}

-(void)loadDatas{
    [WPNetWorking createPostRequestMenagerWithUrlString:@"" params:@{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:User_ID]} datas:^(NSDictionary *responseObject) {
        
    }];
    [self.view addSubview:self.tableView];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadDatas];
    
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return self.dataSourceArray.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end

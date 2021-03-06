//
//  WPMyDreamingViewController.m
//  Wongo
//
//  Created by rexsu on 2017/5/12.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPMyDreamingViewController.h"
#import "WPMyNavigationBar.h"
#import "WPMyDreamingTableViewCell.h"

@interface WPMyDreamingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)WPMyNavigationBar * nav;

@property (nonatomic,strong)UITableView * tableView;
@end

@implementation WPMyDreamingViewController


-(WPMyNavigationBar *)nav{
    if (!_nav) {
        _nav = [[WPMyNavigationBar alloc]init];
        [_nav.leftButton addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
        _nav.title.text = @"造梦计划";        
    }
    return _nav;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT - 64) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 245.f;
        [_tableView registerNib:[UINib nibWithNibName:@"WPMyDreamingTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        
    }
    return _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 20)];
    label.centerY = self.view.centerY;
    label.font = [UIFont boldSystemFontOfSize:15.f];
    label.textColor = TitleGrayColor;
    label.text = @"您暂未发布造梦计划";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    self.view.backgroundColor = WhiteColor;
    [self.view addSubview:self.nav];
    [self.view addSubview:self.tableView];
    [self loadDatas];
}

-(void)loadDatas{
    //FIXME:接口换一个
//    [WPNetWorking createPostRequestMenagerWithUrlString:QueryPlordersUrl params:@{@"uid":[self getSelfUid]} datas:^(NSDictionary *responseObject) {
//        
//    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return self.dataSourceArray.count;
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WPMyDreamingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end

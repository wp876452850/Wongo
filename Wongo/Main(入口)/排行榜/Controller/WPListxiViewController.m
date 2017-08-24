//
//  WPListxiViewController.m
//  Wongo
//
//  Created by  WanGao on 2017/8/23.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPListxiViewController.h"
#import "WPListOtherTableViewCell.h"
#import "WPListFirstTableViewCell.h"

@interface WPListxiViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation WPListxiViewController

-(instancetype)initWithSubid:(NSString *)subid{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"排行榜";
    [self setupTableView];
}

-(void)setupTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"WPListFirstTableViewCell" bundle:nil] forCellReuseIdentifier:@"first"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WPListOtherTableViewCell" bundle:nil] forCellReuseIdentifier:@"other"];
    [self.view addSubview:self.tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 220;
    }
    return 70;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        WPListFirstTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"first" forIndexPath:indexPath];
        return cell;
    }
    WPListOtherTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"other" forIndexPath:indexPath];
    return cell;
}
@end

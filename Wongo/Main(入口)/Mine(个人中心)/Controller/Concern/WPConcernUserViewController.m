//
//  WPConcernUserViewController.m
//  Wongo
//
//  Created by rexsu on 2017/4/17.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPConcernUserViewController.h"
#import "WPFansTableViewCell.h"
#import "WPFansModel.h"


@interface WPConcernUserViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView  * tableView;

@property (nonatomic,strong)NSMutableArray * focusArray;

@property (nonatomic,strong)NSMutableArray * focusInformationArray;

@end

@implementation WPConcernUserViewController
-(NSMutableArray *)focusArray{
    if (!_focusArray) {
        _focusArray = [NSMutableArray sharedFocusArray];
    }
    return _focusArray;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT - 64) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80.f;
        [_tableView registerNib:[UINib nibWithNibName:@"WPFansTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.myNavItem.title = @"关注";
    [self loadDatas];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

-(void)loadDatas{
    typeof(self) weakSelf = self;
    self.focusInformationArray = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0; i < self.focusArray.count; i++) {
        [WPNetWorking createPostRequestMenagerWithUrlString:UserGetUrl params:@{@"uid":_focusArray[i]} datas:^(NSDictionary *responseObject) {
            [weakSelf.focusInformationArray addObject:[WPFansModel mj_objectWithKeyValues:responseObject]];
            if (i+1>=_focusArray.count) {
                [weakSelf.tableView reloadData];
            }
        }];
    }
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.focusInformationArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WPFansTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
    cell.model = self.focusInformationArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end

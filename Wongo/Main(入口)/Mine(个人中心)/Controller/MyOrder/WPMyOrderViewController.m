//
//  WPMyOrderViewController.m
//  Wongo
//
//  Created by rexsu on 2016/12/15.
//  Copyright © 2016年 Wongo. All rights reserved.
//  我的订单

#import "WPMyOrderViewController.h"
#import "WPMyOrderTableViewCell.h"
#import "WPOrderDetailViewController.h"
#import "WPMyNavigationBar.h"

#define TopTitleArray @[@"买入",@"售出"]
@interface WPMyOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
//表
@property (nonatomic,strong)UITableView * tableView;
//记录按钮
@property (nonatomic,strong)UIButton * selectButton;
//头部标题
@property (nonatomic,strong)NSArray * topTitleArray;
//水平横线
@property (nonatomic,strong)UILabel * horizontalLine;
@end

@implementation WPMyOrderViewController

-(UILabel *)horizontalLine{
    if (!_horizontalLine) {
        _horizontalLine = [[UILabel alloc]init];
        _horizontalLine.bounds = CGRectMake(0, 0, WINDOW_WIDTH / 2 - 40, 1);
        
        _horizontalLine.backgroundColor = ColorWithRGB(255, 145, 55);
    }
    return _horizontalLine;
}
-(UIButton *)selectButton
{
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _selectButton;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 108, WINDOW_WIDTH, WINDOW_HEIGHT - 108) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 200;
        [_tableView registerNib:[UINib nibWithNibName:@"WPMyOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        for (int i = 0; i < 2; i ++) {
            [self createTopButtonWithTag:i];
        }
        
    }
    return _tableView;
}

#pragma mark - 创建顶部2个按钮
- (void)createTopButtonWithTag:(NSInteger)tag{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(tag * WINDOW_WIDTH / 2, 64,WINDOW_WIDTH / 2, 44);
    button.tag = tag;
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:ColorWithRGB(0, 0, 0) forState:UIControlStateNormal];
    [button setTitleColor:ColorWithRGB(255, 145, 55) forState:UIControlStateSelected];
    if (tag == 0) {
        button.selected = YES;
        _horizontalLine.center = CGPointMake(WINDOW_WIDTH / 4, CGRectGetMidY(button.frame) - 1);
    }
    [button addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:self.topTitleArray[tag] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
}

-(void)topButtonClick:(UIButton *)sender
{
    _horizontalLine.center = CGPointMake(WINDOW_WIDTH / 4, CGRectGetMidY(sender.frame) - 1);
    switch (sender.tag) {
        case 0:
        {
            //请求服务器，得到买入数据
        }
            break;
            
        case 1:
        {
            //请求服务器，得到售出数据
        }
            break;
    }
    self.horizontalLine.center = CGPointMake(sender.center.x, _horizontalLine.center.y);
    self.selectButton.selected = NO;
    sender.selected = !sender.selected;
    self.selectButton = sender;
}

#pragma mark - ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    self.topTitleArray = TopTitleArray;
    WPMyNavigationBar * customNav = [[WPMyNavigationBar alloc]init];
    customNav.title.text = self.title;
    [self.view addSubview:customNav];
    [customNav.leftButton addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:self.horizontalLine];
    [self.view addSubview:self.tableView];
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}



#pragma mark - UITableViewDelegate,UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return self.dataSourceArray.count;
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WPMyOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
